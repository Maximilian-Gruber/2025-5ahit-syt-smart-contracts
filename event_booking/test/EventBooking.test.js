const EventBooking = artifacts.require("EventBooking");

contract("EventBooking", (accounts) => {
    let contract;
    before(async () => {
        contract = await EventBooking.deployed();
    });

    it("should create an event", async () => {
        await contract.createEvent("Blockchain Conference", "2025-06-01", web3.utils.toWei("0.1", "ether"), 100, { from: accounts[0] });
        const event = await contract.getEvent(0);
        assert.equal(event.name, "Blockchain Conference");
    });

    it("should allow ticket purchase", async () => {
        await contract.buyTicket(0, { from: accounts[1], value: web3.utils.toWei("0.1", "ether") });
        const attendee = await contract.attendees(0, accounts[1]);
        assert.equal(attendee, true);
    });
});
