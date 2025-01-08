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

import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.marketing.emails as hsmemails;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

public function main() returns error? {

    // Create the config for authorization to the API
    hsmemails:OAuth2RefreshTokenGrantConfig auth = {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER // this line should be added to create auth object.
    };

    hsmemails:ConnectionConfig config = {auth: auth};

    // Initialize the Hubspot Marketing Email Client
    hsmemails:Client hubspotMarketingEmailClient = check new hsmemails:Client(config);

    // Get all marketing emails
    hsmemails:CollectionResponseWithTotalPublicEmailForwardPaging emailsResponse = check hubspotMarketingEmailClient->/({});

    // Change this to your new email email address
    // NOTE: To add an email with your custom domain, the domain must first 
    // be connected to Hubspot.
    // https://knowledge.hubspot.com/marketing-email/manage-email-authentication-in-hubspot
    final string newReplyToEmailAddress = "new_reply_address@example.com";

    foreach hsmemails:PublicEmail email in emailsResponse.results {
        io:println(email.state);
        // Apply the change only to draft emails
        if email.state == "DRAFT" {
            hsmemails:PublicEmail updated = check hubspotMarketingEmailClient->/[email.id].patch({
                'from: {
                    replyTo: newReplyToEmailAddress,
                    customReplyTo: newReplyToEmailAddress
                }
            });
            io:println("Updated email ", updated.id, "replyTo and customReplyTo address: ", updated.'from.replyTo);
        }
    }
}
