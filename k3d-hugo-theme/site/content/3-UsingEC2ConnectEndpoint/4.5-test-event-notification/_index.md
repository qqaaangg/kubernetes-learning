---
title : "Testing Event Notifications"
date : "`r Sys.Date()`"
weight : 5
chapter : false
pre : " <b> 4.5 </b> "
---

## Testing Event Notifications for your Configuration Sets

In the previous labs, you learned how to set up event notifications using SNS, CloudWatch, and Kinesis Data Firehose. In this lab, you will learn how to test these configurations and see the results.

### Prerequisites
Before you begin this lab, you should have completed the following:
1. [Setting up Event Notifications with SNS](../4.2-event-notification-with-sns/)
2. [Setting up Event Notifications with Cloudwatch](../4.3-event-notification-with-cloudwatch/)
3. [Setting up Event Notifications with Kinesis Data Firehose](../4.4.-event-notification-with-kinesis/)

### Scenario
You have successfully set up event notifications for your Amazon SES configuration set using SNS, CloudWatch, and Kinesis Data Firehose. Now, you want to test the configurations and make sure that you receive the expected notifications when certain events occur.

### Testing your SNS Notification Topics
1. Referring to [3.4: Sending Test Email using the AWS CLI](3-sendemail/3.4-testmail-aws-cli/), you should choose the correct Mailbox Simulator to test for the corresponding email events that you'd like to show up on your SNS Topics.
2. However, the provided command will not be enough to generate the email event notification. Remember, you are trying to track email notification events for a specific **Configuration Set**. How can you modify the command provided in Lab 3.4: Sending Test Email using the AWS CLI to send the email using the configuration set that you specified for SNS event notification in Lab 4.2: Setting up Event Notifications with SNS?

{{% notice tip %}}
Refer to the [send-email](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sesv2/send-email.html) CLI documentation for the attribute that you'd need to specify.
{{% /notice %}}

3. Verify that you have received an event notification from SES by checking the subscribed email address or the SNS topic subscription. You should receive a JSON object containing details of the event. For example, the following json event is received in the subscribed mailbox after sending a test email to the successful mailbox simulator.
```
{
  "eventType": "Delivery",
  "mail": {
    "timestamp": "2023-03-29T03:11:11.997Z",
    "source": "sender@example.com",
    "sourceArn": "arn:aws:ses:us-east-1:<aws-account-id>:identity/sender@example.com",
    "sendingAccountId": "<aws-account-id>",
    "messageId": "010001872b59187d-9a1c4193-4297-4f06-85af-099739a3de64-000000",
    "destination": ["success@simulator.amazonses.com"],
    "headersTruncated": false,
    "headers": [
      {
        "name": "From",
        "value": "sender@example.com"
      }
    ],
    "commonHeaders": {
      "from": ["sender@example.com"],
      "messageId": "010001872b59187d-9a1c4193-4297-4f06-85af-099739a3de64-000000"
    },
    "tags": {
      "ses:operation": ["SendRawEmail"],
      "ses:configuration-set": ["TechNewsConfigSet"],
      "ses:source-ip": ["220.255.166.11"],
      "ses:from-domain": ["amazon.com"],
      "ses:caller-identity": ["admin"],
      "ses:outgoing-ip": ["54.240.8.53"]
    }
  },
  "delivery": {
    "timestamp": "2023-03-29T03:11:12.606Z",
    "processingTimeMillis": 609,
    "recipients": ["success@simulator.amazonses.com"],
    "smtpResponse": "250 2.0.0 OK DMARC:Quarantine 1680059472 l4-20020ad44084000000b00570b7ce3d78si21013747qvp.465 - gsmtp",
    "reportingMTA ": "a8 - 53. smtp - out.amazonses.com "
  }
}
```

### Testing Cloudwatch Dashboard and Alarm
First, send some test emails to the corresponding Mailbox simulators as detailed in [3.4: Sending Test Email using the AWS CLI](3-sendemail/3.4-testmail-aws-cli/).

