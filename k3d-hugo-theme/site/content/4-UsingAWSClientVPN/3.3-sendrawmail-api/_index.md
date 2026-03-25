---
title : "SendRawEmail API"
date : "`r Sys.Date()`"
weight : 3
chapter : false
pre : " <b> 3.3 </b> "
---

## Sending MIME Format Email using SendRawEmail API

### SendRawEmail API operation
In this section, we will demonstrate how to use the SendRawEmail API operation with the AWS SDK for Python (Boto3) to send a company newsletter with attachments and custom headers. This operation allows you to send email messages in their raw [MIME format](https://docs.aws.amazon.com/ses/latest/dg/send-email-raw.html).

### Update your Lambda function code
Return to the [Lambda console](https://console.aws.amazon.com/lambda/) and the `send-email-demo` function created earlier.
Replace the existing code with the following code snippet:
```
"""
MIT No Attribution

Copyright 2023 Amazon.com, Inc. or its affiliates.  All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"""
import boto3
import base64
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    ses_client = boto3.client('ses')
    sender_email = "sender@example.com"
    recipient_email = "recipient@example.com"

    # Create the MIME object
    msg = MIMEMultipart()
    msg['Subject'] = 'Company Newsletter with Attachment'
    msg['From'] = sender_email
    msg['To'] = recipient_email

    # Add the newsletter content
    text = MIMEText('This is the content of the company newsletter with an attachment.', 'plain')
    msg.attach(text)

    # Add the attachment
    attachment = MIMEApplication('This is the attachment content.', _subtype='txt')
    attachment.add_header('Content-Disposition', 'attachment', filename='attachment.txt')
    msg.attach(attachment)

    try:
        # Send the email
        response = ses_client.send_raw_email(
            Source=sender_email,
            Destinations=[recipient_email],
            RawMessage={
                'Data': msg.as_string()
            }
        )
    except ClientError as e:
        print(e.response['Error']['Message'])
    else:
        print("Email sent! Message ID: ", response['MessageId'])
```
Replace `sender@example.com` and `recipient@example.com` with the email address that you'd like to send from and receive an email at respectively.

### Grant the Lambda function least privilege access for Amazon SES using SendRawEmail
1. Go to **Configuration** and then **Permissions**.
2. In the **Execution role** section, click on [your-role-name].
![Lambda function role](/hugo-ses/images/3/2/0004.png?featherlight=false&width=70pc)
3. This will open the IAM console in a new tab. Click Add permissions and then Create inline policy in the drop-down list.
4. Provide a name for the policy, such as `Lambda_SES_RAW`, and then click **Create policy**. Now, your Lambda function has the necessary permissions to send emails using Amazon SES.
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ses:SendRawEmail",
      "Resource": "*"
    }
  ]
}
```
![Policy](/hugo-ses/images/3/2/0005.png?featherlight=false&width=70pc)
![Policy create](/hugo-ses/images/3/3/0001.png?featherlight=false&width=70pc)
![Policy review](/hugo-ses/images/3/3/0002.png?featherlight=false&width=70pc)

### Test the SendRawEmail API operation
1. Return to the Lambda function console.
2. Make sure the TestEvent created earlier is still selected and click **Test** again.
If the email was sent successfully, you'll see a green **Execution result** box with a success message and the email's message ID. Check the recipient's mailbox to confirm that the company newsletter arrived with the specified subject and content, as well as the pdf attachment. Keep in mind that the email might end up in the spam folder.
![Result](/hugo-ses/images/3/3/0003.png?featherlight=false&width=70pc)