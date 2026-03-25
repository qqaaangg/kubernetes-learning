---
title : "Configuration sets"
date : "`r Sys.Date()`"
weight : 1
chapter : false
pre : " <b> 4.1 </b> "
---

## Creating configuration sets

A [configuration set](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/using-configuration-sets-in-email.html) is a group of rules that you can apply to emails you send using Amazon SES. These rules help you to organize your email sending events for tracking purposes.
![Configuration sets](/hugo-ses/images/4/1/0001.png?featherlight=false&width=70pc)
Configuration sets are a powerful tool for managing email sending operations on a per-business-unit basis. By creating a separate configuration set for each customer segment, you can manage reputation, events, and bounce handling settings specific to that segment. This granular approach allows for better control over the email sending process and can help ensure that emails are being delivered to the right recipients at the right time.

For other businesses, configuration sets can be used in a similar fashion to manage email sending operations across different departments or product lines. By creating separate configuration sets for each department or product line, businesses can manage email reputation, events, and bounce handling settings specific to each segment. This approach can also help businesses maintain brand consistency across different segments and ensure that emails are being delivered to the right recipients at the right time.

### Creating Multiple Configuration Sets for Each Product Lines

{{< tabs groupId="conf-set-for-prd-line" >}}
{{% tab name="Tech News Topic" %}}
Use the following command to create a configuration set for the TechNews topic:
```
aws sesv2 create-configuration-set --configuration-set-name TechNewsConfigSet
```
{{% /tab %}}
{{% tab name="Health & Wellness Topic" %}}
Use the following command to create a configuration set for the HealthWellness topic:
```
aws sesv2 create-configuration-set --configuration-set-name HealthWellnessConfigSet
```
{{% /tab %}}
{{% tab name="Travel Tips Topic" %}}
Use the following command to create a configuration set for the TravelTips topic:
```
aws sesv2 create-configuration-set --configuration-set-name TravelTipsConfigSet
```
{{% /tab %}}
{{% tab name="Personal Finance Topic" %}}
Use the following command to create a configuration set for the PersonalFinance topic:
```
aws sesv2 create-configuration-set --configuration-set-name PersonalFinanceConfigSet
```
{{% /tab %}}
{{< /tabs >}}

### Creating Multiple Configuration Sets for Each Customer Segments
{{< tabs groupId="conf-set-for-customer-segment" >}}
{{% tab name="Small Businesses" %}}
Use the following command to create a configuration set for the Small Businesses customer segment:
```
aws sesv2 create-configuration-set --configuration-set-name SmallBusinessesConfigSet
```
{{% /tab %}}
{{% tab name="Enterprise Companies" %}}
Use the following command to create a configuration set for the Enterprise Companies customer segment:
```
aws sesv2 create-configuration-set --configuration-set-name EnterpriseCompaniesConfigSet
```
{{% /tab %}}
{{% tab name="Non-profit Organizations" %}}
Use the following command to create a configuration set for the Non-profit Organizations customer segment:
```
aws sesv2 create-configuration-set --configuration-set-name NonprofitOrgsConfigSet
```
{{% /tab %}}
{{% tab name="E-commerce Sites" %}}
Use the following command to create a configuration set for the E-commerce Sites customer segment:
```
aws sesv2 create-configuration-set --configuration-set-name EcommerceSitesConfigSet
```
{{% /tab %}}
{{< /tabs >}}

Congratulations! With configuration sets you can slice and dice logical parts of your business' email sending needs for reporting and management purposes. In the next lab, we will see how you can manage reporting for a specific configuration set.
