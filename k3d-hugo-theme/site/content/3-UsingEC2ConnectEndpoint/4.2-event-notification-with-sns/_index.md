---
title : "Event Notifications with SNS"
date : "`r Sys.Date()`"
weight : 2
chapter : false
pre : " <b> 4.2 </b> "
---

## Setting up Event Notifications with SNS
### Track Emails Sent Using an SNS Topic
In this section, we will set up email sending event tracking using Amazon SES event publishing and an Amazon SNS topic. This will help AWSomeNewsletter gain valuable insights into their newsletter delivery and improve their email campaign's performance. Tracking email events using SNS topics allows you to receive notifications for various email events such as "send", "delivery", "bounce", and "complaint". This real-time monitoring enables you to quickly respond to issues, optimize your campaigns, and maintain a good sending reputation.

#### Step 1: Create an SNS Topic and Set Up Email Subscriptions
1. Run the following command to create an SNS topic named EmailEvents:
```
aws sns create-topic --name EmailEvents
```
Note the `TopicArn` value in the response.

2. Create an email subscription for the Amazon SNS topic. Replace <TopicArn> with the Amazon SNS topic ARN you just created and `<YourEmailAddress>` with the email address where you want to receive the notifications:
```
aws sns subscribe --topic-arn <TopicArn> --protocol email --notification-endpoint <YourEmailAddress>
```
3. Confirm the subscription by clicking the confirmation link sent to the specified email address.

#### Step 2: Enable Event Types to send to SNS
1. Enable the event types you want to track for the configuration set. In this example, we would like to track "send", "delivery", "bounce", and "complaint" events.
```
aws sesv2 create-configuration-set-event-destination \
--configuration-set-name TechNewsConfigSet \
--event-destination-name SNSEmailEventDestination \
--event-destination '{
  "Enabled": true,
  "MatchingEventTypes": ["SEND", "DELIVERY", "BOUNCE", "COMPLAINT"],
  "SnsDestination": {
    "TopicArn": "<sns-topic-arn>"
  }
}'
```
Replace `<SNS-Topic-ARN>` with the Topic ARN you created in Step 1.
{{% notice note %}}
Remember to include double quotes around the SNS topic ARN.
{{% /notice %}}

That's it! The configuration set `TechNewsConfigSet` is now set up to send `["send", "delivery", "bounce", "complaint"]` events to the specified SNS topic. When sending emails using this configuration set, the specified events will trigger notifications to the SNS topic. For a complete list of event types you can track using configuration sets, refer to the [docs](https://docs.aws.amazon.com/ses/latest/dg/monitor-using-event-publishing.html#event-publishing-how-works).