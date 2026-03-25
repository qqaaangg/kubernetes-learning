---
title : "SES SMTP"
date : "`r Sys.Date()`"
weight : 1
chapter : false
pre : " <b> 3.1 </b> "
---
## Sending emails using the Amazon SES SMTP interface

The SMTP interface is a standard protocol for sending emails over the internet. You can use the SES SMTP endpoint to send emails from your applications or email clients.

To set up email sending using the SMTP interface, you'll need to:

1. Create SMTP credentials for your SES account.
2. Test your connection to ensure you can send emails.
3. Authenticate using the SMTP credentials generated in step 1 and then send a test email through the AWS CLI.

### Create SMTP credentials for your SES account
![[Process]](/hugo-ses/images/3/1/0001.png?featherlight=false&width=90pc)

1. Sign in to the [Amazon SES console](https://console.aws.amazon.com/ses/).
2. In the navigation pane, choose **SMTP Settings**.
3. Click **Create My SMTP Credentials**.
4. Provide a name for your SMTP user, or use the default name provided by Amazon SES. Click **Create**.
5. Download and save your SMTP credentials (IAM user access key ID and secret access key) in a secure location. You will need these credentials later. Click **Close**.
![Store credentials](/hugo-ses/images/3/1/0002.png?featherlight=false&width=90pc)
{{% notice note %}}
You cannot view or retrieve the secret access key after this step. If you lose the secret access key, you must create new SMTP credentials.
{{% /notice %}}
For more details on creating SMTP credentials, refer to the official [documentation](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/smtp-credentials.html).

### Using the command line to send emails with the Amazon SES SMTP interface
While you will not be using the command line to send messages in production, when you are setting up your SMTP server, you'd want to use this procedure to test your SMTP credentials and the ability of specific recipients to receive messages that you send by using Amazon SES for your company newsletter.

1. Navigate back to the [Amazon SES console](https://console.aws.amazon.com/ses/).
2. From the navigation pane, choose **Account dashboard**.
3. Under **Simple Mail Transfer Protocol (SMTP) settings**, note the following:
- **SES SMTP endpoint**: `email-smtp.[region].amazonaws.com`, where `[region]` is the AWS region where your SES account is located.
- **STARTTLS Port**: 25, 587, or 2587. Amazon SES reserves port 587 for explicit SSL, which we will be using in the next section.
![[Test Connection]](/hugo-ses/images/3/1/0003.png?featherlight=false&width=90pc)

### Testing the SSL Connection
1. Open your terminal or command prompt. The openssl command-line tool is pre-installed on most operating systems.
{{% notice note %}}
If you're using [AWS CloudShell](https://aws.amazon.com/cloudshell/), you'd need to run sudo yum install openssl first.
{{% /notice %}}
2. Type the following command and replace <SES_SMTP_ENDPOINT> with the SMTP endpoint of your SES account in the appropriate region that you obtained in step 1.2.1:
```
openssl s_client -crlf -quiet -starttls smtp -connect <SES_SMTP_ENDPOINT>:587
```
3. Press enter. If the connection was successful, you should see output similar to the following:
```
depth=2 C = US, O = Amazon, CN = Amazon Root CA 1
verify return:1
depth=1 C = US, O = Amazon, CN = Amazon RSA 2048 M01
verify return:1
depth=0 CN = email-smtp.us-east-1.amazonaws.com
verify return:1
250 Ok
```
4. If you receive a `Connection refused` error, check that your SES SMTP endpoint is correct and that you have opened port 587 in your firewall. For more information on troublshooting SMTP connectivity or timeout issues with Amazon SES (especially with EC2 instances), refer to the [following guideline](https://repost.aws/knowledge-center/smtp-connectivity-timeout-issues-ses).
5. If the connection was successful, type `QUIT` to close the connection and press Enter.
After successfully testing the SSL connection, you can proceed to send your company newsletter using the Amazon SES SMTP interface.

### Sending Email through the Command Line
{{% notice warning %}}
The connection automatically closes after about 10 seconds of inactivity. To make sure that you have enough time to enter subsequent commands, prepare them ahead of time (on a separate text file) and copy/paste into your command line session.
{{% /notice %}}

1. Before pasting the `AUTH LOGIN` command, you will need to encode your SMTP username and password in base64 format. To do this, you can use an online tool or run the following commands in the terminal window. Replace `<smtp-username>` and `<smtp-password>` with the username and password you got from the credentials file obtained in [Create SMTP credentials for your SES account](https://catalog.us-east-1.prod.workshops.aws/workshops/e4a4aa26-fb17-45eb-9edf-77b7f8b6035f/en-US/lab-2/lab-2-1#create-smtp-credentials-for-your-ses-account).
```
echo -n <smtp-username> | base64
echo -n <smtp-password> | base64
```
You will see 2 strings that will represent the 64-base encoded values of your smtp username and password accordingly. Note them down for the next step.

2. Prepare the following command in a text file:
```
EHLO amazonses.com
AUTH LOGIN
<base64-encoded username>
<base64-encoded password>
MAIL FROM:<sender@example.com>
RCPT TO:<recipient@example.com>
DATA
Subject: Test Company Newsletter Email

This is a test email for the company newsletter sent using the Amazon SES SMTP interface from the command line.
.
QUIT
```
- Replace `<base64-encoded username>` with your SMTP username, encoded in Base64.
- Replace `<base64-encoded password>` with your SMTP password, encoded in Base64.
- Replace `<sender@example.com>` with the email address you verified in [Email Identities](2.1-email-identity).
- Replace `<recipient@example.com>` with the address you want to receive the email.
{{% notice note %}}
If you're sending to a different email address and you're in a sandbox SES environment, you'd need to also verify the recipient address because sandbox environment will only allow sending to verified email addresses.
{{% /notice %}}
3. You are now ready to send the email. First, repeat step 2 in section Testing the SSL Connection to initiate the SSL connection:
```
openssl s_client -crlf -quiet -starttls smtp -connect <SES_SMTP_ENDPOINT>:587
```
4. After the secure TLS connection is established, copy and paste the command you prepared in step 2 into the terminal window and press Enter.
{{% notice warning %}}
The connection automatically closes after about 10 seconds of inactivity. Quickly paste the command you prepared earlier in step 2. If the connection times out, you'll have to repeat step 4 again.
{{% /notice %}}
5. If the email was successfully sent, you will see output similar to the following:
```
250-email-smtp.amazonaws.com
250-8BITMIME
250-STARTTLS
250-AUTH PLAIN LOGIN
250 Ok
334 VXNlcm5hbWU6
334 UGFzc3dvcmQ6
235 Authentication successful.
250 Ok
250 Ok
354 End data with <CR><LF>.<CR><LF>
250 Ok 010001870dbae81e-35118332-f389-474c-8b37-69ce1e1934ae-000000
221 Bye
```
6. Check the recipient's mailbox to see your test company newsletter email arriving with the Subject and Content you've specified earlier. (Your email might end up in the spam folder; we will learn about best practices on how to improve your mailing reputation in [Capstone Project](7-capstone-project).)