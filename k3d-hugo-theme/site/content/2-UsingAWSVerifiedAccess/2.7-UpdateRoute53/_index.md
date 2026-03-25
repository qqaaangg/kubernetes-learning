---
title : "Domain Identities"
date :  "`r Sys.Date()`" 
weight : 7
chapter : false
pre : " <b> 2.2 </b> "
---

{{% notice note %}}
To ensure the comprehensiveness of this workshop, we are providing instructions on how to verify a domain in AWS SES using AWS CLI. Please note that this step is optional and not a part of the workshop because not all workshop audience will have access to edit their company's DNS records and wait up to 72 hours for the records to propagate. It is included to give the audience a complete understanding of the SES setup process.
{{% /notice %}}

### Generate DKIM Tokens

1. First, generate DKIM tokens for the domain verification:
```
aws ses verify-domain-dkim --domain example.com
```
Replace `example.com` with your domain name.

This command will return a response containing three DKIM tokens. Save the output for later use.

DKIM is an email authentication technique that allows the receiver to check that an email was sent and authorized by the owner of the sending domain. It achieves this by associating a domain name with each outgoing email, which can be cryptographically verified. This helps prevent email spoofing and ensures the integrity of the email content.

To learn more about DKIM and its importance, refer to the [AWS documentation on DKIM in Amazon SES](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/send-email-authentication-dkim.html).

### Configure DNS Records
To verify your domain, you need to add the DomainKeys Identified Mail (DKIM) tokens to your domain's DNS settings. Use the following format for these records:

- DKIM records:
    - Name: `<dkim-token-1>._domainkey.example.com`
    - Value: `<dkim-token-1>.dkim.amazonses.com`
    - Name: `<dkim-token-2>._domainkey.example.com`
    - Value: `<dkim-token-2>.dkim.amazonses.com`
    - Name: `<dkim-token-3>._domainkey.example.com`
    - Value: `<dkim-token-3>.dkim.amazonses.com`
    - Replace `<dkim-token-x>` with the values you received in the output from Steps 1 and 2.

If you are using [Amazon Route 53](https://aws.amazon.com/route53/) as your DNS provider and have access to manage the domain's records, you can create these records using the AWS CLI or [AWS Route 53 console](https://console.aws.amazon.com/route53/).

1. Find the hosted zone ID for your domain in Route 53
```
aws route53 list-hosted-zones-by-name
```

This command will generate the following output:
```
"HostedZones": [
        {
            "Id": "/hostedzone/Z123456789123456789A",
            "Name": "example.com",
            "CallerReference": "a12345-1234-1234-1234-12345123456",
            "Config": {
                "Comment": "",
                "PrivateZone": false
            },
            "ResourceRecordSetCount": 2
        },
        {
            "Id": "/hostedzone/Z123456789123456789B",
            "Name": "sesworkshop.example.com",
            "CallerReference": "a12345-1234-1234-1234-12345123456",
            "Config": {
                "Comment": "",
                "PrivateZone": false
            },
            "ResourceRecordSetCount": 2
        }
    ]
```

If your environment has multiple HostedZones, find the zone with the domain/subdomain name you want to verify. Afterwards, take note of the "Id"and the "Name"values in the "HostedZones" array in the response. The "Id" value will be used in step 4 while "Name" will be appended to the DNS record names as <domain_name>.

2. Create a JSON file named dns-records.json with the following content:
```
{
  "Comment": "Add SES domain verification and DKIM records",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "<dkim-token-1>._domainkey.example.com.<domain_name>",
        "Type": "CNAME",
        "TTL": 1800,
        "ResourceRecords": [
          {
            "Value": "<dkim-token-1>.dkim.amazonses.com"
          }
        ]
      }
    },
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "<dkim-token-2>._domainkey.example.com.<domain_name>",
        "Type": "CNAME",
        "TTL": 1800,
        "ResourceRecords": [
          {
            "Value": "<dkim-token-2>.dkim.amazonses.com"
          }
        ]
      }
    },
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "<dkim-token-3>._domainkey.example.com.<domain_name>",
        "Type": "CNAME",
        "TTL": 1800,
        "ResourceRecords": [
          {
            "Value": "<dkim-token-3>.dkim.amazonses.com"
          }
        ]
      }
    }
  ]
}
```

Replace `<domain-name>`,`<domain-verification-token>` and `<dkim-token-x>` with the values you received in the output from Steps 1 and 2. For example, my TXT record would have the name value of `_amazonses.example.com.sesworkshop.example.com`.

3. Execute the following command to create the DNS records in your Route 53 hosted zone, replacing `<hosted-zone-id>` with the value you found in `Id` in Step 1.
```
aws route53 change-resource-record-sets --hosted-zone-id <hosted-zone-id> --change-batch file://dns-records.json
```
The expected output of this command will be a response containing the "ChangeInfo" object, which includes details about the submitted changes, such as the change request ID, status, and submission date. Check for the "Status" field in the response to ensure the changes are marked as "PENDING":
```
{
  "ChangeInfo": {
    "Id": "string",
    "Status": "PENDING",
    "SubmittedAt": "timestamp",
    "Comment": "string"
  }
}
```
You can also access the [Amazon Route53 console](https://console.aws.amazon.com/route53) to confirm the DNS records have been created successfully.
{{% notice tip %}}
DNS record updates may take some time to propagate. It can take anywhere from a few minutes to 72 hours, depending on your DNS provider.
{{% /notice %}}

### Verify Domain Identity
Once the DNS records have propagated, you can check the domain identity verification status using the AWS CLI:
```
aws ses get-identity-verification-attributes --identities example.com
```
Replace `example.com` with your domain name.

If the domain verification is successful, you'll see a response like this:
```
{
  "VerificationAttributes": {
    "example.com": {
      "VerificationStatus": "Success",
      "VerificationToken": "<domain-verification-token>"
    }
  }
}
```

That's it! Your domain is now verified and DKIM signing is enabled in Amazon SES. You can now start sending the newsletter from your domain using Amazon SES, ensuring your recipients are more likely to open your email from a trusted source.