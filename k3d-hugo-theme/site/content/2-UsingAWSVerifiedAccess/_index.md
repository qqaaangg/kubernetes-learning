---
title : "Lab 1"
date : "`r Sys.Date()`"
weight : 2
chapter : false
pre : " <b> 2. </b> "
---

# CONNECT TO AN INTERNAL WEB APPLICATION USING AWS VERIFIED ACCESS

### What is AWS Verified Access?
[AWS Verified Access](https://aws.amazon.com/verified-access/) allows you to provide secure network access to corporate applications without a VPN. Verified Access verifies each access request in real time and only connects users to the applications they are allowed to access, removing broad access to corporate applications and reducing the associated risks. To verify users against specific security requirements, Verified Access integrates with AWS and third-party security services to source information about identity, device security status, and location. IT administrators can use Verified Access to author a set of policies that define a user’s ability to access each application. Verified Access also simplifies security operations by allowing administrators to efficiently set and monitor access policies, freeing time to update policies, respond to security and connectivity incidents, and audit for compliance standards.

AWS Verified Access evaluates each application request from your users and allows access based on:

- Trust data sent by your chosen trust provider (from AWS or a third party).
- Access policies that you create in Verified Access.

When a user tries to access an application, Verified Access gets their data from the trust provider and evaluates it against the policies that you set for the application. Verified Access grants access to the requested application only if the user meets your specified security requirements.

A trust provider is a service that sends information about users and devices, called trust data, to AWS Verified Access. Trust data may include attributes based on user identity such as an email address or membership in the "sales" organization, or device management information such as security patches or antivirus software version. Verified Access supports the following categories of trust providers:

- User identity – An identity provider (IdP) service that stores and manages digital identities for users.
- Device management – A device management system for devices such as laptops, tablets, and smartphones.

In this lab, you will use User identity based trust to provide access to the applications. You will use Cognito as the user identity trust provider. In the remainder of this session you will perform the following steps to configure the trust provider, configure Verified Access and test the application access.

### Content

1. [Self-hosted Zone](2.1-SelfHostedZone/)
2. [Create Amazon Cognito users](2.2-AmazonCognitoUsers/)
3. [Create AWS Verified Access trust provider using Amazon Cognito](2.3-AmazonCogitoTrustProvider/)
4. [Create AWS Verified Access Instance](2.4-AWSVerifiedAccessInstance/)
5. [Create AWS Verified Access Groups with basic policy](2.5-AWSVerifiedAccessGroups/)
6. [Create AWS Verified Access Endpoint](2.6-AWSVerifiedAccessEndpoint/)
7. [Update Amazon Route 53](2.7-UpdateRoute53/)
8. [Test the application](2.8-TestApplication/)
