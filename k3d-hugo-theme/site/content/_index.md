---
title : "Setting up remote access to VPC Resources"
date : "`r Sys.Date()`"
weight : 1
chapter : false
---

# Setting up remote access to VPC Resources

### Overview
This workshop is designed to learn how you can access resources in your VPC privately without having to deploy an internet gateway and connect your resources to the internet. In each module, the workshop provides a different connectivity options like AWS Verified Access, Amazon EC2 Instance Connect endpoint and AWS Client VPN to access resources inside your VPC. You are encouraged to execute these tasks on your own. The workshop also provides instructions to guide you through each of the tasks, as a reference.
![VPC](images/vpc.png?featherlight=false&width=10pc)

### Learning Objectives
In this workshop, you will learn how to create, configure, and test three different types of remote connectivity options to access your VPC resources.
1. Remote connectivity using AWS Verified Access.
2. Remote connectivity using Amazon EC2 Instance Connect endpoints.
3. Remote connectivity using AWS Client VPN.

### Outcome
Upon completion of this workshop, you will:

1. **Utilize AWS Verified Access**: Gain the knowledge to use AWS Verified Access to grant secure access to internal web applications.
2. **Enable SSH Connections**: Learn how to utilize Amazon EC2 Instance Connect endpoints for secure SSH connections to servers.
3. **Master AWS Client VPN**: Acquire the skills to configure and utilize AWS Client VPN, enabling network-level access for remote users.
4. **Apply Practical Knowledge**: Obtain hands-on experience and real-world use cases for each service, ensuring you're prepared to apply your skills in practical scenarios.

### Workshop Duration
The workshop will require one and half hour to complete. Depending on your experience with AWS networking, the duration to complete may vary.

![Diagram](images/diagram.png?featherlight=false&width=70pc)

### Content

1. [Getting Started](1-GettingStarted/)
2. [**Lab 1**: Connect to an internal web application using AWS Verified Access](2-UsingAWSVerifiedAccess/)
3. [**Lab 2**: Connect to an Amazon EC2 instance using Amazon EC2 Instance Connect Endpoint](3-UsingAWSClientVPN/)
4. [**Lab 3**: Connect to VPC resources using AWS Client VPN with Mutual authentication (certificate-based)](4-UsingEC2ConnectEndpoint/)
5. [Summary](5-Summary/)