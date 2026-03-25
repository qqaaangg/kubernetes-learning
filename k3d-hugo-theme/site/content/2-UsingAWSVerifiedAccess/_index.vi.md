---
title : "Email Và Domain Identities"
date : "`r Sys.Date()`"
weight : 2
chapter : false
pre : " <b> 2. </b> "
---

### Tạo và xác thực identity
Qua bài lab này, chúng ta sẽ khám phá quá trình tạo và xác thực email identity cũng như tên miền sử dụng Amazon Simple Email Service (SES). Quản lý identity của email và tên miền 1 cách đúng đắn là cần thiết để gia tăng danh tiếng của người gửi và cải thiện khả năng gửi mail.

#### Kịch bản
Công ty AWSomeNewsletter đang gửi các bản tin thường xuyên thông qua email. Để cải thiện danh tiếng và đảm bảo khả năng gửi mail, bạn quyết định thiết lập 1 domain identity và xác thực thông qua SES. Bạn cũng sẽ cần xác thực email identity để dùng như địa chỉ email của người gửi bản tin của bạn. 

#### Email Identity và Domain Identity

{{< tabs groupId="email-domain-identity" >}}
{{% tab name="Email Identity" %}}

1 email identity đại diện cho 1 địa chỉ email cụ thể. Khi bạn xác thực email identity, bạn có thể sử dụng luôn cho địa chỉ người gửi cho các email. Tuy nhiên, Việc xác thực này chỉ áp dục cho chính xác những email bạn xác thực. Truy cập [tài liệu email identity](https://docs.aws.amazon.com/ses/latest/dg/creating-identities.html#verify-email-addresses-procedure) để biết thêm chi tiết.

{{% /tab %}}
{{% tab name="Domain Identity" %}}

1 domain identity đại diện cho 1 domain cụ thể. Khi bạn xác thực 1 domain identity, bạn có thể sử dụng bất kì địa chỉ email nào thông qua domain đó như địa chỉ người gửi cho email của bạn. Ngoài ra, bạn có thể thiết lập các phương thức xác thực email như DKIM và SPF cho tên miền, cải thiện danh tiếng email của bạn và khả năng chuyển phát. Truy cập [tài liệu domain identity](https://docs.aws.amazon.com/ses/latest/dg/creating-identities.html#verify-domain-procedure) để biết thêm chi tiết.

{{% /tab %}}
{{< /tabs >}}

Về thông báo/tin tức về công ty, chúng tôi đề xuất sử dụng domain entity bởi nó giúp bạn sử dụng bất kì email nào trên domain đó như địa chỉ người gửi và giúp thiết lập các phương thức bảo mật.
 
### Tổng kết

Bài lab này sẽ hướng dẫn bạn qua các bước cấu hình email và domain entities cũng như giao quyền truy cập thông qua DKIM (DomainKeys Identified Mail). Bài lab này chia ra 2 phần:
1. **Tạo và xác thực email và domain entitty**: chúng ta sẽ cùng thảo luận về điểm khác nhau giữa [email và domain identities](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-addresses-and-domains.html), và lợi ích sử dụng domain entity giành cho bản tin của doanh nghiệp.
2. **Domain entity - xác thực thực thể**: chúng ta sẽ lướt qua các bước thiết lập domain entity và đạt được thông tin xác thực bắt buộc giành cho [DNS](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-domains.html) của bạn.

### Nội dung

1. [Email Identities](2.1-email-identity)
2. [Domain Identities](2.2-domain-identity)