Go to the [Amazon CloudWatch console](https://console.aws.amazon.com/cloudwatch/) and select "Dashboards" from the left-side menu.

Click on "AWSomeNewsletterSESDashboard" to view the dashboard you created.
<!-- image -->
You will see a widget displaying the number of "send", "delivery", "bounce", and "complaint" events for your AWSomeNewsletterTracking configuration set similar to the image below. You can adjust the time range to view the metrics for a specific time period by using the time range selector at the top right corner of the dashboard.

Likewise, you can click on "All alarms" from the left-side menu to view the Alarm that you've created earlier. Send a few complaint emails the corresponding Mailbox simulator. If you've configured the **AWSomeNewsletterComplainAlarm** correctly, the alarm should change into an Alarm state and you will receive a notification in your SNS topic.

### Viewing Archived Email Events in S3
1. Log in to the [S3 Console](https://console.aws.amazon.com/s3/)
2. In the S3 console, find the S3 bucket where your email events are being stored. This is the same S3 bucket that you configured as the destination for your Amazon SES event publishing in [Setting up Event Notifications with Kinesis Data Firehose](../4.4.-event-notification-with-kinesis/).
3. Click on the name of the bucket to open it.
4. Inside the bucket, you should see folders for each day that email events were recorded. Click on the folder that corresponds to the day you want to view.
5. Inside the folder, you should see one or more files containing email events. These files are named with a combination of the date, time, and a random string. The files are in JSON format.
6. Click on a file to open it and view the email events it contains.
7. The email events include information about the email sent, such as the message ID, the sender, the recipient, the subject, and the timestamp.
8. You can use this information to analyze the performance of your email campaigns and troubleshoot any issues that may arise.

{{% notice note %}}
While we're demonstrating the ability to stream email events data for archiving in S3, you can choose to stream your email events data to [Redshift](https://docs.aws.amazon.com/firehose/latest/dev/create-destination.html#create-destination-redshift) to analyze and many other [destinations](https://docs.aws.amazon.com/firehose/latest/dev/create-destination.html).
{{% /notice %}}

In this workshop, we have explored three different ways to collect and process Amazon Simple Email Service (SES) events in AWS, which can help you gain valuable insights into your email campaigns, improve deliverability, and optimize engagement. Each method has its unique benefits and use cases, as summarized below:

1. **Using Amazon Simple Notification Service (SNS)**: By creating an SNS topic and setting up event destinations, you can receive notifications for specific SES events such as sends, deliveries, bounces, and complaints. SNS enables you to easily build event-driven applications by delivering messages to subscribers such as Lambda functions, SQS queues, or email addresses. This method is suitable for use cases that require real-time processing of email events or triggering specific actions based on events. Learn more about [Amazon SNS](https://aws.amazon.com/sns/).
2. **Using Amazon CloudWatch**: By logging SES metrics to CloudWatch, you can create custom dashboards, set up alarms, or trigger actions based on specific email events. CloudWatch enables you to monitor and analyze the performance of your email campaigns and provides tools for diagnosing and responding to issues. This method is ideal for use cases that require monitoring and analyzing email metrics to optimize email engagement and deliverability. Learn more about [Amazon CloudWatch](https://aws.amazon.com/cloudwatch/).
3. **Using Amazon Kinesis Data Firehose**: By streaming SES events to a Kinesis Data Firehose delivery stream and archiving them in Amazon S3, you can easily store and analyze large volumes of email event data. Kinesis Data Firehose is designed for real-time processing and can be integrated with various analytics services such as Amazon Redshift or Elasticsearch for deeper insights. This method is suitable for use cases that involve large-scale data processing, analytics, and archiving. Learn more about [Amazon Kinesis Data Firehose](https://aws.amazon.com/kinesis/data-firehose/).
By understanding and utilizing these different methods, you can effectively monitor and manage your Amazon SES email campaigns, ensuring improved deliverability and engagement for your subscribers.