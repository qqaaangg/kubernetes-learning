---
title : "SendEmail API"
date : "`r Sys.Date()`"
weight : 2
chapter : false
pre : " <b> 3.2 </b> "
---

## Sending Formatted Email using SendEmail API

### Using the SendEmail API
In this section, we will guide you on how to use the AWS SDK for Python (Boto3) to send emails using SES. We will create an AWS Lambda function to demonstrate email sending, which will be triggered by an event.

### Create an AWS Lambda function
1. Navigate to the [Lambda console](https://console.aws.amazon.com/lambda/), and click on **Functions**.
2. Click on **Create function**.
![Lambda console](/hugo-ses/images/3/2/0001.png?featherlight=false&width=70pc)
3. Select **Author from scratch**.
4. Provide the following information:
- **Function name**: `send-email-demo`
- **Runtime**: `Python 3.9` (or a later version)
- **Architecture**: `x86_64`
5. Click **Create function** to confirm.
![Lambda create](/hugo-ses/images/3/2/0002.png?featherlight=false&width=70pc)
6. Under **Code source**, copy your code as follows:
```
import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    ses_client = boto3.client('ses')
    sender_email = "sender@example.com"
    recipient_email = "recipient@example.com"

    try:
        response = ses_client.send_email(
            Source=sender_email,
            Destination={
                'ToAddresses': [recipient_email]
            },
            Message={
                'Subject': {
                    'Data': 'Company Newsletter'
                },
                'Body': {
                    'Text': {
                        'Data': 'This is the content of the company newsletter.'
                    }
                }
            }
        )
    except ClientError as e:
        print(e.response['Error']['Message'])
    else:
        print("Email sent! Message ID: ", response['MessageId'])
```
Replace `sender@example.com` with your verified sender email address and `recipient@example.com` with the recipient email address.
7. Click **Deploy**
![Lambda function content](/hugo-ses/images/3/2/0003.png?featherlight=false&width=70pc)

### Grant the Lambda function least privilege access for Amazon SES
1. Go to **Configuration** and then **Permissions**.
2. In the **Execution role** section, click on [your-role-name].
![Lambda function role](/hugo-ses/images/3/2/0004.png?featherlight=false&width=70pc)
3. This will open the IAM console in a new tab. Click Add permissions and then Create inline policy in the drop-down list.
4. Provide a name for the policy, such as `Lambda_SES`, and then click **Create policy**. Now, your Lambda function has the necessary permissions to send emails using Amazon SES.
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ses:SendEmail",
      "Resource": "*"
    }
  ]
}
```
![Policy](/hugo-ses/images/3/2/0005.png?featherlight=false&width=70pc)
![Policy create](/hugo-ses/images/3/2/0006.png?featherlight=false&width=70pc)
![Policy review](/hugo-ses/images/3/2/0007.png?featherlight=false&width=70pc)

### Call the API function to send email
1. Return [Lambda console](https://console.aws.amazon.com/lambda/), and click on **Functions**.
2. Select the send-email-demo function we created earlier
3. Click on the down arrow next to **Test**.
4. Click on **Configure test event**.
![Test Event](/hugo-ses/images/3/2/0008.png?featherlight=false&width=70pc)
5. Select Create new test event.
6. Provide an event name, such as `TestEvent`. You don't need to modify the JSON input, as we are not using it in this example. Click Create.
![Trigger Test Event](/hugo-ses/images/3/2/0009.png?featherlight=false&width=70pc)
![Trigger Test Event](/hugo-ses/images/3/2/0010.png?featherlight=false&width=70pc)
7. With the `TestEvent` selected, click **Test** again.
If the email was sent successfully, you'll see a green **Execution result** box with a success message and the email's message ID. Check the recipient's mailbox to confirm that the email arrived with the specified subject and content. Keep in mind that the email might end up in the spam folder.
![Test Event Result](/hugo-ses/images/3/2/0011.png?featherlight=false&width=70pc)
Congratulations! You have successfully set up an AWS Lambda function using the AWS SDK for Python (Boto3) to send emails with Amazon SES. You can now modify the Lambda function code to send emails programmatically from your applications as needed.