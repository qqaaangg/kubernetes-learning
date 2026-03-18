# Hugo on k3d (k3s) lab

Repo này cung cấp bộ source tối thiểu để bạn deploy một Hugo site lên cụm **k3d/k3s local** với các thành phần:

- **k3d** cluster: 1 server + 2 agent, expose LB ra **port 80 local**
- **Traefik Ingress** (sử dụng Traefik mặc định của k3s/k3d)
- **Helm chart** để quản lý app Hugo
- **Prometheus + Grafana** (kube-prometheus-stack)
- **ServiceMonitor** để scrape metric từ `nginx-prometheus-exporter`

> Lưu ý quan trọng: repo này **không** chứa source Hugo theme/site của bạn. Bạn cần đặt source Hugo của mình vào thư mục `site/` theo hướng dẫn ở dưới.

---

## 1) Yêu cầu

Trên WSL2 Ubuntu 22.04:

- Docker
- kubectl
- helm
- k3d

Gợi ý cài nhanh:

```bash
# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
```

---

## 2) Cấu trúc repo

```text
hugo-k3d-lab/
├── chart/
│   └── hugo-site/
├── deploy/
│   └── monitoring/
├── scripts/
├── site/
├── Dockerfile
├── .dockerignore
└── README.md
```

---

## 3) Chuẩn bị Hugo source của bạn

### Cách A — bạn đã có **full Hugo site source**
Copy toàn bộ site vào `site/`.

Ví dụ:

```text
site/
├── archetypes/
├── assets/
├── config.toml
├── content/
├── layouts/
├── static/
└── themes/
    └── your-theme/
```

### Cách B — bạn chỉ có **theme source**
Bạn cần tự tạo 1 Hugo site tối thiểu trong `site/`, sau đó đặt theme vào `site/themes/<ten-theme>` và sửa `site/config.toml` để trỏ đúng theme.

Repo này đã tạo sẵn một **site skeleton** tối thiểu để bạn thay thế / chỉnh sửa.

---

## 4) Tạo cluster k3d

```bash
chmod +x scripts/*.sh
./scripts/create-cluster.sh
kubectl cluster-info
kubectl get nodes -o wide
kubectl get pods -A
```

---

## 5) Build image Hugo site

Sửa file `site/config.toml` và đặt theme đúng tên.

Sau đó build image:

```bash
./scripts/build-image.sh
```

Script sẽ:
1. Build Docker image `hugo-site:0.1.0`
2. Import image vào cluster `local-lab`

---

## 6) Deploy app bằng Helm

```bash
./scripts/install-app.sh
```

Kiểm tra:

```bash
kubectl get pods -n web
kubectl get svc -n web
kubectl get ingress -n web
```

---

## 7) Deploy monitoring (Prometheus + Grafana)

```bash
./scripts/install-monitoring.sh
```

Kiểm tra:

```bash
kubectl get pods -n monitoring
kubectl get ingress -n monitoring
kubectl get servicemonitors -A
```

---

## 8) Truy cập ứng dụng

Repo dùng các host sau:

- `hugo.localhost`
- `grafana.localhost`
- `prometheus.localhost`

Mở thử:

- http://hugo.localhost
- http://grafana.localhost
- http://prometheus.localhost

### Nếu máy bạn không resolve được `*.localhost`
Thêm vào file hosts:

**Windows**: `C:\Windows\System32\drivers\etc\hosts`

**WSL/Linux**: `/etc/hosts`

```text
127.0.0.1 hugo.localhost grafana.localhost prometheus.localhost
```

---

## 9) Grafana đăng nhập

Mặc định trong values hiện tại:

- user: `admin`
- password: `admin123456`

> Chỉ phù hợp môi trường local/dev.

---

## 10) Monitoring app

App chart có thêm `nginx-prometheus-exporter` sidecar.

Prometheus sẽ scrape metrics thông qua `ServiceMonitor` tại service port `metrics`.

Bạn có thể vào Prometheus UI và query thử:

```promql
nginx_connections_active
```

hoặc:

```promql
rate(nginx_http_requests_total[5m])
```

> Tùy version exporter, một số metric name có thể khác nhau. Query `nginx_` để khám phá toàn bộ metrics.

---

## 11) Update app

Khi thay đổi source Hugo:

```bash
./scripts/build-image.sh
helm upgrade --install hugo-site ./chart/hugo-site -n web -f ./chart/hugo-site/values-local.yaml
```

---

## 12) Gỡ môi trường

```bash
./scripts/delete-cluster.sh
```

---

## 13) Troubleshooting nhanh

### Port 80 bị chiếm
Kiểm tra service đang dùng port 80 trên Windows/WSL. Nếu cần, tạm sửa `scripts/create-cluster.sh` sang `8080:80@loadbalancer`.

### Ingress không vào được

```bash
kubectl get ingress -A
kubectl get svc -n kube-system
kubectl logs -n kube-system deploy/traefik
```

### App pod crash vì Hugo build fail
Kiểm tra Docker build output:

```bash
docker build -t hugo-site:0.1.0 .
```

Thường do:
- thiếu theme
- `theme` trong `config.toml` sai tên
- Hugo site source chưa đầy đủ

### ServiceMonitor không scrape app
Kiểm tra:

```bash
kubectl get servicemonitor -n web
kubectl describe servicemonitor hugo-site -n web
kubectl get svc -n web hugo-site -o yaml
```

---

## 14) Ý tưởng mở rộng tiếp theo

- Argo CD để GitOps deploy Helm chart
- cert-manager + TLS local/dev
- Loki + Promtail để tập trung log
- Blackbox Exporter để monitor endpoint `http://hugo.localhost`
- HPA demo (nếu bạn đổi app sang dynamic workload có metrics phù hợp)
