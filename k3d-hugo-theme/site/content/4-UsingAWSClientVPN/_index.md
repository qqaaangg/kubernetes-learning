---
title : "Sending Emails"
date : "`r Sys.Date()`"
weight : 3
chapter : false
pre : " <b> 3. </b> "
---

## Sending Emails Using Amazon SES
In this lab, you will learn how to send emails using Amazon Simple Email Service (SES) API and SMTP interface. Properly sending emails is crucial to maintain a good sender reputation and improve email deliverability.

### Scenario
Your company, AWSomeNewsletter, has set up a domain identity and verified an email identity to use as the sender address for your newsletter. In this workshop, we will guide you through sending emails using both the Amazon SES API and SMTP interface. You will learn how to configure and send different types of email messages, including plain text, HTML, and multipart emails with attachments.

### Amazon SES API and SMTP Interface
Amazon SES provides two interfaces for sending emails: the API and the SMTP interface. The API allows you to integrate email sending capabilities directly into your application or website, while the SMTP interface enables you to use an SMTP client to send emails.

The Amazon SES API provides additional features like bulk email sending and email sending with attachments, while the SMTP interface is a simpler option that supports plain text and HTML emails.

Amazon SES provides several API operations that you can use to send emails, including `SendEmail`, `SendRawEmail`, and `SendTemplatedEmail`.

The `SendEmail` API operation is used to send formatted email messages.
The `SendRawEmail` API operation is used to send email messages in their raw MIME format.
The `SendTemplatedEmail` API operation is used to send email messages based on a pre-defined template.
1. `SendEmail`: This operation will be used to send the regular company newsletter with formatted content.
2. `SendRawEmail`: This operation will be used to send the company newsletter with additional customizations, such as attachments or custom headers.
We will revisit how to send templated email in [Email Templates and Personalization](6-email-templates).

### Expected Outcomes
By the end of this lab, you will be able to:

- Configure and send emails using the Amazon SES API and SMTP interface
- Send different types of email messages, including plain text, HTML, and multipart emails with attachments

### Outline
This lab will have four parts:

1. **Sending emails using the Amazon SES SMTP interface**: We will walk through the process of configuring an SMTP client and sending an email using the [Amazon SES SMTP interface](https://docs.aws.amazon.com/ses/latest/dg/send-email-smtp.html).
2. **Sending Formatted Email using SendEmail API**: We will guide you through the process of sending emails using the [Amazon SES API](https://docs.aws.amazon.com/ses/latest/dg/send-email-smtp.html). You will learn how to send plain text and HTML email using the SendEmail API.
3. **Sending MIME Format Email using SendRawEmail API**: You will learn how to raw MIME email with a PDF attachment using the SendRawEmail API.
4. **Sending Test Email using the AWS CLI**: You will learn how to send test email using the AWS CLI to the [Mailbox Simulator](https://docs.aws.amazon.com/ses/latest/dg/send-an-email-from-console.html#send-email-simulator) addresses.

## Content

1. [Sending emails using the Amazon SES SMTP interface](3.1-ses-smtp)
2. [Sending Formatted Email using SendEmail API](3.2-sendmail-api)
3. [Sending MIME Format Email using SendRawEmail API](3.3-sendrawmail-api)
4. [Sending Test Email using the AWS CLI](3.4-testmail-aws-cli)
