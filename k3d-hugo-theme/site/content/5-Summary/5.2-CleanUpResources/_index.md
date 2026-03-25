---
title : "Using Configuration Set-Level Suppression"
date : "`r Sys.Date()`"
weight : 2
chapter : false
pre : " <b> 5.2 </b> "
---

In this section, we will explore configuration set-level suppression, which allows you to manage email sending for specific configuration sets. This gives AWSomeNewsletter company more granular control over the suppression of email addresses, ensuring that they only suppress recipients for specific types of emails or campaigns. For how configuration set-level suppression lists works with account-level, refer to the [documentation](https://docs.aws.amazon.com/ses/latest/dg/sending-email-suppression-list-config-level.html).

In short, there are different levels of suppression:

- **No overrides (default)** – the configuration set uses your account-level suppression list settings.
- **Override account level settings** – this will negate any account-level suppression list settings; email sent with this configuration set will not use any suppression settings at all.
- **Override account level settings with configuration set-level suppression enabled** – email sent with this configuration set will only use the suppression conditions you enabled for it (bounces, complaints, or bounces and complaints) - regardless of what your account-level suppression list settings are, it will override them.
And the way they interact is based on the following workflow:
![Workflow](/hugo-ses/images/5/1/0001.png?featherlight=false&width=50pc)

Using the configuration sets we've already created in [Lab 4.1](../../4-ManageEnvironment/4.1-configuration-set-create), let's learn how to manage suppression lists on the account and configuration sets level.

### Override account level settings
For Small Businesses customer segment, you want to override the account-level suppression list because you want to maximize the reach of your emails regardless of any previous bounce or complaints suppression set at the account level. To do so, you can use the following command:
```
aws sesv2 put-configuration-set-suppression-options --configuration-set-name SmallBusinessesConfigSet
```
This command creates a new suppression options override for the "SmallBusinessesConfigSet" configuration set. This means that regardless of what is set at the account level, email sends should always be attempted for customers in this segment.

### Override account level settings with configuration set-level suppression enabled
Now, let's say that for enterprise companies, you want to maintain a good relationship with them but still want to balance between getting maximum reachability with respecting their boundaries. Therefore, you still want to attempt to send emails to addresses that have bounced, but not for those that have explicitly filed a complaint. You can do so by overriding the account level settings with granular configuration-set suppression options. To do so, enter the following command into your terminal:
```
aws sesv2 put-configuration-set-suppression-options --configuration-set-name EnterpriseCompaniesConfigSet --suppressed-reasons COMPLAINT
```
This command creates a new suppression options override for the "EnterpriseCompaniesConfigSet" configuration set, specifying that only complaints should be suppressed.

### Test it out
First, refer to [Lab 5.1](../5.1-account-level-suppression-list) on how to see which email addresses you have already added to the account-level suppression list.

Then, using send-email command described in [Lab 3.4](../../3-SendEmail/3.4-testmail-aws-cli/), try to send emails to the addresses inside your account-level suppression list the **using the following configuration sets**. The expected results are listed in the table below:

| Suppression Level | Configuration Set	 | Expected Results |
| ----------- | ----------- | ----------- |
| No overrides (default) | TechNewsConfigSet | Emails sent to addresses with both BOUNCE and COMPLAINT as reasons will be blocked. |
| Override account level settings | SmallBusinessesConfigSet | All emails will go through regardless of whether they are in the account-level suppression list or not. |
| Override account level settings with configuration set-level suppression enabled | EnterpriseCompaniesConfigSet | Only emails sent to addresses with COMPLAINT as reasons will be blocked. |

By using the [configuration set-level suppression](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/configure-suppressionlist-management.html), AWSomeNewsletter can manage email sending for specific configuration sets, providing them with more control over the suppression of email addresses for specific types of emails or campaigns. This helps the company to maintain a good [sender reputation](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/send-quality.html) while ensuring they don't accidentally send unwanted emails to their subscribers.