_Author_:  Lakindu Kariyawasam \
_Created_: 18.12.2024 \
_Updated_:  \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from HubSpot Marketing Emails. 
The OpenAPI specification is obtained from [Hubspot Github Public API Spec Collection](https://github.com/HubSpot/HubSpot-public-api-spec-collection/blob/main/PublicApiSpecs/Marketing/Marketing%20Emails/Rollouts/145892/v3/marketingEmails.json). \
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

[//]: # (TODO: Add sanitation details)
1.Add `"format":"float"` to `components->statistics->EmailStatisticsData->properties->ratios->additionalProperties`
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

2. 
3. 

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.yaml --mode client -o ballerina
```
Note: The license year is hardcoded to 2024, change if necessary.
