---
title : "Email Identities"
date :  "`r Sys.Date()`" 
weight : 1
chapter : false
pre : " <b> 2.1 </b> "
---

### Email Identities

Bạn sẽ cần 1 email identity được xác thực để có thể gửi mail qua Amazon SES. Bây giờ bạn có thể xác thực địa chỉ email của bạn, địa chỉ mà sẽ đại diện cho "Từ {email}" cho bản tin của công ty.

![SES Console](/images/2/1/0001.png?featherlight=false&width=70pc)
![Create Identity](/images/2/1/0002.png?featherlight=false&width=70pc)

{{% notice note %}}
Nếu bạn đang gửi tới 1 địa chỉ email khác và bạn đang trong môi trường sandbox của SES, bạn cũng cần xác thực địa chỉ nhận bởi vì môi trường sandbox sẽ chỉ cho phép chuyển phát giữa những email được xác thực.
{{% /notice %}}

1. Mở terminal (hoặc command prompt - shell bash bạn cài AWS CLI và thiết lập các quyền IAM để truy cập SES)
2. Nhập lệnh sau để kiểm tra xem địa chỉ email đã được xác thực hay chưa:  

```
aws sesv2 create-email-identity --email-identity example@example.com
```

Thay thế `example@example.com` với địa chỉ email của bạn.

### Xác thực Email Identities
1. Bạn sẽ nhận được email xác thực như sau, click vào link để hoàn thành quá trình xác thực:
![Verification email](/images/2/1/0003.png?featherlight=false&width=70pc)

2. Để kiểm tra trạng thái, gõ lệnh sau:
```
aws sesv2 get-email-identity --email-identity example@example.com
```
Câu lệnh trên sẽ trả về 1 json object với trạng thái xác thực của email, tương tự như sau:

```
{
    "IdentityType": "EMAIL_ADDRESS",
    "FeedbackForwardingStatus": true,
    "VerifiedForSendingStatus": true,
    "DkimAttributes": {
        "SigningEnabled": false,
        "Status": "NOT_STARTED",
        "SigningAttributesOrigin": "AWS_SES",
        "NextSigningKeyLength": "RSA_1024_BIT"
    },
    "MailFromAttributes": {
        "BehaviorOnMxFailure": "USE_DEFAULT_VALUE"
    },
    "Policies": {},
    "Tags": [],
    "ConfigurationSetName": "my-first-configuration-set",
    "VerificationStatus": "SUCCESS",
    "VerificationInfo": {}
}
```