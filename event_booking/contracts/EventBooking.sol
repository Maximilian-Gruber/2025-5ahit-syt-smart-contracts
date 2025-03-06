// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EventBooking {
    struct Event {
        string name;
        string date;
        uint256 price;
        uint256 totalTickets;
        uint256 soldTickets;
        address payable organizer;
    }

    mapping(uint256 => Event) public events;
    mapping(uint256 => mapping(address => bool)) public attendees;
    uint256 public nextEventId;

    event EventCreated(uint256 eventId, string name, uint256 price, uint256 totalTickets);
    event TicketPurchased(uint256 eventId, address buyer);

    function createEvent(
        string memory _name,
        string memory _date,
        uint256 _price,
        uint256 _totalTickets
    ) public {
        require(_totalTickets > 0, "Total tickets must be greater than zero");

        events[nextEventId] = Event({
            name: _name,
            date: _date,
            price: _price,
            totalTickets: _totalTickets,
            soldTickets: 0,
            organizer: payable(msg.sender)
        });

        emit EventCreated(nextEventId, _name, _price, _totalTickets);
        nextEventId++;
    }

    function buyTicket(uint256 _eventId) public payable {
        Event storage e = events[_eventId];
        require(msg.value == e.price, "Incorrect ticket price");
        require(e.soldTickets < e.totalTickets, "Sold out");
        require(!attendees[_eventId][msg.sender], "Already purchased");

        e.soldTickets++;
        attendees[_eventId][msg.sender] = true;
        e.organizer.transfer(msg.value);

        emit TicketPurchased(_eventId, msg.sender);
    }

    function getEvent(uint256 _eventId)
        public
        view
        returns (
            string memory name,
            string memory date,
            uint256 price,
            uint256 totalTickets,
            uint256 soldTickets,
            address organizer
        )
    {
        Event storage e = events[_eventId];
        return (e.name, e.date, e.price, e.totalTickets, e.soldTickets, e.organizer);
    }
}
