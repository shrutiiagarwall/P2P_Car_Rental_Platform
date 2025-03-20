// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract P2PCarRental {
    struct Car {
        uint256 id;
        address payable owner;
        string details;
        uint256 pricePerDay;
        bool isAvailable;
    }

    mapping(uint256 => Car) public cars;
    uint256 public nextCarId;
    
    event CarListed(uint256 id, address owner, string details, uint256 pricePerDay);
    event CarRented(uint256 id, address renter, uint256 daysRented, uint256 totalPrice);

    function listCar(string memory details, uint256 pricePerDay) public {
        cars[nextCarId] = Car(nextCarId, payable(msg.sender), details, pricePerDay, true);
        emit CarListed(nextCarId, msg.sender, details, pricePerDay);
        nextCarId++;
    }

    function rentCar(uint256 carId, uint256 daysRented) public payable {
        Car storage car = cars[carId];
        require(car.isAvailable, "Car not available for rent");
        uint256 totalPrice = car.pricePerDay * daysRented;
        require(msg.value >= totalPrice, "Insufficient payment");

        car.owner.transfer(msg.value);
        car.isAvailable = false;
        
        emit CarRented(carId, msg.sender, daysRented, totalPrice);
    }
}
