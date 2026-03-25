---
title : "Event Notifications with Cloudwatch"
date : "`r Sys.Date()`"
weight : 3
chapter : false
pre : " <b> 4.3 </b> "
---

## Setting up Event Notifications with Cloudwatch

In this section, we will set up Amazon SES event publishing to track email sending events and log them to Amazon CloudWatch. Using Cloudwatch native dashboards for analytics will help AWSomeNewsletter gain valuable insights into their newsletter delivery and improve their email campaign's performance. By logging email events to CloudWatch, you can create custom dashboards, set up alarms, or trigger actions based on specific email events.

#### Step 1: Enable CloudWatch Metrics in the Configuration Set
1. Enable the event types you want to track for the configuration set. In this example, we will track "send", "delivery", "bounce", and "complaint" events. You can specify a custom dimension value in `DimensionName`, in this case we are grouping based on the configuration set which the email is sent out from:
```
aws sesv2 create-configuration-set-event-destination \
--configuration-set-name TechNewsConfigSet \
--event-destination-name CloudWatchEmailEventDestination \
--event-destination '{
    "Enabled": true,
    "MatchingEventTypes": ["SEND", "DELIVERY", "BOUNCE", "COMPLAINT"],
    "CloudWatchDestination": {
        "DimensionConfigurations": [
            {
                "DimensionName": "ses:configuration-set",
                "DimensionValueSource": "MESSAGE_TAG",
                "DefaultDimensionValue": "TechNewsConfigSet"
            }
        ]
    }
}'
```
{{% notice note %}}
Setting dimension configuration allows you to further slice-and-dice your Cloudwatch metrics to fit your reporting needs based on the message Tag information. For example, you can choose to create a Cloudwatch dashboard to showcase email metrics for a particular department, or have a Cloudwatch Alarm that triggers everytime the number of bounce emails reaches a specific percentage in a specific business unit to maintain compliance.
{{% /notice %}}

This command creates an event destination called `"CloudWatchMetrics"` and enables the specified event types for the `"TechNewsConfigSet"` configuration set.

Now that you've successfully set up SES to stream email events to Cloudwatch metrics. We can cover 2 use cases discussed above: creating a dashboard to monitor email performance, and raising an alarm to your email administrator.

#### Step 3: Create a CloudWatch Dashboard
1. Create a CloudWatch dashboard:
```
aws cloudwatch put-dashboard --dashboard-name AWSomeNewsletterSESDashboard --dashboard-body '{     "widgets": [] }'
```
2. Add widgets to display the number of ["send", "delivery", "bounce", "complaint"] events. Replace <your-region> with your AWS region:
```
aws cloudwatch put-dashboard --dashboard-name AWSomeNewsletterSESDashboard --dashboard-body '{
    "widgets": [
        {
            "type": "metric",
            "x": 0,
            "y": 0,
            "width": 24,
            "height": 6,
            "properties": {
                "metrics": [
                    ["AWS/SES", "Send", "ses:configuration-set", "TechNewsConfigSet", {"label": "Sent", "stat": "Sum"}],
                    ["AWS/SES", "Delivery", "ses:configuration-set", "TechNewsConfigSet", {"label": "Delivered", "stat": "Sum"}],
                    ["AWS/SES", "Bounce", "ses:configuration-set", "TechNewsConfigSet", {"label": "Bounced", "stat": "Sum"}],
                    ["AWS/SES", "Complaint", "ses:configuration-set", "TechNewsConfigSet", {"label": "Complaints", "stat": "Sum"}]
                ],
                "view": "singleValue",
                "region": "<your-region>",
                "title": "SES Metrics",
                "period": 86400
            }
        }
    ]
}'
```
If you're successful, you would receive a `"DashboardValidationMessages"` json object.
{{% notice note %}}
This command should display the total number emails events for the past 24 hours (86400 seconds) in the CloudWatch dashboard widget. You can adjust the period value according to your specific requirements.
{{% /notice %}}
By following these steps, you have successfully logged Amazon SES metrics to CloudWatch and created a dashboard to visualize the metrics related to sending, delivery, bounces, and complaints for your TechNewsConfigSet configuration set. This will help you monitor and analyze the performance of your email campaigns, enabling you to optimize your email strategies for better engagement.

