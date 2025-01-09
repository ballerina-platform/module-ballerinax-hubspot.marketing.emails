_Author_:  Lakindu Kariyawasam \
_Created_: 2024/12/18 \
_Updated_: 2025/01/08 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from HubSpot Marketing Emails. 
The OpenAPI specification is obtained from [Hubspot Github Public API Spec Collection](https://github.com/HubSpot/HubSpot-public-api-spec-collection/blob/main/PublicApiSpecs/Marketing/Marketing%20Emails/Rollouts/145892/v3/marketingEmails.json). \
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Change the `url` property of the servers object
- **Original**: 
```https://api.hubspot.com```

- **Updated**: 
```https://api.hubapi.com/marketing/v3/emails```

- **Reason**:  This change of adding the common prefix `marketing/v3/emails` to the base url makes it easier to access endpoints using the client.

2. Update the API Paths
- **Original**: Paths included common prefix above in each endpoint. (eg: ```/marketing/v3/emails/clone```)

- **Updated**: Common prefix is now removed from the endpoints as it is included in the base URL.
  - **Original**: ```/marketing/v3/emails/clone```
  - **Updated**: ```/clone```

- **Reason**:  This change simplifies the API p aths, making them shorter and more readable.

3. Add `"format":"float"` to `components->statistics->EmailStatisticsData->properties->ratios->additionalProperties`
- **Original**: 
```json
"ratios" : {
            "type" : "object",
            "additionalProperties" : {
              "type" : "number"
            },
            "description" : "Ratios like `openratio` or `clickratio`"
          }
```

- **Updated**: 
```json
"ratios" : {
            "type" : "object",
            "additionalProperties" : {
              "type" : "number",
              "format": "float"
            },
            "description" : "Ratios like `openratio` or `clickratio`"
          }
```

- **Reason**:  This change ensures that the type is generated correctly to handle the payload from the response.

4. Change `"type":"object"` to `"type":"string"` in `components->schemas->PublicButtonStyleSettings->properties->backgroundColor`
- **Original**: 
```json
"backgroundColor" : {
            "type" : "object",
            "properties" : { }
          }
```

- **Updated**: 
```json
"backgroundColor" : {
            "type" : "string"
          },
```

- **Reason**:  The API returns backgroundColor as a string (eg: "#FF234A"). This change ensures that the type is generated correctly to handle the payload from the response.

5. Remove `sendOnPublish` from the required list in `components->schemas->PublicEmail`
- **Original**: 
```json
      "PublicEmail" : {
        "required" : [ "content", "from", "id", "name", "sendOnPublish",  "state", "subcategory", "subject", "to" ],
        ...
      }

```

- **Updated**: 
```json
      "PublicEmail" : {
        "required" : [ "content", "from", "id", "name",  "state", "subcategory", "subject", "to" ],
        ...
      }
```

- **Reason**:  The API does not return on the sendOnPublish field for some emails. This leads to a payload binding error as it is marked as required in the API specification. Removing it from the required list ensures that the types are generated correctly to handle the payload from the response.

6. Change `updatedAt` to `updated` in `components->schemas->VersionPublicEmail->properties`
- **Original**: 
```json 
"VersionPublicEmail" : {
        "required" : [ "id", "object", "updatedAt", "user" ],
          "updatedAt" : {
            "type" : "string",
            "format" : "date-time"
          },
          ...
        },
```
- **Updated**: 
```json 
"VersionPublicEmail" : {
        "required" : [ "id", "object", "updated", "user" ],
          "updated" : {
            "type" : "string",
            "format" : "date-time"
          },
          ...
        },
```

- **Reason**:  The API does not return a `updatedAt` field but rather a `updated` field for each result of the results array in the response of the /[emailId]/revisions endpoint. This change ensures that the type is generated correctly to handle the payload from the response.

7. Change `"date-time"` to `"datetime"` throughout the specification
- **Original**: 
```json 
    "format": "date-time"
```
- **Updated**: 
```json 
    "format": "datetime"
```

- **Reason**:  The specification originally uses `"date-time"` which is unsupported by the openapi generator tool. This change to `"datetime"` ensures it is handled correctly.


## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.yaml --mode client -o ballerina
```
Note: The license year is hardcoded to 2024, change if necessary.
