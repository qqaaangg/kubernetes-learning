---
title : "Using the Account-Level Suppression List"
date : "`r Sys.Date()`"
weight : 1
chapter : false
pre : " <b> 5.1 </b> "
---

The account-level suppression list allows you to manage email sending at the account level. By adding email addresses to this list, you can prevent sending emails to specific recipients. You can use the Amazon SES console or the Amazon SES API to manage the account-level suppression list.

Before we dive into the hands-on part of this lab, let's discuss the differences between account-level and configuration set-level suppression lists in Amazon SES, and how they can be applied to AWSomeNewsletter's use case.

### Account-Level vs Configuration Set-Level Suppression Lists
In Amazon SES, you can manage suppression lists at two levels: account-level and configuration set-level.

**Account-Level Suppression List**: This type of suppression list applies to your entire AWS account. When an email address is added to the account-level suppression list, Amazon SES will not send emails to that address, regardless of the configuration set used. This can be helpful in maintaining a healthy sending environment by preventing emails from being sent to recipients who have previously bounced or complained. Learn more about account-level suppression lists in the [Amazon SES documentation](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/sending-email-suppression-list.html).

**Configuration Set-Level Suppression List**: This type of suppression list is specific to a particular configuration set. You can create multiple configuration sets with different suppression lists to manage email sending based on specific conditions or requirements. This allows for more granular control over your email sending, enabling you to target specific segments of your audience while respecting their preferences and minimizing the risk of complaints or bounces. Learn more about configuration set-level suppression lists in the [Amazon SES documentation](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/sending-email-suppression-list-config.html).

### Applying Suppression Lists to AWSomeNewsletter's Use Case
For AWSomeNewsletter, using a combination of account-level and configuration set-level suppression lists would be ideal. The account-level suppression list can be used to ensure that no emails are sent to recipients who have previously bounced or complained, maintaining a healthy sending environment and improving the company's sender reputation.

On the other hand, configuration set-level suppression lists can be employed for targeted marketing campaigns or newsletters to specific segments of their audience. This will help AWSomeNewsletter to fine-tune their email sending activities and provide more relevant content to their subscribers.

In this lab, we will focus on setting up and managing the account-level suppression list in Amazon SES. For best practices on using suppression lists and maintaining a good sender reputation, refer to the [Amazon SES Email Best Practices guide](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/best-practices.html).

### Processing accounts on the suppression list

{{< tabs groupId="suppression-list" >}}
{{% tab name="Single Email Operation" %}}
#### Add an email address to the suppression list
Add an email address to the account-level suppression list:
```
aws sesv2 put-suppressed-destination --email-address "recipient@example.com" --reason "BOUNCE"
```
This command adds `recipient@example.com` to the suppression list with a specified reason for suppression, in this case, "BOUNCE".

#### Check if an email address is in the suppression list
Check if a specific email address is in the account-level suppression list:
```
aws sesv2 get-suppressed-destination --email-address "recipient@example.com"
```
This command checks if `recipient@example.com` is in the suppression list and returns the suppression record if it exists.

If successful, you should receive a JSON file outlining the Suppressed Destination's `EmailAddress` and `Reason`.

#### Remove an email address from the suppression list
Remove an email address from the account-level suppression list:
```
aws sesv2 delete-suppressed-destination --email-address "recipient@example.com"
```
This command removes `recipient@example.com` from the suppression list. You can run `get-suppressed-destination` again to make sure the email address has been removed from the suppression list. You should receive a `NotFoundException` if the delete operation was successful.
{{% /tab %}}
{{% tab name="Bulk Email Operation" %}}
>Please note that there is a limitation when using Amazon SES sandbox: For account-level suppression, bulk actions and SES API calls related to suppression list management are disabled. As a result, the steps outlined in this lab may not work if your account is still operating within the Amazon SES sandbox. Please ensure your account is out of the sandbox before proceeding.

#### Create an S3 bucket (if needed)
If you don't have an S3 bucket already set up, you can use the following AWS CLI command to create a new S3 bucket:
```
aws s3api create-bucket --bucket BUCKET-NAME --region REGION
```
Replace `BUCKET-NAME` with the name you want to give to your S3 bucket and `REGION` with the AWS region where you want to create the bucket.
>Note that S3 bucket names must be globally unique across all AWS accounts, so you may need to choose a different name if your desired name is already taken.

#### Upload your address list into an Amazon S3 object
Upload your address list into an Amazon S3 object in either CSV or JSON format.

- CSV format example for adding addresses:
```
recipient1@example.com,BOUNCE
recipient2@example.com,COMPLAINT
```

- JSON format example for adding addresses:
```
{"emailAddress":"recipient1@example.com","reason":"BOUNCE"}
{"emailAddress":"recipient2@example.com","reason":"COMPLAINT"}
```
You can use the following AWS CLI command to upload a file to S3:
```
aws s3api cp FILEPATH s3://BUCKET-NAME/OBJECT-NAME
```