#### Step 4: Create a CloudWatch Alarm
AWS enforces stringent regulations that can affect your domain's sender reputation. Two key indicators help track this reputation:

**Bounces**:

- Temporary issues cause soft bounces (e.g., recipient's mailbox at capacity), while permanent ones lead to hard bounces (e.g., invalid recipient address).
   - AWS will review your SES account if your bounce rate exceeds 5%.
   - You will be barred from sending emails until further investigation if your bounce rate surpasses **10%**.

**Complaints**:

- These events arise when a recipient manually flags your emails as unwanted (in essence, spam).
   - AWS will review your SES account if your complaint rate goes beyond 0.1%.
   - You will be barred from sending emails until further investigation if your complaint rate exceeds **0.5%**.

To monitor your bounce and complaint rate, Amazon SES has already built-in reputation tracking metrics on the [account level](https://docs.aws.amazon.com/ses/latest/dg/monitor-sender-reputation.html). However, we would like to be able to track reputation metrics such as bounce and complaint rate on an individual business unit level as well. To do so, we first need to enable configuration set's reputation tracking.

1. Modify the `TechNewsConfigSet` to allow tracking `BounceRate` and `ComplaintRate`:
```
aws sesv2 put-configuration-set-reputation-options --configuration-set-name TechNewsConfigSet --reputation-metrics-enabled
```

The Reputation.BounceRate Cloudwatch Metric generated by Amazon SES uses a secret Bounce Rate evaluation algorithm which is not disclosed to customers to avoid abuse. This metric is provided to help customers monitor their own SES environment's email reputation'. This metric will also not be affected by emails sent to the Mailbox Simulator.

2. Create a CloudWatch alarm with the following command:
```
aws cloudwatch put-metric-alarm --alarm-name AWSomeNewsletterBounceAlarm \
--alarm-description "Alarm triggered when bounce percentage is above 5% of total emails sent" \
--metric-name Reputation.BounceRate \
--namespace "AWS/SES" \
--statistic Sum \
--evaluation-periods 1 \
--period 86400 \
--threshold 0.05 \
--comparison-operator GreaterThanOrEqualToThreshold \
--dimensions Name=ses:configuration-set,Value=TechNewsConfigSet \
--evaluation-periods 1 \
--alarm-actions <sns-topic-arn>
```
{{% notice note %}}
The Reputation.BounceRate Cloudwatch Metric generated by Amazon SES uses a secret Bounce Rate evaluation algorithm which is not disclosed to customers to avoid abuse. This metric is provided to help customers monitor their own SES environment's email reputation'. This metric will also not be affected by emails sent to the Mailbox Simulator.
{{% /notice %}}

Replace `<sns-topic-arn>` with your own value. For simplicity's sake, you can choose to reuse the SNS topic ARN we created in the previous section to test out your implementation. The evaluation-periods parameter specifies how many periods the alarm should be evaluated before triggering a notification. In this case, it's set to 1, meaning that the alarm will only trigger if the bounce percentage is above 5% for one consecutive 24-hour (86400 seconds) period.
{{% notice note %}}
You can set up email or SMS notifications for this alarm by configuring an SNS topic and adding its ARN to the --alarm-actions parameter.
{{% /notice %}}

3. If you'd like to see your CloudWatch alarm in action, consider to create an alarm that monitors the number of complaint emails received instead:
```
aws cloudwatch put-metric-alarm --alarm-name AWSomeNewsletterComplainAlarm \
--alarm-description "Alarm triggered when 3 or more email complaints are received." \
--metric-name Complaint \
--namespace "AWS/SES" \
--statistic Sum \
--evaluation-periods 1 \
--period 60 \
--threshold 3 \
--comparison-operator GreaterThanOrEqualToThreshold \
--dimensions Name=ses:configuration-set,Value=TechNewsConfigSet \
--evaluation-periods 1 \
--alarm-actions <sns-topic-arn>
```
This command creates a Cloudwatch alarm that will send a notification everytime there are more than 3 complaint emails within a minute that are sent from the `TechNewsConfigSet` configuration set.