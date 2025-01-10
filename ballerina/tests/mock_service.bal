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

service / on new http:Listener(8080) {

    resource function post .(http:Caller caller, http:Request req) returns error? {
        // Simulate the response for creating a new email
        json payload = check req.getJsonPayload();
        string subject = check payload.subject.ensureType();
        string emailName = check payload.'name.ensureType();
        json response = {
            "id": "test-email-id",
            "name": emailName,
            "subject": subject,
            "feedbackSurveyId": "survey-id",
            "publishDate": "2023-01-01T10:00:00Z",
            "isTransactional": false,
            "language": "en-us",
            "type": "MARKETING_SINGLE_SEND_API",
            "content": {
                "html": "<html><body><h1>Test Email</h1></body></html>",
                "plainText": "Test Email"
            },
            "businessUnitId": "business-unit-id",
            "webversion": {
                "url": "https://example.com/webversion",
                "enabled": true
            },
            "workflowNames": ["workflow1", "workflow2"],
            "archived": false,
            "createdAt": "2023-09-01T10:00:00Z",
            "stats": {
                "counters": {
                    "sent": 1,
                    "open": 0,
                    "delivered": 0,
                    "bounce": 1,
                    "unsubscribed": 0,
                    "click": 0,
                    "reply": 0,
                    "dropped": 0,
                    "selected": 1,
                    "spamreport": 0,
                    "suppressed": 0,
                    "hardbounced": 0,
                    "softbounced": 1,
                    "pending": 0,
                    "contactslost": 0,
                    "notsent": 0
                },
                "deviceBreakdown": {
                    "open_device_type": {
                        "computer": 0,
                        "mobile": 0,
                        "unknown": 0
                    },
                    "click_device_type": {
                        "computer": 0,
                        "mobile": 0,
                        "unknown": 0
                    }
                },
                "qualifierStats": {},
                "ratios": {
                    "clickratio": 0,
                    "clickthroughratio": 0,
                    "deliveredratio": 0,
                    "openratio": 0,
                    "replyratio": 0,
                    "unsubscribedratio": 0,
                    "spamreportratio": 0,
                    "bounceratio": 100,
                    "hardbounceratio": 0,
                    "softbounceratio": 100,
                    "contactslostratio": 0,
                    "pendingratio": 0,
                    "notsentratio": 0
                }
            },
            "jitterSendTime": false,
            "from": {
                "email": "sender@example.com",
                "name": "Sender Name"
            },
            "state": "DRAFT",
            "createdById": "user-id",
            "updatedAt": "2025-01-01T10:00:00Z",
            "rssData": {
                "feedUrl": "https://example.com/rss",
                "feedTitle": "RSS Feed"
            },
            "publishedAt": "2023-10-01T10:00:00Z",
            "publishedById": "publisher-id",
            "isPublished": true,
            "testing": {
                "abTest": true,
                "testName": "A/B Test"
            },
            "updatedById": "updater-id",
            "folderId": 123,
            "subscriptionDetails": {
                "officeLocationId": "office-id",
                "preferencesGroupId": "preferences-group-id",
                "subscriptionId": "subscription-id"
            },
            "activeDomain": "example.com",
            "campaign": "campaign-id",
            "to": {
                "contactIds": {
                    "included": ["contact1", "contact2"],
                    "excluded": ["contact3"]
                },
                "contactLists": {
                    "included": ["list1", "list2"],
                    "excluded": ["list3"]
                },
                "limitSendFrequency": true,
                "suppressGraymail": false
            },
            "subcategory": "batch",
            "campaignName": "Campaign Name",
            "sendOnPublish": true
        };

        check caller->respond(response);
    }

    resource function post clone(http:Caller caller, http:Request req) returns error? {
        // Simulate the response for creating a new email
        json payload = check req.getJsonPayload();
        string emailName = check payload.'cloneName.ensureType();
        string emailId = check payload.id.ensureType();
        json response = {
            "id": emailId + "_clone",
            "name": emailName,
            "subject": "Cloned email from mock_service!",
            "feedbackSurveyId": "survey-id",
            "publishDate": "2023-01-01T10:00:00Z",
            "isTransactional": false,
            "language": "en-us",
            "type": "MARKETING_SINGLE_SEND_API",
            "content": {
                "html": "<html><body><h1>Test Email</h1></body></html>",
                "plainText": "Test Email"
            },
            "businessUnitId": "business-unit-id",
            "webversion": {
                "url": "https://example.com/webversion",
                "enabled": true
            },
            "workflowNames": ["workflow1", "workflow2"],
            "archived": false,
            "createdAt": "2023-09-01T10:00:00Z",
            "stats": {
                "counters": {
                    "sent": 1,
                    "open": 0,
                    "delivered": 0,
                    "bounce": 1,
                    "unsubscribed": 0,
                    "click": 0,
                    "reply": 0,
                    "dropped": 0,
                    "selected": 1,
                    "spamreport": 0,
                    "suppressed": 0,
                    "hardbounced": 0,
                    "softbounced": 1,
                    "pending": 0,
                    "contactslost": 0,
                    "notsent": 0
                },
                "deviceBreakdown": {
                    "open_device_type": {
                        "computer": 0,
                        "mobile": 0,
                        "unknown": 0
                    },
                    "click_device_type": {
                        "computer": 0,
                        "mobile": 0,
                        "unknown": 0
                    }
                },
                "qualifierStats": {},
                "ratios": {
                    "clickratio": 0,
                    "clickthroughratio": 0,
                    "deliveredratio": 0,
                    "openratio": 0,
                    "replyratio": 0,
                    "unsubscribedratio": 0,
                    "spamreportratio": 0,
                    "bounceratio": 100,
                    "hardbounceratio": 0,
                    "softbounceratio": 100,
                    "contactslostratio": 0,
                    "pendingratio": 0,
                    "notsentratio": 0
                }
            },
            "jitterSendTime": false,
            "from": {
                "email": "sender@example.com",
                "name": "Sender Name"
            },
            "state": "DRAFT",
            "createdById": "user-id",
            "updatedAt": "2025-01-01T10:00:00Z",
            "rssData": {
                "feedUrl": "https://example.com/rss",
                "feedTitle": "RSS Feed"
            },
            "publishedAt": "2023-10-01T10:00:00Z",
            "publishedById": "publisher-id",
            "isPublished": true,
            "testing": {
                "abTest": true,
                "testName": "A/B Test"
            },
            "updatedById": "updater-id",
            "folderId": 123,
            "subscriptionDetails": {
                "officeLocationId": "office-id",
                "preferencesGroupId": "preferences-group-id",
                "subscriptionId": "subscription-id"
            },
            "activeDomain": "example.com",
            "campaign": "campaign-id",
            "to": {
                "contactIds": {
                    "included": ["contact1", "contact2"],
                    "excluded": ["contact3"]
                },
                "contactLists": {
                    "included": ["list1", "list2"],
                    "excluded": ["list3"]
                },
                "limitSendFrequency": true,
                "suppressGraymail": false
            },
            "subcategory": "batch",
            "campaignName": "Campaign Name",
            "sendOnPublish": true
        };

        check caller->respond(response);
    }

    resource function get .(http:Caller caller, http:Request req) returns error? {
        // Simulate the response for listing all emails
        json response = {
            total: 2,
            results: [
                {
                    "id": "test-email-id",
                    "name": "emailName",
                    "subject": "subject",
                    "feedbackSurveyId": "survey-id",
                    "publishDate": "2023-01-01T10:00:00Z",
                    "isTransactional": false,
                    "language": "en-us",
                    "type": "MARKETING_SINGLE_SEND_API",
                    "content": {
                        "html": "<html><body><h1>Test Email</h1></body></html>",
                        "plainText": "Test Email"
                    },
                    "businessUnitId": "business-unit-id",
                    "webversion": {
                        "url": "https://example.com/webversion",
                        "enabled": true
                    },
                    "workflowNames": ["workflow1", "workflow2"],
                    "archived": false,
                    "createdAt": "2023-09-01T10:00:00Z",
                    "stats": {
                        "counters": {
                            "sent": 1,
                            "open": 0,
                            "delivered": 0,
                            "bounce": 1,
                            "unsubscribed": 0,
                            "click": 0,
                            "reply": 0,
                            "dropped": 0,
                            "selected": 1,
                            "spamreport": 0,
                            "suppressed": 0,
                            "hardbounced": 0,
                            "softbounced": 1,
                            "pending": 0,
                            "contactslost": 0,
                            "notsent": 0
                        },
                        "deviceBreakdown": {
                            "open_device_type": {
                                "computer": 0,
                                "mobile": 0,
                                "unknown": 0
                            },
                            "click_device_type": {
                                "computer": 0,
                                "mobile": 0,
                                "unknown": 0
                            }
                        },
                        "qualifierStats": {},
                        "ratios": {
                            "clickratio": 0,
                            "clickthroughratio": 0,
                            "deliveredratio": 0,
                            "openratio": 0,
                            "replyratio": 0,
                            "unsubscribedratio": 0,
                            "spamreportratio": 0,
                            "bounceratio": 100,
                            "hardbounceratio": 0,
                            "softbounceratio": 100,
                            "contactslostratio": 0,
                            "pendingratio": 0,
                            "notsentratio": 0
                        }
                    },
                    "jitterSendTime": false,
                    "from": {
                        "email": "sender@example.com",
                        "name": "Sender Name"
                    },
                    "state": "DRAFT",
                    "createdById": "user-id",
                    "updatedAt": "2025-01-01T10:00:00Z",
                    "rssData": {
                        "feedUrl": "https://example.com/rss",
                        "feedTitle": "RSS Feed"
                    },
                    "publishedAt": "2023-10-01T10:00:00Z",
                    "publishedById": "publisher-id",
                    "isPublished": true,
                    "testing": {
                        "abTest": true,
                        "testName": "A/B Test"
                    },
                    "updatedById": "updater-id",
                    "folderId": 123,
                    "subscriptionDetails": {
                        "officeLocationId": "office-id",
                        "preferencesGroupId": "preferences-group-id",
                        "subscriptionId": "subscription-id"
                    },
                    "activeDomain": "example.com",
                    "campaign": "campaign-id",
                    "to": {
                        "contactIds": {
                            "included": ["contact1", "contact2"],
                            "excluded": ["contact3"]
                        },
                        "contactLists": {
                            "included": ["list1", "list2"],
                            "excluded": ["list3"]
                        },
                        "limitSendFrequency": true,
                        "suppressGraymail": false
                    },
                    "subcategory": "batch",
                    "campaignName": "Campaign Name",
                    "sendOnPublish": true
                },
                {
                    "id": "test-email-id",
                    "name": "emailName",
                    "subject": "subject",
                    "feedbackSurveyId": "survey-id",
                    "publishDate": "2023-01-01T10:00:00Z",
                    "isTransactional": false,
                    "language": "en-us",
                    "type": "MARKETING_SINGLE_SEND_API",
                    "content": {
                        "html": "<html><body><h1>Test Email</h1></body></html>",
                        "plainText": "Test Email"
                    },
                    "businessUnitId": "business-unit-id",
                    "webversion": {
                        "url": "https://example.com/webversion",
                        "enabled": true
                    },
                    "workflowNames": ["workflow1", "workflow2"],
                    "archived": false,
                    "createdAt": "2023-09-01T10:00:00Z",
                    "stats": {
                        "counters": {
                            "sent": 1,
                            "open": 0,
                            "delivered": 0,
                            "bounce": 1,
                            "unsubscribed": 0,
                            "click": 0,
                            "reply": 0,
                            "dropped": 0,
                            "selected": 1,
                            "spamreport": 0,
                            "suppressed": 0,
                            "hardbounced": 0,
                            "softbounced": 1,
                            "pending": 0,
                            "contactslost": 0,
                            "notsent": 0
                        },
                        "deviceBreakdown": {
                            "open_device_type": {
                                "computer": 0,
                                "mobile": 0,
                                "unknown": 0
                            },
                            "click_device_type": {
                                "computer": 0,
                                "mobile": 0,
                                "unknown": 0
                            }
                        },
                        "qualifierStats": {},
                        "ratios": {
                            "clickratio": 0,
                            "clickthroughratio": 0,
                            "deliveredratio": 0,
                            "openratio": 0,
                            "replyratio": 0,
                            "unsubscribedratio": 0,
                            "spamreportratio": 0,
                            "bounceratio": 100,
                            "hardbounceratio": 0,
                            "softbounceratio": 100,
                            "contactslostratio": 0,
                            "pendingratio": 0,
                            "notsentratio": 0
                        }
                    },
                    "jitterSendTime": false,
                    "from": {
                        "email": "sender@example.com",
                        "name": "Sender Name"
                    },
                    "state": "DRAFT",
                    "createdById": "user-id",
                    "updatedAt": "2025-01-01T10:00:00Z",
                    "rssData": {
                        "feedUrl": "https://example.com/rss",
                        "feedTitle": "RSS Feed"
                    },
                    "publishedAt": "2023-10-01T10:00:00Z",
                    "publishedById": "publisher-id",
                    "isPublished": true,
                    "testing": {
                        "abTest": true,
                        "testName": "A/B Test"
                    },
                    "updatedById": "updater-id",
                    "folderId": 123,
                    "subscriptionDetails": {
                        "officeLocationId": "office-id",
                        "preferencesGroupId": "preferences-group-id",
                        "subscriptionId": "subscription-id"
                    },
                    "activeDomain": "example.com",
                    "campaign": "campaign-id",
                    "to": {
                        "contactIds": {
                            "included": ["contact1", "contact2"],
                            "excluded": ["contact3"]
                        },
                        "contactLists": {
                            "included": ["list1", "list2"],
                            "excluded": ["list3"]
                        },
                        "limitSendFrequency": true,
                        "suppressGraymail": false
                    },
                    "subcategory": "batch",
                    "campaignName": "Campaign Name",
                    "sendOnPublish": true
                }
            ]
        };
        check caller->respond(response);
    }
}