Replace `FILEPATH` with the path to your file on your local machine, `BUCKET-NAME` with the name of your S3 bucket, and `OBJECT-NAME` with the name you want to give to the object in S3.

#### Give Amazon SES permission to read the Amazon S3 object
Give Amazon SES permission to read the Amazon S3 object containing your suppressed email addresses by attaching a policy to the S3 bucket.

You can use the following AWS CLI command to add the policy to your S3 bucket:
```
aws s3api put-bucket-policy --bucket BUCKET-NAME --policy '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowSESGet",
            "Effect": "Allow",
            "Principal": {
                "Service": "ses.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::BUCKET-NAME/*",
            "Condition": {
                "StringEquals": {
                    "aws:Referer": "AWSACCOUNTID"
                }
            }
        }
    ]
}'

```
Replace `BUCKET-NAME` with the name of your S3 bucket and `AWSACCOUNTID` with your AWS account ID.

#### Use the AWS CLI to create an import job
Use the AWS CLI to create an import job and add email addresses to the suppression list:
```
aws sesv2 create-import-job --import-destination SuppressionListDestination={SuppressionListImportAction=PUT} --import-data-source S3Url=s3://BUCKET-NAME/OBJECT-NAME,DataFormat=CSV
```
Replace `BUCKET-NAME` with the name of your S3 bucket and `OBJECT-NAME` with the name of your S3 object that contains the email addresses.

This command will return a JobID, take note of this value so you can query the status of the import job in the next step.

#### Check the status of the import job
Check the status of the import job using the following AWS CLI command:
```
aws sesv2 get-import-job --job-id JOB-ID
```
Replace `JOB-ID` with the ID of the import job that you just created. You should get a JSON object similar to below:
```
{
  "JobId": "0a16a755-5069-493c-ba02-f50280ce4b7d",
  "ImportDestination": {
    "SuppressionListDestination": {
      "SuppressionListImportAction": "PUT"
    }
  },
  "ImportDataSource": {
    "S3Url": "s3://mysuppressionlisttestbucket/suppressionlist.csv",
    "DataFormat": "CSV"
  },
  "JobStatus": "COMPLETED",
  "CreatedTimestamp": "2023-04-02T20:21:14.685000+08:00",
  "CompletedTimestamp": "2023-04-02T20:21:27.800000+08:00",
  "ProcessedRecordsCount": 2,
  "FailedRecordsCount": 0
}
```
View imported email addresses
Once the import job is complete (as reflected in the value of the `JobStatus` JSON object in the previous step), you can view the imported email addresses in the [Amazon SES console](https://console.aws.amazon.com/ses/) under "Suppression Lists".

Alternatively, you can utilize the following command:
```
aws sesv2 list-suppressed-destinations
```
Which returns all of the email addresses that are in your account-level suppression list for your account. To filter and perform additional pagination options, refer to the [documentation](https://docs.aws.amazon.com/ses/latest/APIReference-V2/API_ListSuppressedDestinations.html).
{{% /tab %}}
{{< /tabs >}}

### Send a test email to a suppressed email address
Now, to see the account suppression list in action. Try to send an email to the email address you've just suppressed in the previous step. Use the instruction in Lab [3.4 Sending Test Email using the AWS CLI](../../3-SendEmail/3.4-testmail-aws-cli). If you'd like to see the email event response from sending an email to a suppressed destination, you should use event notifications we've set up in [3. Sending Emails Using Amazon SES](../../3-SendEmail/)
{{% notice tip %}}
To send an email using a specific configuration set, check out `--configuration-set` attribute of the send-email call of SESv2.
{{% /notice %}}
If you've configured your event notifications and account suppression correctly, you should receive a "Bounce" event with contents similar to the following:
```
{
 "eventType": "Bounce",
 "bounce": {
  "feedbackId": "010001873fdfac35-112345bd-5ce6-4174-b615-730287c292dc-000000",
  "bounceType": "Permanent",
  "bounceSubType": "OnAccountSuppressionList",
  "bouncedRecipients": [{
   "emailAddress": "recipient@example.com",
   "action": "failed",
   "status": "5.1.1",
   "diagnosticCode": "Amazon SES did not send the message to this address because it is on the suppression list for your account. For more information about removing addresses from the suppression list, see the Amazon SES Developer Guide at https://docs.aws.amazon.com/ses/latest/DeveloperGuide/sending-email-suppression-list.html"
  }],
  "timestamp": "2023-04-02T02:50:36.052Z",
  "reportingMTA": "dns; amazonses.com"
...
```
{{% notice warning %}}
Note that even though we used a configuration set to send out the email to take advantage of event tracking, Account Suppression List **SUPERSEDES** configuration-set level suppression lists by default. Unless explitcitly specified which we will learn how to manage in [Using Configuration Set-Level Suppression](../5.2-configuration-set-level-suppression), if an email address is suppressed at the account-level and not the configuration-set level, account-level suppression takes precedent and the email will be blocked.
{{% /notice %}}
