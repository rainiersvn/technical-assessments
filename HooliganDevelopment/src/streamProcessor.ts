import { ACTIVE_AMOUNT_OF_USER_STREAMS } from "./constants";

export async function checkActiveUserStreams(userId: string, streamId: string) {
    let isValidStream = false;
 
    if(ACTIVE_AMOUNT_OF_USER_STREAMS.has(userId)) {
        const activeUserStreams = ACTIVE_AMOUNT_OF_USER_STREAMS.get(userId);
        console.log("Checking user's new stream.")
        if(!activeUserStreams.includes(streamId) && activeUserStreams.length+1 <= 3) {
            console.log("Valid stream found, adding to active stream list.")
            activeUserStreams.push(streamId);
            ACTIVE_AMOUNT_OF_USER_STREAMS.set(userId, activeUserStreams);
            isValidStream = true
            return isValidStream = true;
        } else {
            console.log("Not a valid stream, blocking new stream request");
            return isValidStream;
        }
   
    } else {
        console.log("New user found, adding stream to list of active streams");
        ACTIVE_AMOUNT_OF_USER_STREAMS.set(userId, [streamId]);
        isValidStream = true;
    }
    
    return isValidStream;
}