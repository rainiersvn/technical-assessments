import * as express from "express"; 
import { BASE_URL, HOST, PORT } from "./constants";
import { checkActiveUserStreams } from "./streamprocessor";
import { TUserStreamRequest } from "./types";
import * as bodyParser from "body-parser";
import { v4 as uuid } from "uuid";

const app = express();

/**
 * This endpoint is purley to check if the API is alive
 */
app.get('/about', (req: TUserStreamRequest, res) => {
  res.send('API is running');
});

app.post('/checkUserStreams', bodyParser.json(), async (req, res) => {
  const requestId = uuid();
  console.log(`New request initiated - ${requestId}`)
  const body: TUserStreamRequest = req.body;
  const userId = body.userId;
  const streamId = body.streamId;
  const isValid = await checkActiveUserStreams(userId, streamId);
  console.log(`Request end - ${requestId}`)
  res.send(isValid);
});

app.listen(PORT, HOST);
console.log(`Running on ${BASE_URL}`);
