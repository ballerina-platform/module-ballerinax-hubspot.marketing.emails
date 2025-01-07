import ballerina/http;
import ballerina/oauth2;
// import ballerina/io;
import ballerina/os;
import ballerina/test;
import ballerina/time;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

configurable boolean isServerLocal = os:getEnv("IsServerLocal") == "true";

OAuth2RefreshTokenGrantConfig auth = {
    clientId: clientId,
    clientSecret: clientSecret,
    refreshToken: refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER // this line should be added to create auth object.
};

ConnectionConfig config = {auth: auth};
final string serviceURL = isServerLocal ? "localhost:8080" : "https://api.hubapi.com/marketing/v3/emails";
final Client hubspotClient = check new Client(config, serviceURL);

// Change this value and test
final int days = 40;

string testEmailId = "";
string cloneEmailId = "";
string draftSubject = "New draft subject";

@test:Config
public function testCreateEmailEp() returns error? {
    PublicEmail|error response = check hubspotClient->/.post({
        name: "Test email using API",
        subject: "Marketing Email using API!"
    });

    if response is PublicEmail {
        testEmailId = response.id;
    } else {
        test:assertFail("Failed to create new email");
    }

}

@test:Config {dependsOn: [testCreateEmailEp]}
public function testCloneEmailEp() returns error? {
    PublicEmail|error response = check hubspotClient->/clone.post({
        id: testEmailId,
        cloneName: "Cloned Email"
    });

    if response is PublicEmail {
        cloneEmailId = response.id;
    } else {
        test:assertFail("Failed to clone new email");
    }
}

@test:Config {dependsOn: [testCreateEmailEp, testCloneEmailEp]}
public function testRetrieveEmailEp() returns error? {
    PublicEmail|error response = check hubspotClient->/[testEmailId];

    if response is PublicEmail {
        test:assertFalse(response.id != testEmailId, "Error: Incorrect email retrieved, expected test email");
    } else {
        test:assertFail("Failed to retrieve email created during testing.");
    }

    PublicEmail|error clone_response = check hubspotClient->/[cloneEmailId];

    if clone_response is PublicEmail {
        test:assertFalse(clone_response.id != cloneEmailId, "Error: Incorrect email retrieved, expected cloned email");
    } else {
        test:assertFail("Failed to retrieve email cloned during testing.");
    }
}

@test:Config {dependsOn: [testCreateEmailEp]}
public function testCreateDraftEp() {
    PublicEmail|error response = hubspotClient->/[testEmailId]/draft.patch({
        subject: draftSubject
    });

    // Check that the subject has been updated correctly
    if response is PublicEmail {
        test:assertEquals(response.subject, draftSubject);
    } else {
        test:assertFail("Failed to create draft");
    }

    // Get the draft using the get draft endpoint
    PublicEmail|error draftResponse = hubspotClient->/[testEmailId]/draft();

    // Retrieve the original email
    PublicEmail|error originalResponse = hubspotClient->/[testEmailId];

    // Assert that the subject is different in draft
    if draftResponse is PublicEmail && originalResponse is PublicEmail {
        test:assertNotEquals(draftResponse, originalResponse);
    } else {
        test:assertFail("Failed to retrieve draft and/or email");
    }
}

@test:Config {dependsOn: [testCreateDraftEp]}
public function testResetDraftEp() returns error? {
    http:Response response = check hubspotClient->/[testEmailId]/draft/reset.post();

    // Assert that the status code is 204
    test:assertEquals(response.statusCode, 204);

    // Retrieve the email from the draft endpoint and check that the subject is changed back
    PublicEmail draftResponse = check hubspotClient->/[testEmailId]/draft();
    test:assertNotEquals(draftResponse.subject, draftSubject);
}

