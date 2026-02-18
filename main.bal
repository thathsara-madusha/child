import ballerina/http;

listener http:Listener httpDefaultListener = http:getDefaultListener();

service /data on httpDefaultListener {
    resource function get .() returns error|json {
        do {
            record {string message;} var1 = check httpClient->get("/data");
            string temp = string `${var1.message} World!`;
            return {
                body: {message: temp},
                headers: {contentType: "application/json"}
            };
        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }

}
