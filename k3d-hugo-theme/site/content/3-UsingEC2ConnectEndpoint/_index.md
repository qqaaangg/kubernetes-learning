---
title : "Configuration Sets"
date : "`r Sys.Date()`"
weight : 4
chapter : false
pre : " <b> 4. </b> "
---

## Managing your Amazon SES environment using Configuration Sets

In this lab, we will learn about configuration sets and how to use them to manage email sending with Amazon Simple Email Service (SES) API v2. We will explore the process of creating and managing configuration sets, setting up reputation options, and configuring events to track and analyze email sending metrics.

### Scenario
Your company, AWSomeNewsletter, is sending out regular company newsletters via email to its subscribers. As the number of subscribers is growing, you realize the importance of tracking the success and performance of your email campaigns. You need to manage and optimize your email sending strategies to maintain high deliverability rates and enhance subscriber engagement. In this workshop, we will guide you through using SES configuration sets to manage your email sending and optimize its performance.

### Configuration Sets
A configuration set is a collection of rules that define the behavior of your email sending. You can use configuration sets to set reputation options, define event destinations, and manage your email sending metrics. SES uses configuration sets to apply rules and policies to your email sending, improving your email deliverability and engagement. Refer to the Amazon SES Developer Guide  for more information on Configuration Sets.

### Why Use Configuration Sets?
Using configuration sets allows you to manage your email sending operations more efficiently and effectively. By separating your email sending activities into different configuration sets, you can:

- Define specific email sending rules and settings tailored to each business unit or customer segment.
- Monitor and analyze email sending activities and performance for each configuration set separately.
- Manage bounce and complaint handling, email feedback loops, and reputation metrics for each configuration set independently.
- Easily enable or disable email sending activities for specific configuration sets, depending on your business needs.

Outline
The purpose of this lab is to guide you through the process of creating and managing SES configuration sets, setting up reputation options, and configuring event destinations. This lab will go through:

1. **Creating Configuration Sets**: We will explore how to create SES configuration sets and configure reputation options, such as bounce and complaint handling.
2. **Setting up Event Destinations**: We will learn how to configure event destinations, such as Amazon SNS or AWS Lambda, to track and analyze email sending metrics, including open and click-through rates.
3. **Managing Configuration Sets**: We will explore how to manage and modify SES configuration sets, including updating reputation options, event destinations and using tags to query granular configuration set properties.

### Content

1. [Creating configuration sets](4.1-configuration-set-create/)
2. [Setting up Event Notifications with SNS](4.2-event-notification-with-sns/)
3. [Setting up Event Notifications with Cloudwatch](4.3-event-notification-with-cloudwatch/)
4. [Setting up Event Notifications with Kinesis Data Firehose](4.4.-event-notification-with-kinesis/)
5. [Testing Event Notifications for your Configuration Sets](4.5.-test-event-notification/)
