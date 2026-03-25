---
title : "Self-hosted Zone"
date :  "`r Sys.Date()`" 
weight : 1
chapter : false
pre : " <b> 2.1 </b> "
---

In order to access an application using HTTPs, you need to setup a DNS entry in Amazon Route 53 using the domain name you own and an SSL/TLS certificate for your application.

### Create Route53 Hosted Zone
1. From the **AWS Console** enter `Route 53` in the Services search bar. Select **Route 53** from the list.
2. Select **Hosted Zone** from the left pannel, click **Create hosted zone**.
![Create Hosted Zone](/images/2/1/0001.png?featherlight=false&width=70pc)

3. Enter your Domain name for example: **example.com**, select **Type** as **Public hosted zone** and select **Create hosted zone**.
![Fill In Hosted Zone](/images/2/1/0002.png?featherlight=false&width=70pc)

4. Copy **Hosted Zone Name** and save it to a text editor.
![Hosted Zone Name](/images/2/1/0003.png?featherlight=false&width=70pc)

### Create Certificate in AWS Certificate Manager
1. From the **AWS Console** enter `Certificate Manager` in the Services search bar. Select **Certificate Manager** from the list.
2. Select **Request a certificate** on the right side of the screen.
![ACM Console](/images/2/1/0004.png?featherlight=false&width=70pc)

3. Select **Request a public certificate** and Select **Next**.
![Request certificate](/images/2/1/0005.png?featherlight=false&width=70pc)

4. Enter the Hosted zone name (Domain Name) you copied in the previous step under **Fully qualified domain name**, for example, yourdomainname.com. Select **Add another name** to this certificate and enter `*.` followed by yourdomainname.com.

5. Select **DNS Validation** for **Validation** method and select **Request**.
![Fill in fields](/images/2/1/0006.png?featherlight=false&width=70pc)

6. Select the certificate by choosing the **Certificate ID**.
![Copy Certificate ID](/images/2/1/0007.png?featherlight=false&width=70pc)

7. Select **Create records in Route 53** to create a DNS record in Amazon Route 53.
![Create CName Records](/images/2/1/0008.png?featherlight=false&width=70pc)

8. Select **Create records** to create DNS record.

9. After few minutes certificate status will change to **Issued**.
![Certificate Status Checking](/images/2/1/0009.png?featherlight=false&width=70pc)
