---
title : "Giới thiệu"
date :  "`r Sys.Date()`" 
weight : 1 
chapter : false
pre : " <b> 1. </b> "
---

#### Giới thiệu Amazon SES

Thông qua workshop này, bạn sẽ biết cách quản lý email gửi, người đăng kí và khả năng chuyển đổi 1 cách hiệu quả cho doanh nghiệp của bạn sử dụng SES. Sau cùng, bạn sẽ hiểu toàn diện về các phương pháp quản lý email tốt nhất.

#### Đối tượng

Workshop này được thiết kế dành cho các lập trình viên, quản trị viên của ban ngành IT, những người muốn học cách thiết lập, quản lý và tối ưu môi trường gửi email trên Amazon Simple Email Service.

#### Đầu ra hướng tới

Sau khi hoàn thành workshop này, bạn sẽ có được kiến thức chuyên sâu và kinh nghiệm thực tế trong việc sử dụng Amazon SES. Hiểu được cách thiết lập và cấu hình môi trường Amazon SES, quản lý danh sách liên lạc và những người đăng kí, cũng như làm việc hiệu quả với các mẫu emails. Hơn nữa, bạn sẽ trở nên thành thạo trong việc cải thiện tỷ lệ gửi email và nâng cao danh tiếng của email người gửi. Bạn cũng sẽ được trang bị tốt các kiến thức để áp dụng các khái niệm quản lý email này và các phương pháp thực hành tốt nhất vào các trường hợp thực tế, chắc chắn rằng cơ sở hạ tầng email của tổ chức bạn hoạt động tối ưu.

#### Thời lượng

Workshop này cần từ 6 đến 7 giờ để hoàn thành

#### Các điều kiện tiên quyết

Bạn đã có kiến thức cơ bản về các dịch vụ của AWS và các thuật ngữ liên quan. Kinh nghiệm sử dụng aws cli, kiến thức về giao thức SMTP cùng với các giao thức liên quan đến email. Ngoài ra, bạn nên làm quen với những điều cơ bản về việc quản lý email, bao gồm các khái niệm như danh sách chặt và độ uy tín của người gửi, sẽ là lợi thế. Mặc dù workshop được thiết kế chi tiết và thân thiện với người mới bắt đầu, có các hữu các kiến thức trên sẽ giúp bạn đạt được tối đa kinh nghiệm.

#### Chi phí liên quan

Mặc dù workshop không bị tính phí, xin hãy ghi nhớ rằng làm lab có thể gây chi phí vào tài khoản AWS khi bạn sử dụng các loại tài nguyên khác nhau của AWS. Amazon SES, cũng như các dịch vụ của AWS khácm tính phí dựa trên mô hình định giá trả theo mức sử dụng, vì vậy bạn chỉ phải trả cho những gì bạn dùng. Để tiết kiệm chi phí, đảm bảo rằng bạn dọn dẹp hết tài nguyên sau khi được thử nghiệm hoặc khi chúng không còn được sử dụng nữa. Hãy tham khảo trang giá của AWS chính thức dành cho Amazon SES để hiểu rõ ràng hơn về chi phí tiềm ẩn. Luôn lưu ý đến việc sử dụng và nhớ rằng bạn chịu trách nhiệm về mọi khoản phí phát sinh trong tài khoản AWS của mình trong workshop này

Hầu hết dịch vụ của Amazon được sử dụng trong workshop này thì đều thuộc bậc Miến Phí (luôn luôn miễn phí, miễn phí 12 tháng đầu, hoặc miễn phí dùng thử). Bạn có thể xem thêm thông tin chi tiết trên trang bậc miễn phí của AWS dánh cho mỗi dịch vụ. 1 vài dịch vụ mất phí:

- Kinesis Data Streams
- Kinesis Data Firehose

Chi tiết về cách tính giá cho dịch vụ Athena, Kinesis Data Streams và Kinesis Data Firehose [nằm ở đây](https://calculator.aws/#/estimate?id=2023cba18cb2dc3517ca2159bb744abde87c1546). Bạn có thể sử dụng nó làm tài liệu tham khảo và điều chỉnh theo nhu cầu của mình (ví dụ: khu vực hoặc cách sử dụng khác).

Nếu tài khoản của bạn không thuộc bậc miễn phí, hoặc muốn ước tính chi phí của bản thiết kế giải pháp, điều mà bạn sẽ thực hiện với những dịch vụ sau khi hoàn thành wokshop này, bạn có thể sử dụng [trang tính giá của AWS](https://calculator.aws/#/) và các trang giá cả cho từng dịch vụ.

#### Kịch bản trong wokshop

Công ty AWSomeNewsletter đang phát triển rất nhanh chón, cũng như thực hiện gửi rất nhiều mail tin tức tới những người đăng kí của họ. Họ cần 1 cách thức hiệu quả để quản lý danh sách gửi mail, theo dõi đăng ký người dùng, tạo và quản lý mẫu email, và đảm bảo tỷ lệ gửi cao và danh tiếng của mail gửi tốt

Trong workshop này, bạn sẽ khám phá nhiều tính năng và công cụ khác nhau của Amazon SES giúp công ty AWSomeNewsletter quản lý hạ tầng email của họ 1 cách hiệu quả.

#### Nội dung

- [Điều kiện tiên quyết](1.1-prerequisites/)
- [Lưu ý về SES và SESv2 API](1.2-ses-vs-sesv2/)
- [Sử dụng tên miền của workshop](1.3-ws-domain/)
- [Sử dụng tên miền của chính bạn](1.4-own-domain/)

Hãy sẵn sàng đi sâu vào thế giới quản lý email với Amazon SES và giúp AWSomeNewsletter đạt được các mục tiêu tiếp thị qua email của họ!
