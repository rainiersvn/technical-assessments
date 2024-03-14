/**
 * Server connection details.
 */
export const PORT = 8080;
export const HOST = '0.0.0.0';
export const BASE_URL = `http://${HOST}:${PORT}`;

/**
 * Validation map used to keep track of how many streams a user has, this can be changed to DB integration,
 * i.e. Database connection object that can persist information to improve API/Data redundancy,
 */
export const ACTIVE_AMOUNT_OF_USER_STREAMS: Map<string, Array<string>> = new Map<string, Array<string>>();