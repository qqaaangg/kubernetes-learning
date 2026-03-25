---
title : "Lists & Subscription"
date : "`r Sys.Date()`"
weight : 5
chapter : false
pre : " <b> 5. </b> "
---

In this lab, we will cover account-level suppression list, configuration set-level suppression, list management, and subscription management using Amazon Simple Email Service (SES) for the AWSomeNewsletter company.

### Scenario
AWSomeNewsletter is a rapidly growing company that sends out weekly newsletters and promotional emails to their customers. They want to ensure that they are maintaining a healthy email sending environment, respecting the preferences of their recipients, and complying with the best email sending practices.

### Introduction to Contact Lists and Subscription Topics
In Amazon SES, you have the ability to manage your recipient information using a contact list and subscription topics. Contact lists are collections of recipient email addresses that you use to send emails. Subscription topics are used to manage and organize your recipients based on their interests, preferences, or other criteria.

With Amazon SES, you can create a contact list and multiple subscription topics to help segment your recipients and send targeted, relevant content to them. This helps improve the email sending experience for both you and your recipients.

To learn more about contact lists, subscription topics, and their use cases, refer to the [Amazon SES documentation](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/using-contact-lists.html).

{{% notice note %}}
Please note that there is a limitation when using Amazon SES sandbox: For account-level suppression, bulk actions and SES API calls related to suppression list management are disabled. As a result, the steps outlined in this lab may not work if your account is still operating within the Amazon SES sandbox. Please ensure your account is out of the sandbox before proceeding with this lab.
{{% /notice %}}

### Outline
Throughout this lab, we will cover the following topics:

1. **Using the Account-Level Suppression List**: Learn how to work with the account-level suppression list to prevent sending emails to recipients who have previously bounced or complained. Recognize when to use account-level versus configuration set level.
2. **Using Configuration Set-Level Suppression**: Discover how to use suppression at the configuration set level to manage email sending based on specific conditions or requirements.
3. **List Management**: Understand how to create, maintain, and manage email lists to ensure you send emails to the right audience and keep your contacts organized.
4. **Subscription Management**: Dive into subscription management, including creating and using Amazon SNS topics, setting up Amazon SES to publish email sending events, and managing opt-in and opt-out preferences for your recipients.

Content
1. [Using the Account-Level Suppression List](5.1-account-level-suppression-list)
2. [Using Configuration Set-Level Suppression](5.2-configuration-set-level-suppression)
3. [List Management](5.3-list-management)
4. [Subscription Management](5.4-Subscription%20Management)