---
title : "AWS CLI"
date : "`r Sys.Date()`"
weight : 3
chapter : false
pre : " <b> 3.4 </b> "
---

## Sending Test Email using the AWS CLI
In this lab, you will learn how to send an email using Amazon Simple Email Service (SES) v2 with AWS CLI. In practice, developers can use the AWS CLI to quickly test their email deliverability and SES configurations. We will show you how to quickly send a formatted test email and how to use the [Mailbox Simulator](https://docs.aws.amazon.com/ses/latest/dg/send-an-email-from-console.html#send-email-simulator) to send a test email that to an address that will mimic behaviors such as successful delivery, bounce, complaint, etc. We will see how testing can be useful in [4.5: Testing Event Notifications for your Configuration Sets](../../4-ManageEnvironment/4.5-test-event-notification) when we look at testing our configuration sets event notifications.

{{% notice note %}}
This lab can only be done using the Amazon SES API and not in the Amazon SES console.
{{% /notice %}}

### Sending Formatted Email (Simple)
Using the SendEmail API in [3.2: Sending Formatted Email using SendEmail API](../3.2-sendmail-api), you can send emails directly from the AWS CLI.

{{< tabs groupId="send-formmated-email" >}}
{{% tab name="Verified Email Address" %}}

Use the following command to send an email to a verified email address:
```
aws sesv2 send-email \
    --from-email-address sender@example.com \
    --destination ToAddresses=recipient@example.com \
    --content '{"Simple": {"Subject": {"Data": "Test Email","Charset": "UTF-8"},"Body": {"Text": {"Data": "This is a test email sent using the AWS CLI SESv2.","Charset": "UTF-8"},"Html": {"Data": "This is a test email sent using the AWS CLI SESv2.","Charset": "UTF-8"}}}}'
```
Replace `sender@example.com` with your own verified sending email address and `recipient@example.com` with the corresponding receiver's email address. If you are in a Production environment, you can send email to unverified email addresses.

Once done, you can open the recipient's mailbox to verify that the email is sent successfully.

{{% /tab %}}
{{% tab name="Success" %}}

Use the following command to send an email to the bounce mailbox simulator address:
```
aws sesv2 send-email \
    --from-email-address sender@example.com \
    --destination ToAddresses=success@simulator.amazonses.com \
    --content '{"Simple": {"Subject": {"Data": "Test Email to Success Mailbox Simulator","Charset": "UTF-8"},"Body": {"Text": {"Data": "This is a test email to the success mailbox simulator.","Charset": "UTF-8"},"Html": {"Data": "This is a test email to the success mailbox simulator.","Charset": "UTF-8"}}}}'
```
Replace `sender@example.com` with your own verified sending email address.

{{% /tab %}}
{{% tab name="Bounce" %}}

Use the following command to send an email to the bounce mailbox simulator address:
```
aws sesv2 send-email \
    --from-email-address sender@example.com \
    --destination ToAddresses=bounce@simulator.amazonses.com \
    --content '{"Simple": {"Subject": {"Data": "Test Email to Bounce Mailbox Simulator","Charset": "UTF-8"},"Body": {"Text": {"Data": "This is a test email to the bounce mailbox simulator.","Charset": "UTF-8"},"Html": {"Data": "This is a test email to the bounce mailbox simulator.","Charset": "UTF-8"}}}}'
```
Replace `sender@example.com` with your own verified sending email address.

{{% /tab %}}
{{% tab name="Out-of-the-Office" %}}

Use the following command to send an email to the auto-reply (out-of-the-office) mailbox simulator address:
```
aws sesv2 send-email \
    --from-email-address sender@example.com \
    --destination ToAddresses=ooto@simulator.amazonses.com \
    --content '{"Simple": {"Subject": {"Data": "Test Email to Out-of-the-Office Mailbox Simulator","Charset": "UTF-8"},"Body": {"Text": {"Data": "This is a test email to the Out-of-the-Office mailbox simulator.","Charset": "UTF-8"},"Html": {"Data": "This is a test email to the Out-of-the-Office mailbox simulator.","Charset": "UTF-8"}}}}'
```
Replace `sender@example.com` with your own verified sending email address.

{{% /tab %}}
{{% tab name="Complaint" %}}

Use the following command to send an email to the complaint mailbox simulator address:
```
aws sesv2 send-email \
    --from-email-address sender@example.com \
    --destination ToAddresses=complaint@simulator.amazonses.com \
    --content '{"Simple": {"Subject": {"Data": "Test Email to Complaint Mailbox Simulator","Charset": "UTF-8"},"Body": {"Text": {"Data": "This is a test email to the complaint mailbox simulator.","Charset": "UTF-8"},"Html": {"Data": "This is a test email to the complaint mailbox simulator.","Charset": "UTF-8"}}}}'
```
Replace `sender@example.com` with your own verified sending email address.

{{% /tab %}}
{{% tab name="Suppression List" %}}

While we will be learning more about suppression lists in [5. Email Templates and Personalization](5-ListAndSubscription), you can use the following command to simulate a hard bounce as if the recipient's address is on the global suppression list.
```
aws sesv2 send-email \
    --from-email-address sender@example.com \
    --destination ToAddresses=suppressionlist@simulator.amazonses.com \
    --content '{"Simple": {"Subject": {"Data": "Test Email to Suppression List Mailbox Simulator","Charset": "UTF-8"},"Body": {"Text": {"Data": "This is a test email to the suppression list mailbox simulator.","Charset": "UTF-8"},"Html": {"Data": "This is a test email to the suppression list mailbox simulator.","Charset": "UTF-8"}}}}'
```
Replace `sender@example.com` with your own verified sending email address.

{{% /tab %}}
{{< /tabs >}}

### Sending MIME Format Email (Raw)
Alternatively, similar to [3. Sending MIME Format Email using SendRawEmail API](/../../3.3-sendrawmail-api), you can also choose to send a raw MIME format using the SendRawEmail API.