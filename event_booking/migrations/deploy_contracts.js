const EventBooking = artifacts.require("EventBooking");

module.exports = function (deployer) {
    deployer.deploy(EventBooking);
};
