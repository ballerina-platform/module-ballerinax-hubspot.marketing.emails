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
        clientId,
        clientSecret,
        refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER // this line should be added to create auth object.
    };

    // Initialize the Hubspot Marketing Email Client
    hsmemails:Client hubspotMarketingEmailClient = check new ({auth});

    // Change these values
    // Timestamps must be in ISO 8601 format
    string startTimestamp = "2025-01-01T10:00:00Z";
    string endTimestamp = "2025-01-31T10:00:00Z";
    "YEAR"|"QUARTER"|"MONTH"|"WEEK"|"DAY"|"HOUR"|"QUARTER_HOUR"|"MINUTE"|"SECOND" interval;
    interval = "DAY";


    // First get the aggregated stats from Hubspot
    hsmemails:AggregateEmailStatistics aggreagate = check hubspotMarketingEmailClient->/statistics/list({},{
                startTimestamp,
                endTimestamp
    });

    io:println(string `***AGGREGATED STATISTICS FOR THE TIME PERIOD FROM ${startTimestamp} TO ${endTimestamp}`);

    io:println("IDS OF EMAILS SENT OUT, ");
    io:println(aggreagate.emails);

    io:print("AGGREGATE STATISTICS: ");
    io:println(aggreagate.aggregate);

    hsmemails:CollectionResponseWithTotalEmailStatisticIntervalNoPaging histogram = check
    hubspotMarketingEmailClient->/statistics/histogram({},
        {
            startTimestamp,
            endTimestamp,
            interval
        }
    );

    io:println(`${"\n\n\n"}***STATISTICS FOR THE TIME PERIOD FROM ${startTimestamp} TO ${endTimestamp} FOR EACH INTERVAL ${interval}`);

    foreach hsmemails:EmailStatisticInterval data_record in histogram.results {
        io:println("INTERVAL: ", data_record.interval, " STATISTICS: ", data_record.aggregations);
    }    
}
