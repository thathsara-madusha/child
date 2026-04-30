import ballerina/http;
import ballerina/io;
import ballerina/os;

listener http:Listener httpDefaultListener = new (9091);

service /retrieve on httpDefaultListener {
    resource function get .() returns error|record {|
        *http:Ok;
        json body;
        record {|
            (string|int|boolean|string[]|int[]|boolean[])...;
        |} headers?;
    |} {
        do {
            string mountPath = os:getEnv("CHOREO_CON50_MOUNT_PATH");
            if mountPath == "" {
                return error("CHOREO_CON50_MOUNT_PATH environment variable is not set");
            }
            string filePath = mountPath + "/message.txt";
            string message = check io:fileReadString(filePath);
            return {
                body: {message: message},
                headers: {
                    "Content-Type": "application/json"
                }
            };
        } on fail error err {
            return error("unhandled error", err);
        }
    }
}
