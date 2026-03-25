---
title : "Getting Started"
date : "`r Sys.Date()`"
weight : 1
chapter : false
pre : " <b> 1. </b> "
---

## Getting Started with your own AWS Account

{{% notice note %}}
Remember to [clean up](../5-Summary/5.2-CleanUpResources/) the resources after finishing up the labs.
{{% /notice %}}

{{% notice note %}}
This workshop require a public hosted domain name. If you do not have one, you can register one using Amazon Route 53. Pricing for each TLD can be found on the [Amazon Route 53 pricing page](https://aws.amazon.com/route53/pricing/)
{{% /notice %}}

{{% notice note %}}
This workshop will create following resources using provided CloudFormation template. Please make sure user has appropriate IAM access to deploy these resources via CloudFormation: VPC with 8 Subnets, a Web application deployed on a Lambda and a Internal ALB, a RDS Instance, EC2 Insatance and Amazon Cognito
{{% /notice %}}

{{% notice note %}}
The resources created throughout these labs incur costs in your AWS Account. Consider deleting the resources created once you've completed the labs. For more information, visit the pricing page of [AWS Verified Access](https://aws.amazon.com/verified-access/pricing/), [AWS Client VPN](https://aws.amazon.com/vpn/pricing/), [AWS Private Link](https://aws.amazon.com/vpn/pricing/), [Amazon Cognito](https://aws.amazon.com/cognito/pricing/), [Elastic Load Balancer](https://aws.amazon.com/elasticloadbalancing/pricing/), [EC2](https://aws.amazon.com/ec2/pricing/), [Amazon Route53](https://aws.amazon.com/route53/pricing/) and [Amazon RDS](https://aws.amazon.com/rds/pricing/).
{{% /notice %}}

### Create EC2 Key Pair
For [Lab 2: Connect to an Amazon EC2 instance using Amazon EC2 Instance Connect Endpoint](../3-UsingEC2ConnectEndpoint/), you will need an EC2 key pair to SSH into an EC2 instance from your CLI. In this step we will create a new EC2 Key pair and provide the same while deploying the CloudFormation template in the next step.

1. From the **AWS Console** enter `EC2` in the Services search bar. Select EC2 from the list.
![Select EC2](/images/1/0001.png?featherlight=false&width=70pc)

2. In the navigation pane, choose **Key Pairs**, and then choose **Create key pair**.
![Create Key Page](/images/1/0002.png?featherlight=false&width=70pc)

3. On the **Create key pair** page:
- For Name enter `ws-default-keypair`
- For Key pair type choose **RSA**
- For Private key file format choose **.pem**
- Choose **Create key pair**
![Key Information](/images/1/0003.png?featherlight=false&width=50pc)

4. A popup will open to download the **Key**, save it on your local drive.

### Deploying AWS Verified Access Workshop prerequisites using Infrastructure as Code (IAC)
1. If you are using a personal or corporate account to deploy the workshop prerequisite resources, download the [Setting up remote access to VPC Resources CloudFormation Template](https://static.us-east-1.prod.workshops.aws/public/b48f9348-def9-4cda-8c1f-784513ea7534/static/selfhostedworkshop.yaml).

2. From the **AWS Console** enter `CloudFormation` in the Services search bar. Select **CloudFormation** from the list.
![Select CloudFormation](/images/1/0004.png?featherlight=false&width=70pc)

3. Select **Create Stack** on the right side of the screen and select **“With new resources (standard)”**.
![Create Stack](/images/1/0005.png?featherlight=false&width=70pc)

4. Select **Upload a template file** and **Choose file**. Select the template you downloaded in **Step 1** and select **Next**.
![Upload Template](/images/1/0006.png?featherlight=false&width=70pc)

5. Enter below values and select **Next**.
Item | Set value | Example  |
------|------------|----------|
Stack Name | `Setting-up-remote-access` | Setting-up-remote-access |
CallbackURLs | `https://hr.<yourdomainname.com>` replace **yourdomainname** with the domain name you own. | `https://hr.example.com` |
EC2KeyPair | `ws-default-keypair` | `ws-default-keypair` |

![Fill In Stack Information](/images/1/0007.png?featherlight=false&width=70pc)

6. Select **Next** on next screen.

7. Scroll to the bottom of the screen and select **I acknowledge ...**, then select **Submit**.

![Accept Policy](/images/1/0008.png?featherlight=false&width=70pc)