@test:Config {dependsOn: [testCreateDraftEp]}
public function testUpdateandRestoreEps() returns error? {
    PublicEmail response = check hubspotClient->/[testEmailId].patch({
        subject: "Updated Subject"
    });

    // Retrieve the email and check the subject
    PublicEmail updatedResponse = check hubspotClient->/[testEmailId];
    test:assertEquals(updatedResponse.subject, "Updated Subject");

    // Update the subject again to make another revision
    PublicEmail updatedResposne = check hubspotClient->/[testEmailId].patch({
        subject: "Updated Subject, again!"
    });

    // Retrieve the email and check the subject
    PublicEmail twiceUpdatedResponse = check hubspotClient->/[testEmailId];
    test:assertEquals(twiceUpdatedResponse.subject, "Updated Subject, again!");

    // Get all revisions are fetched using the /revisions endpoint
    CollectionResponseWithTotalVersionPublicEmail allRevisions = check hubspotClient->/[testEmailId]/revisions();

    // Restore back to the first revision
    http:Response firstRevisionRestored = check hubspotClient->/[testEmailId]/revisions/[allRevisions.results[1].id]/restore.post({});
    // Check that the response status is 204
    test:assertEquals(firstRevisionRestored.statusCode, 204);
    // Verify that the subject is same as it was in the first revision
    PublicEmail restoredVersion = check hubspotClient->/[testEmailId];
    test:assertEquals(restoredVersion.subject, "Updated Subject");

}

@test:Config {dependsOn: [testCreateEmailEp, testCloneEmailEp, testCreateDraftEp]}
public function testEmailsEp() returns error? {
    CollectionResponseWithTotalPublicEmailForwardPaging|error response = hubspotClient->/();

    if response is CollectionResponseWithTotalPublicEmailForwardPaging {
        test:assertEquals(response.total, response.results.length());
    } else {
        test:assertFail("Failed to get response from ");
    }
}

@test:Config {dependsOn: [testCreateEmailEp]}
public function testGetDraftEp() {
    PublicEmail|error response = hubspotClient->/[testEmailId]/draft();

    if response is PublicEmail {
        test:assertTrue(response.id == testEmailId);
    } else {
        test:assertFail("Error: Could not get draft for test email");
    }
}

@test:Config {dependsOn: [testCreateEmailEp]}
isolated function testListEp() returns error? {
    AggregateEmailStatistics|error response = check hubspotClient->/statistics/list({},
        {
            startTimestamp: time:utcToString(time:utcAddSeconds(time:utcNow(), -86400 * days)),
            endTimestamp: time:utcToString(time:utcNow())
        }
    );

    if response is AggregateEmailStatistics {
        // Check that each part of the response response is not null
        test:assertTrue(response.aggregate !is ());
        test:assertTrue(response.campaignAggregations !is ());
        test:assertTrue(response.emails !is ());
    } else {
        test:assertFail("Failed to get response for endpoint /statistics/list");
    }
}

@test:Config {dependsOn: [testCreateEmailEp]}
isolated function testHistogramEp() returns error? {
    CollectionResponseWithTotalEmailStatisticIntervalNoPaging|error response = check
    hubspotClient->/statistics/histogram({},
        {
            startTimestamp: time:utcToString(time:utcAddSeconds(time:utcNow(), -86400 * days)),
            endTimestamp: time:utcToString(time:utcNow()),
            interval: "DAY"
        }
    );

    if response is CollectionResponseWithTotalEmailStatisticIntervalNoPaging {
        // If there are no emails sent within the time span, the response will be of length 1
        // Else it should be of length equal to interval * timespan  + 1
        // Example: Length of results array should be 24*3 if the interval is HOUR and
        // duration between startTimestamp and endTimestamp is 3 days
        // In this case it should be equal to number of days + 1
        if (response.results.length() > 1) {
            test:assertEquals(response.results.length(), days + 1);
            test:assertEquals(response.total, days + 1);
        }
    } else {
        test:assertFail("Failed to get response from /statistics/histogram");
    }
}

@test:Config {dependsOn: [testCloneEmailEp, testUpdateandRestoreEps, testEmailsEp, testRetrieveEmailEp, testHistogramEp]}
public function testDeleteEndpoint() returns error? {
    // Delete the created email and the clone
    http:Response|error response_test_email = check hubspotClient->/[testEmailId].delete();
    http:Response|error response_clone_email = check hubspotClient->/[cloneEmailId].delete();

    if response_test_email is http:Response {
        // Check if the response status is 204
        test:assertEquals(response_test_email.statusCode, 204);
    } else {
        test:assertFail("Failed to delete test email.");
    }

    if response_clone_email is http:Response {
        // Check if the response status is 204
        test:assertEquals(response_clone_email.statusCode, 204);
    } else {
        test:assertFail("Failed to delete test email.");
    }
}
