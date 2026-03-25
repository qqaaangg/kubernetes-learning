---
title : "AWS Verified Access trust provider"
date :  "`r Sys.Date()`" 
weight : 3
chapter : false
pre : " <b> 2.3 </b> "
---

### Create AWS Verified Access trust provider using Amazon Cognito

One of the key components of AWS Verified Access is the trust provider. A Verified Access trust provider is a service that manages user identities or device security state. Verified Access works with both AWS and third-party trust providers. You must attach at least one trust provider to each Verified Access instance. You can attach a single identity trust provider and multiple device trust providers to each Verified Access instance.

In this section, we will configure Amazon Cognito as the Verified Access trust provider within the Verified Access console.

#### Steps to create AWS Verified Access trust provider using Amazon Cognito
1. In the previous step you created Amazon Cognito Users. Now we will collect details from **Amazon Cognito** which are needed to create a Verified Access trust provider. From the user pool named `MyUserPool` we will collect the following items and save them in a text editor as we will use these details later in this lab.

- Copy **User pool ID**
- Go to **App integration** tab and in **Domain** panel, select **Action** then **Create Custom Domain**
![Create domain](/images/2/3/0001.png?featherlight=false&width=70pc)

- Provide an subdomain, review if domain is available and click **Creat Cognito Domain**.
![Provide domain](/images/2/3/0002.png?featherlight=false&width=70pc)

- Copy **Domain**
![Store Domain](/images/2/3/0003.png?featherlight=false&width=70pc)


- While under **App integration** tab scroll down to **App client list** and select **MyAppClient**. Copy **Client ID** and **Client Secret**

You should now have the following 4 items in your text editor.

{{% notice note %}}
Below are examples of what the output would look like.
{{% /notice %}}

- **User pool ID**: us-east-1_kpauOUMLl
- **Cognito Domain**: https://012345678901.auth.us-east-1.amazoncognito.com 
- **Client ID**: 1asg0123456789abcdefghdcag
- **Client Secret**: 1d7j0123456789abcdefgh5trqr0123456789abcdefgh6u1
Now we will use these details to create a Verified Access trust provider.

2. Search `VPC` in the Services search bar. Select VPC from the list.

<!--  -->

3. In the navigation pane, choose **Verified Access trust providers**, and then **Create Verified Access trust provider**.

<!--  -->

4. Items below will be used to complete the creation of AWS Verified Access provider.

<!--  -->

Screenshots below show an example of what the entire screen looks like when you have completed inputting the details
{{% notice note %}}
By Default **IAM Identity Center** is selected for **User trust provider type** and you will see a text in Red saying **IAM Identity Center status** is **Not Enabled**. This is because we don't have IAM Identity Center enabled for the workshop. Please ignore this message.
{{% /notice %}}
<!--  -->

5. Scroll down, keep rest of the fields as default and choose **Create Verified Access trust provider**.
<!--  -->

6. A green banner will appear indicating that the operation was successful.