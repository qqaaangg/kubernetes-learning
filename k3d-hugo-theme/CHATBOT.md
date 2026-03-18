# 1) Kiến trúc mình đề xuất cho lab này

k3d khuyến nghị expose dịch vụ local qua **Ingress** và map host port tới `@loadbalancer`; ví dụ chuẩn của docs là `-p "8081:80@loadbalancer"`. Đồng thời, k3s đi kèm **Traefik** mặc định như ingress controller, nên với use case local dev bạn có thể dùng luôn Traefik built-in thay vì cài thêm NGINX Ingress hoặc Traefik Helm riêng. [\[us-prod.as...rosoft.com\]](https://us-prod.asyncgw.teams.microsoft.com/v1/objects/0-ea-d6-125aceb428c70e638c18c94f004817a8/views/original/hugo-k3d-lab.zip), [\[k3d.io\]](https://k3d.io/v5.3.0/usage/exposing_services/)

Trong k3s, Traefik được deploy mặc định và có `LoadBalancer Service` dùng các cổng **80/443**; ServiceLB của k3s sẽ dùng host ports khả dụng để expose các cổng đó. Điều này rất hợp với mô hình k3d local khi bạn map `80:80@loadbalancer` để truy cập app qua Ingress từ máy local. [\[k3d.io\]](https://k3d.io/v5.3.0/usage/exposing_services/), [\[us-prod.as...rosoft.com\]](https://us-prod.asyncgw.teams.microsoft.com/v1/objects/0-ea-d6-125aceb428c70e638c18c94f004817a8/views/original/hugo-k3d-lab.zip)

Monitoring mình chọn `kube-prometheus-stack` vì chart này đóng gói sẵn **Prometheus Operator, Prometheus, Grafana, kube-state-metrics, node-exporter** và các dashboard/rule liên quan, rất phù hợp cho lab Kubernetes đầy đủ. Chart cũng hỗ trợ `ServiceMonitor`, là cách chuẩn để scrape app metrics trong hệ Prometheus Operator. [\[docs.k3s.io\]](https://docs.k3s.io/networking/networking-services)

***

# 2) Trong file zip có gì?

Bộ zip mình tạo sẵn chứa toàn bộ scaffold để bạn chạy, ngoại trừ **source Hugo theme/site thực tế** của bạn. Cấu trúc chính như sau: repo có `Dockerfile` build Hugo → Nginx, thư mục `chart/hugo-site` là Helm chart app, `deploy/monitoring` là values cho kube-prometheus-stack, và `scripts/` là các script create cluster / build image / deploy app / deploy monitoring. 

Ngoài ra mình cũng để một `site/` skeleton tối thiểu để bạn có thể:

*   **copy full Hugo site** vào `site/`, hoặc
*   chỉ bỏ **theme** vào `site/themes/<ten-theme>` rồi chỉnh `site/config.toml` cho đúng tên theme. 

***

# 3) Cách chạy end-to-end

## Bước 0 — Chuẩn bị Hugo source

Giải nén repo, sau đó:

### Trường hợp A: bạn có full Hugo site

Copy toàn bộ source Hugo của bạn vào thư mục `site/` trong repo. Repo đã mô tả rõ expected layout cho `site/`, gồm `config.toml`, `content/`, `static/`, `themes/`… 

### Trường hợp B: bạn chỉ có theme source

*   đặt theme vào `site/themes/<ten-theme>`
*   sửa `site/config.toml`
*   đổi dòng:

```toml
theme = 'replace-with-your-theme-name'
```

thành tên theme thật của bạn. Skeleton `config.toml` và `content/_index.md` đã được tạo sẵn trong zip để bạn thay nhanh. 

***

## Bước 1 — Tạo cụm k3d

k3d docs hướng dẫn expose local qua ingress bằng cách map host port tới `@loadbalancer`, và đây cũng chính là cách script của mình đang dùng.  [\[us-prod.as...rosoft.com\]](https://us-prod.asyncgw.teams.microsoft.com/v1/objects/0-ea-d6-125aceb428c70e638c18c94f004817a8/views/original/hugo-k3d-lab.zip)

Chạy:

```bash
cd hugo-k3d-lab
chmod +x scripts/*.sh
./scripts/create-cluster.sh
```

Script này tạo cụm:

*   `1 server`
*   `2 agents`
*   API port `6550`
*   map:
    *   `80:80@loadbalancer`
    *   `443:443@loadbalancer`  [\[us-prod.as...rosoft.com\]](https://us-prod.asyncgw.teams.microsoft.com/v1/objects/0-ea-d6-125aceb428c70e638c18c94f004817a8/views/original/hugo-k3d-lab.zip)

Sau đó kiểm tra:

```bash
kubectl cluster-info
kubectl get nodes -o wide
kubectl get pods -A
```

***

## Bước 2 — Build image Hugo và import vào cluster

Repo dùng multi-stage Dockerfile:

*   stage 1: build static site bằng Hugo
*   stage 2: serve bằng `nginx:alpine`
*   Nginx listen port `8080`, đồng thời bật `stub_status` ở `8081` để exporter scrape metrics. 

Chạy:

```bash
./scripts/build-image.sh
```

Script sẽ:

1.  build image `hugo-site:0.1.0`
2.  import image vào cụm `local-lab` bằng `k3d image import` 

> **Lưu ý quan trọng:** nếu Hugo build lỗi, gần như chắc chắn là do:
>
> *   theme chưa copy vào đúng chỗ
> *   tên theme trong `config.toml` sai
> *   source Hugo của bạn chưa đầy đủ. Repo README đã ghi sẵn troubleshooting này. 

***

## Bước 3 — Deploy app bằng Helm

Helm chart `chart/hugo-site` đã được mình tạo sẵn với các tài nguyên:

*   `Deployment`
*   `Service`
*   `Ingress`
*   `ConfigMap` cho nginx config
*   `ServiceMonitor` để Prometheus scrape metrics app 

Chạy:

```bash
./scripts/install-app.sh
```

Chart đang cấu hình:

*   app image: `hugo-site:0.1.0`
*   service type: `ClusterIP`
*   ingress class: `traefik`
*   host mặc định: `hugo.localhost`
*   sidecar: `nginx/nginx-prometheus-exporter`
*   metrics port: `9113` 

Kiểm tra:

```bash
kubectl get pods -n web
kubectl get svc -n web
kubectl get ingress -n web
```

***

## Bước 4 — Deploy monitoring stack

Mình dùng `kube-prometheus-stack` vì chart này triển khai end-to-end stack monitoring cho Kubernetes, bao gồm Prometheus Operator, Prometheus, Grafana, kube-state-metrics và node-exporter. [\[docs.k3s.io\]](https://docs.k3s.io/networking/networking-services)

Chạy:

```bash
./scripts/install-monitoring.sh
```

Script sẽ:

*   add Helm repo `prometheus-community`
*   tạo namespace `monitoring`
*   `helm upgrade --install kube-prom-stack ...` với values local của repo  [\[docs.k3s.io\]](https://docs.k3s.io/networking/networking-services)

Mình đã set sẵn trong `deploy/monitoring/kube-prometheus-stack-values.yaml`:

*   **Grafana ingress** host: `grafana.localhost`
*   **Prometheus ingress** host: `prometheus.localhost`
*   Prometheus retention: `3d`
*   `serviceMonitorSelectorNilUsesHelmValues: false`
*   `serviceMonitorNamespaceSelector: {}`

Hai cấu hình selector này là để Prometheus có thể discover **custom ServiceMonitor** ngoài scope values mặc định của release, đúng theo pattern chart docs mô tả cho các ServiceMonitor/PodMonitor custom.  [\[docs.k3s.io\]](https://docs.k3s.io/networking/networking-services)

Kiểm tra:

```bash
kubectl get pods -n monitoring
kubectl get ingress -n monitoring
kubectl get servicemonitors -A
```

***

# 4) Truy cập app và dashboard

Sau khi xong, bạn truy cập:

*   `http://hugo.localhost`
*   `http://grafana.localhost`
*   `http://prometheus.localhost` 

Grafana mặc định:

*   username: `admin`
*   password: `admin123456` 

Nếu `.localhost` trên máy bạn không resolve ổn (tùy Windows/WSL/browser), thêm vào hosts:

```text
127.0.0.1 hugo.localhost grafana.localhost prometheus.localhost
```

Đây là practical tip cho local lab; repo README cũng có sẵn phần hướng dẫn này. 

***

# 5) Monitoring app Hugo của bạn hoạt động như thế nào?

App là static site, nên bản thân Hugo không có metrics runtime. Vì vậy mình dùng cách hợp lý nhất cho stack local:

*   serve site bằng **Nginx**
*   bật `stub_status`
*   chạy **`nginx-prometheus-exporter`** sidecar
*   expose cổng `metrics`
*   Prometheus scrape thông qua **ServiceMonitor** của Helm chart app 

Sau khi Prometheus lên, bạn có thể query thử:

```promql
nginx_connections_active
```

hoặc

```promql
rate(nginx_http_requests_total[5m])
```

Repo README cũng ghi sẵn gợi ý này. 

***

# 6) Tại sao mình **không** cài Traefik riêng bằng Helm?

Vì với k3s/k3d, **Traefik đã được đóng gói sẵn** và chạy mặc định. Docs của k3s còn lưu ý rằng muốn thay bằng ingress controller khác thì bạn nên disable Traefik ngay từ lúc khởi tạo server (`--disable=traefik`). Nếu không có nhu cầu đặc biệt, dùng built-in Traefik là ít rủi ro nhất cho lab local. [\[k3d.io\]](https://k3d.io/v5.3.0/usage/exposing_services/)

Với k3d, docs cũng khuyến nghị cách expose service “via Ingress (recommended)” bằng cách map port host sang `@loadbalancer`; do đó mô hình hiện tại là khá “đúng bài” cho local dev. [\[us-prod.as...rosoft.com\]](https://us-prod.asyncgw.teams.microsoft.com/v1/objects/0-ea-d6-125aceb428c70e638c18c94f004817a8/views/original/hugo-k3d-lab.zip)

***

# 7) Một số lệnh debug hữu ích

### Kiểm tra Traefik / ingress

```bash
kubectl get ingress -A
kubectl get svc -n kube-system
kubectl logs -n kube-system deploy/traefik
```

K3s docs xác nhận Traefik là ingress controller mặc định và dùng `LoadBalancer Service` ở 80/443, nên khi ingress có vấn đề đây là nơi debug đầu tiên. [\[k3d.io\]](https://k3d.io/v5.3.0/usage/exposing_services/)

### Kiểm tra app

```bash
kubectl describe pod -n web -l app.kubernetes.io/instance=hugo-site
kubectl logs -n web deploy/hugo-site -c web
kubectl logs -n web deploy/hugo-site -c nginx-prometheus-exporter
```

### Kiểm tra ServiceMonitor

```bash
kubectl get servicemonitor -n web
kubectl describe servicemonitor -n web hugo-site
```

Prometheus Operator chart dùng ServiceMonitor/PodMonitor thay cho annotation-based discovery; đây là cách chuẩn để kiểm tra app có đang được scrape hay chưa.  [\[docs.k3s.io\]](https://docs.k3s.io/networking/networking-services)

***

# 8) CI/CD – một vài ý tưởng thực tế cho lab này

Bạn nói rõ là **chỉ cần ý tưởng CI/CD**, không cần source, nên mình đề xuất 4 hướng sau:

## Ý tưởng 1 — GitHub Actions + GHCR + Helm upgrade

Luồng:

1.  push code Hugo/site
2.  GitHub Actions build image
3.  push lên **GHCR**
4.  bump tag trong Helm values
5.  deploy bằng `helm upgrade --install`

Phù hợp nếu sau này bạn chuyển từ local-only sang shared dev environment.

***

## Ý tưởng 2 — GitOps với Argo CD

Luồng:

1.  repo A: source app / image build
2.  repo B: Helm values / environment config
3.  Argo CD trong cluster theo dõi repo B và tự sync

Rất hợp nếu bạn muốn:

*   có history deploy
*   rollback dễ
*   tách source code và infra config

***

## Ý tưởng 3 — Self-hosted runner trỏ vào local k3d

Nếu đây là lab cá nhân:

*   đặt **self-hosted GitHub Actions runner** trong WSL2 hoặc một máy nội bộ
*   runner có quyền truy cập Docker + kubeconfig local
*   pipeline build image, `k3d image import`, rồi `helm upgrade`

Cách này cực tiện cho “CI/CD local thật”, nhưng chỉ phù hợp lab/private network.

***

## Ý tưởng 4 — Dev inner loop bằng Skaffold/Tilt

Nếu mục tiêu là phát triển nhanh:

*   file change → build image → sync/deploy → xem log ngay
*   Helm chart vẫn giữ làm deployment spec

Đây không hẳn là CI/CD full, nhưng cực tốt cho “developer workflow” khi bạn sửa Hugo/site nhiều lần.

***

# 9) Recommendation cuối cùng của mình

Nếu bạn muốn lab này **vừa dễ chạy vừa có giá trị học tốt**, mình khuyên dùng đúng flow sau:

```bash
# 1) giải nén repo
unzip hugo-k3d-lab.zip
cd hugo-k3d-lab

# 2) copy source Hugo/theme của bạn vào site/
# rồi chỉnh site/config.toml

# 3) tạo cluster
chmod +x scripts/*.sh
./scripts/create-cluster.sh

# 4) build image
./scripts/build-image.sh

# 5) deploy app
./scripts/install-app.sh

# 6) deploy monitoring
./scripts/install-monitoring.sh
```

Toàn bộ skeleton / source cho flow này mình đã gói trong file zip ở trên. 

***