---
title : "Event Notifications with Kinesis Data Firehose"
date : "`r Sys.Date()`"
weight : 4
chapter : false
pre : " <b> 4.4 </b> "
---


## Setting up Event Notifications with Kinesis Data Firehose

### Archive Email Events using Kinesis Data Firehose and Amazon S3
In this section, we will configure a Kinesis Data Firehose delivery stream to collect email events from Amazon SES and then archive the events in Amazon S3, and then provide instructions on how to retrieve the event data. This setup will enable AWSomeNewsletter to store and archive email campaign events for auditing and compliance purposes in a scalable and cost-effective manner.

#### Step 1: Create an Amazon S3 Bucket
Create an Amazon S3 bucket to store the archived email events. Replace `<custom-string>` with a unique **LOWERCASE** string of your choice to avoid naming conflicts:
```
aws s3api create-bucket --bucket awesome-newsletter-events-<custom-string> --region <your-region>
```
Replace `<your-region>` with the appropriate AWS region. This command creates a new S3 bucket named `awesome-newsletter-events-<custom-string>`.

#### Step 2: Create a Kinesis Data Firehose Delivery Stream
1. First, create an IAM role that grants Kinesis Data Firehose the necessary permissions to access the S3 bucket:
```
aws iam create-role --role-name FirehoseDeliveryRole --assume-role-policy-document '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}'

```
2. Attach the required policies to the IAM role, remember to change the bucket name with the custom string you specified previously:
```
aws iam put-role-policy --role-name FirehoseDeliveryRole --policy-name S3AccessPolicy --policy-document '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::awesome-newsletter-events-<custom-string>",
        "arn:aws:s3:::awesome-newsletter-events-<custom-string>/*"
      ]
    }
  ]
}'
```

3. Retrieve the ARN of the IAM role:
```
aws iam get-role --role-name FirehoseDeliveryRole --query 'Role.Arn'
```

4. Create a Kinesis Data Firehose delivery stream, replacing `<custom-string>` with your unique string, and `<FirehoseDeliveryRoleArn>` with the IAM role ARN obtained in the previous step:
```
aws firehose create-delivery-stream --delivery-stream-name AWSomeNewsletterEventsStream --delivery-stream-type DirectPut --s3-destination-configuration '{
  "RoleARN": "<FirehoseDeliveryRoleArn>",
  "BucketARN": "arn:aws:s3:::awesome-newsletter-events-<custom-string>",
  "BufferingHints": {
    "SizeInMBs": 5,
    "IntervalInSeconds": 60
  },
  "CompressionFormat": "UNCOMPRESSED",
  "Prefix": "events/",
  "ErrorOutputPrefix": "error/"
}'
```
This command creates a Kinesis Data Firehose delivery stream named `AWSomeNewsletterEventsStream` that will archive the email events to the specified S3 bucket. Note down the `DeliveryStreamARN` for use in Step 3.3.

#### Step 3: Create a New Role for Amazon SES

1. To allow Amazon SES to stream events to Kinesis Data Firehose, create a new IAM role called `SESFirehoseRole` that allows Amazon SES to assume the role:
```
aws iam create-role --role-name SESFirehoseRole --assume-role-policy-document '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ses.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}'
```

2. Create a custom policy for the SESFirehoseRole with the necessary permissions:
```
aws iam create-policy --policy-name SESFirehosePolicy --policy-document '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "firehose:PutRecord",
        "firehose:PutRecordBatch"
      ],
      "Resource": "<DeliveryStreamArn>"
    }
  ]
}'
```
Replace `<DeliveryStreamArn>` with the ARN of the Kinesis Data Firehose delivery stream you created in step 2.4.

3. Attach the custom policy to the `SESFirehoseRole`:
```
aws iam attach-role-policy --role-name SESFirehoseRole --policy-arn <SESFirehosePolicyArn>
```
Replace `<SESFirehosePolicyArn>` with the ARN of the custom policy you created in step 3.2.

4. Retrieve the ARN of the newly created `SESFirehoseRole`:
```
aws iam get-role --role-name SESFirehoseRole --query 'Role.Arn'
```
Note down the ARN as you will need it in the next step.

#### Step 4: Update the Configuration Set to Stream Events to Kinesis Data Firehose
1. Update the `AWSomeNewsletterTracking` configuration set to stream email events to the Kinesis Data Firehose delivery stream.
```
aws sesv2 create-configuration-set-event-destination \
--configuration-set-name TechNewsConfigSet \
--event-destination-name KinesisFirehoseEventDestination \
--event-destination '{
    "Enabled": true,
    "MatchingEventTypes": ["SEND", "DELIVERY", "BOUNCE", "COMPLAINT"],
    "KinesisFirehoseDestination": {
        "IamRoleArn": "<SESFirehoseRoleArn>",
        "DeliveryStreamArn": "<DeliveryStreamArn>"
    }
}'
```
Replace `<SESFirehoseRoleArn>` with the IAM role ARN obtained in Step 1.4, and `<DeliveryStreamArn>` with the ARN of the Kinesis Data Firehose delivery stream you created earlier.

By following these steps, you have successfully set up a Kinesis Data Firehose delivery stream to collect and archive email events from Amazon SES to Amazon S3. This scalable and cost-effective solution allows AWSomeNewsletter to store and analyze their email campaign events, enabling them to optimize their newsletter delivery and subscriber engagement.