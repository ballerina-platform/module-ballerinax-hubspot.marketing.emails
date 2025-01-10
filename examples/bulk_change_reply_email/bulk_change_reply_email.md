## Bulk Change ReplyTo and CustomReplyTo in Draft Emails

This use case shows how the Hubspot Marketing Emails API can be used to change the 'reply to' email address of all draft emails. This example leverages the endpoints of the Hubpsot Marketing Emails API to automate what would be a time consuming task if done manually.

## Prerequisites

### 1. Setup Hubspot developer account

Refer to the [Setup guide](../../ballerina/Package.md#setup-guide) to obtain necessary credentials (client Id, client secret, tokens).

### 2. Configuration

Create a `Config.toml` file in the example's root directory and, provide your Hubspot account related configurations as follows:

```toml
clientId = "<client-id>"
clientSecret = "<client-secret>"
refreshToken = "<refresh-token>"
```

## Run the example

Execute the following command to run the example:

```bash
bal run
```