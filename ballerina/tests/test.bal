// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/oauth2;
import ballerina/os;
import ballerina/test;
import ballerina/time;

final string clientId = os:getEnv("HUBSPOT_CLIENT_ID");
final string clientSecret = os:getEnv("HUBSPOT_CLIENT_SECRET");
final string refreshToken = os:getEnv("HUBSPOT_REFRESH_TOKEN");

// isLiveSever is set to false by default, set to true in Config.toml
configurable boolean isLiveServer = false;
configurable string serviceUrl = isLiveServer ? "https://api.hubapi.com/marketing/v3/emails" : "http://localhost:8080";

OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER // this line should be added to create auth object.
};

final Client hubspotClient = check initClient();

isolated function initClient() returns Client|error {
    if isLiveServer {
        OAuth2RefreshTokenGrantConfig auth = {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            credentialBearer: oauth2:POST_BODY_BEARER
        };
        return check new ({auth}, serviceUrl);
    }
    return check new ({
        auth: {
            token: "test-token"
        }
    }, serviceUrl);
}

// Change this value and test
final int days = 40;

string testEmailId = "";
string cloneEmailId = "";
string draftSubject = "New draft subject";

@test:Config {
    groups: ["mock_tests"]
}
public function testCreateEmailEp() returns error? {
    // Create a new email. Will throw error if the response type is not PublicEmail
    PublicEmail response = check hubspotClient->/.post({
        name: "Test email using API",
        subject: "Marketing Email using API!"
    });

    // Store the id of the created email for use in other testcases
    testEmailId = response.id;
}

@test:Config {
    groups: ["mock_tests"],
    dependsOn: [testCreateEmailEp]
}
public function testCloneEmailEp() returns error? {
    // Clone the email created in testCreateEmailEp testcase.
    // Will throw an error if return type does not match PublicEmail
    PublicEmail response = check hubspotClient->/clone.post({
        id: testEmailId,
        cloneName: "Cloned Email"
    });

    // Store the cloned email's id for use in other testcases
    cloneEmailId = response.id;
}

@test:Config {
    dependsOn: [testCreateEmailEp, testCloneEmailEp],
    enable: isLiveServer
}
public function testRetrieveEmailEp() returns error? {
    // Retrieve test email and cloned email
    PublicEmail response = check hubspotClient->/[testEmailId];
    PublicEmail clone_response = check hubspotClient->/[cloneEmailId];
    test:assertEquals(response.id, testEmailId);
    test:assertEquals(clone_response.id, cloneEmailId);
}

@test:Config {
    dependsOn: [testCreateEmailEp],
    enable: isLiveServer
}
public function testCreateDraftEp() returns error? {
    // Create a draft of the email
    PublicEmail response = check hubspotClient->/[testEmailId]/draft.patch({
        subject: draftSubject
    });

    // Check that the subject has been updated correctly
    test:assertEquals(response.subject, draftSubject);

    // Get the draft using the get draft endpoint
    PublicEmail draftResponse = check hubspotClient->/[testEmailId]/draft();

    // Retrieve the original email
    PublicEmail originalResponse = check hubspotClient->/[testEmailId];

    // Assert that the subject is different in draft
    test:assertNotEquals(draftResponse.subject, originalResponse.subject);
}

@test:Config {
    dependsOn: [testCreateDraftEp],
    enable: isLiveServer
}
public function testResetDraftEp() returns error? {
    http:Response response = check hubspotClient->/[testEmailId]/draft/reset.post();

    // Assert that the status code is 204
    test:assertEquals(response.statusCode, 204);

    // Retrieve the email from the draft endpoint and check that the subject is changed back
    PublicEmail draftResponse = check hubspotClient->/[testEmailId]/draft();
    test:assertNotEquals(draftResponse.subject, draftSubject);
}

@test:Config {
    dependsOn: [testCreateDraftEp],
    enable: isLiveServer
}
public function testUpdateandRestoreEps() returns error? {
    // Update email subject
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

@test:Config {
    groups: ["mock_tests"],
    dependsOn: [testCreateEmailEp, testCloneEmailEp]
}
public function testEmailsEp() returns error? {
    CollectionResponseWithTotalPublicEmailForwardPaging response = check hubspotClient->/();
    test:assertEquals(response.total, response.results.length());
}

@test:Config {
    dependsOn: [testCreateEmailEp],
    enable: isLiveServer
}
public function testGetDraftEp() returns error? {
    PublicEmail response = check hubspotClient->/[testEmailId]/draft();
    test:assertEquals(response.id, testEmailId);
}

@test:Config {
    dependsOn: [testCreateEmailEp],
    enable: isLiveServer
}
isolated function testListEp() returns error? {
    AggregateEmailStatistics response = check hubspotClient->/statistics/list({},
        {
            startTimestamp: time:utcToString(time:utcAddSeconds(time:utcNow(), -86400 * days)),
            endTimestamp: time:utcToString(time:utcNow())
        }
    );

    // Check that each part of the response response is not null
    test:assertTrue(response.aggregate !is ());
    test:assertTrue(response.campaignAggregations !is ());
    test:assertTrue(response.emails !is ());
}

@test:Config {
    dependsOn: [testCreateEmailEp],
    enable: isLiveServer
}
isolated function testHistogramEp() returns error? {
    CollectionResponseWithTotalEmailStatisticIntervalNoPaging response = check
    hubspotClient->/statistics/histogram({},
        {
            startTimestamp: time:utcToString(time:utcAddSeconds(time:utcNow(), -86400 * days)),
            endTimestamp: time:utcToString(time:utcNow()),
            interval: "DAY"
        }
    );

    // If there are no emails sent within the time span, the response will be of length 1
    // Else it should be of length equal to interval * timespan  + 1
    // Example: Length of results array should be 24*3 if the interval is HOUR and
    // duration between startTimestamp and endTimestamp is 3 days
    // In this case it should be equal to number of days + 1
    if response.results.length() > 1 {
        test:assertEquals(response.results.length(), days + 1);
        test:assertEquals(response.total, days + 1);
    }
}

@test:Config {
    dependsOn: [testCloneEmailEp, testUpdateandRestoreEps, testEmailsEp, testRetrieveEmailEp, testHistogramEp],
    enable: isLiveServer
}
public function testDeleteEndpoint() returns error? {
    // Delete the created email and its clone
    http:Response response_test_email = check hubspotClient->/[testEmailId].delete();
    http:Response response_clone_email = check hubspotClient->/[cloneEmailId].delete();

    // Check if the response status is 204
    test:assertEquals(response_test_email.statusCode, 204);

    // Check if the response status is 204
    test:assertEquals(response_clone_email.statusCode, 204);
}
