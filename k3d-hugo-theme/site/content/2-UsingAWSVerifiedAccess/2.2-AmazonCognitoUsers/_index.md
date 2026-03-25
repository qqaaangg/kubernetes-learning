---
title : "Create Amazon Cognito Users"
date :  "`r Sys.Date()`" 
weight : 2
chapter : false
pre : " <b> 2.2 </b> "
---

### Steps to create Amazon Cognito User Pool
1. Search `Cognito` in the Services search bar. Select **Cognito** from the list.

2. Select **Create User Pool**

Now we need to create users that we can use to test the application later. We will create two HR users, one with an email address verified and the other with an email address that is not verified.

- First, create one User Pools:
![Amazon Cognito](/images/2/2/0001.png?featherlight=false&width=70pc)
![Step 1](/images/2/2/0002.png?featherlight=false&width=70pc)
![Step 2](/images/2/2/0003.png?featherlight=false&width=70pc)
![Step 4](/images/2/2/0004.png?featherlight=false&width=70pc)
![Step 5](/images/2/2/0005.png?featherlight=false&width=70pc)
![Step 6](/images/2/2/0006.png?featherlight=false&width=70pc)

- Second, create two HR users:

    **Step 1**: select **Create user** to create a new user.

    **Step 2**: provide an Email Address for the **HR user-1**. Append `+hruser1` to your email alias to create the HR user. For example, `example+hruser1@example.com`. 

    **Step 3**: Select **Mark email address as verified**. 

    **Step 4**: Provide a **Temporary password** and select **Create user**. 
![Create User](/images/2/2/0007.png?featherlight=false&width=70pc)
![User Information](/images/2/2/0008.png?featherlight=false&width=70pc)
    **Step 5**: repeat Steps 1-2 to add **HR user-2**, append `+hruser2` to your email alias to create the second HR user. For example, `example+hruser2@example.com`.
{{% notice note %}}
You can use any email address you wish to use.
{{% /notice %}}
    **Step 6**: don't select **Mark email address as verified**.

    **Step 7**: provide a **Temporary password** and select **Create user**.
{{% notice note %}}
You can use same or different passwords for both users.
{{% /notice %}}

You have successfully created 2 users one with `Email Verified` as **Yes** and other with `Email Verified` as **No**.
![List Users](/images/2/2/0009.png?featherlight=false&width=70pc)