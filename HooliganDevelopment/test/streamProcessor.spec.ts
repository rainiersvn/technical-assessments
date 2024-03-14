import { checkActiveUserStreams } from "../src/streamprocessor";
import { v4 as uuid } from "uuid";
import { ACTIVE_AMOUNT_OF_USER_STREAMS } from "../src/constants";

afterEach(() => {
    // We clear the cache of user streams after each test as to not interfere with the next set of tests.
    ACTIVE_AMOUNT_OF_USER_STREAMS.clear();
});

describe("streamProcessor", () => {
    it("Will add first time new user's active stream for tracking", async () => {
        // We spy the console.log in each test so that it doesn't interfere with other tests.
        console.log = jest.fn();
        const userId = "Rainier";
        const streamId = uuid();
        const resp = await checkActiveUserStreams(userId, streamId);
        
        expect(resp).toBeTruthy();
        expect(console.log).toHaveBeenCalledWith("New user found, adding stream to list of active streams");
        expect(ACTIVE_AMOUNT_OF_USER_STREAMS.has(userId)).toBeTruthy();
        const userData = ACTIVE_AMOUNT_OF_USER_STREAMS.get(userId);
        expect(userData).toEqual([streamId])
    });

    it("Will track concurrent active streams for a single user, up to three max", async () => {
        console.log = jest.fn();
        const userId = "Rainier";
        const streamOne = uuid();
        const streamTwo = uuid();
        const streamThree = uuid();
        const streamFour = uuid();
        const respOne = await checkActiveUserStreams(userId, streamOne);
        const respTwo = await checkActiveUserStreams(userId, streamTwo);
        const respThree = await checkActiveUserStreams(userId, streamThree);
        const respFour = await checkActiveUserStreams(userId, streamFour);
        
        expect(respOne).toBeTruthy();
        expect(respTwo).toBeTruthy();
        expect(respThree).toBeTruthy();
        expect(respFour).toBeFalsy();
        expect(console.log).toHaveBeenCalledWith("New user found, adding stream to list of active streams");
        expect(console.log).toHaveBeenCalledWith("Checking user's new stream.");
        expect(console.log).toHaveBeenCalledWith("Valid stream found, adding to active stream list.");
        expect(console.log).toHaveBeenCalledWith("Not a valid stream, blocking new stream request");
        expect(ACTIVE_AMOUNT_OF_USER_STREAMS.has(userId)).toBeTruthy();
        const userData = ACTIVE_AMOUNT_OF_USER_STREAMS.get(userId);
        expect(userData).toEqual([
            streamOne,
            streamTwo,
            streamThree
        ])
    });

    it("Will NOT add duplicate stream to same user", async () => {
        console.log = jest.fn();
        const userId = "Rainier";
        const streamId = uuid();
        const logStreamOneResp = await checkActiveUserStreams(userId, streamId);
        const logStreamTwoResp = await checkActiveUserStreams(userId, streamId);
        
        expect(logStreamOneResp).toBeTruthy();
        expect(logStreamTwoResp).toBeFalsy();
        expect(console.log).toHaveBeenCalledWith("New user found, adding stream to list of active streams");
        expect(console.log).toHaveBeenCalledWith("Checking user's new stream.");
        expect(console.log).toHaveBeenCalledWith("Not a valid stream, blocking new stream request");
        expect(ACTIVE_AMOUNT_OF_USER_STREAMS.has(userId)).toBeTruthy();
        const userData = ACTIVE_AMOUNT_OF_USER_STREAMS.get(userId);
        expect(userData).toEqual([streamId])
    });
});