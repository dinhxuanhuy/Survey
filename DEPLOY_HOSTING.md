# 🚀 HƯỚNG DẪN DEPLOY LÊN HOSTING

**Project**: EmailListWebApp - Survey Application  
**Tech Stack**: Java 17, Maven, Tomcat 9, Docker  
**Hosting Platforms**: Render, Railway, Fly.io, Google Cloud Run, AWS, Azure, etc.

---

## ✅ DOCKERFILE ĐÃ ĐƯỢC TỐI ƯU HÓA

Dockerfile hiện tại:
- ✅ Multi-stage build (giảm kích thước image)
- ✅ Copy đầy đủ `src/` và `web/` directories
- ✅ Build WAR với Maven
- ✅ Deploy trên Tomcat 9 (tương thích `javax.servlet`)
- ✅ Non-root user (bảo mật)
- ✅ Healthcheck endpoint
- ✅ Deploy as ROOT application (truy cập tại `/`)

---

## 🐳 BUILD VÀ TEST DOCKER IMAGE LOCAL

### Bước 1: Build Docker Image

```bash
cd C:\Users\dinhx\Downloads\survey-master\survey-master

# Build image
docker build -t emaillistwebapp:latest .
```

### Bước 2: Run Container Local

```bash
# Run container
docker run -d -p 8080:8080 --name survey-app emaillistwebapp:latest

# Xem logs
docker logs -f survey-app

# Test application
curl http://localhost:8080/
```

### Bước 3: Stop và Remove (nếu cần)

```bash
docker stop survey-app
docker rm survey-app
```

---

## ☁️ DEPLOY LÊN CÁC HOSTING PLATFORMS

### 1️⃣ RENDER (Khuyến nghị - Miễn phí)

**Bước 1**: Đẩy code lên GitHub
```bash
cd C:\Users\dinhx\Downloads\survey-master\survey-master
git init
git add .
git commit -m "Initial commit - Survey Application"
git branch -M main
git remote add origin https://github.com/your-username/survey-app.git
git push -u origin main
```

**Bước 2**: Deploy trên Render
1. Truy cập https://render.com
2. Click **New** → **Web Service**
3. Connect GitHub repository của bạn
4. Cấu hình:
   - **Name**: `survey-app`
   - **Environment**: `Docker`
   - **Region**: Chọn gần nhất
   - **Branch**: `main`
   - **Dockerfile Path**: `Dockerfile` (mặc định)
   - **Port**: `8080`
5. Click **Create Web Service**
6. Đợi build và deploy (3-5 phút)
7. Truy cập URL: `https://survey-app.onrender.com`

**Lưu ý Render**:
- Free tier: Container sleep sau 15 phút không hoạt động
- Cold start: Mất 30-60s để wake up

---

### 2️⃣ RAILWAY (Dễ dùng nhất)

**Bước 1**: Deploy
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Initialize project
cd C:\Users\dinhx\Downloads\survey-master\survey-master
railway init

# Deploy
railway up
```

**Bước 2**: Cấu hình
1. Truy cập https://railway.app
2. Vào project của bạn
3. Settings → Environment → Add Variable:
   - `PORT`: `8080`
4. Deploy lại nếu cần

URL: `https://your-app.railway.app`

---

### 3️⃣ FLY.IO (Scalable)

**Bước 1**: Install Fly CLI
```bash
# Windows (PowerShell)
iwr https://fly.io/install.ps1 -useb | iex
```

**Bước 2**: Deploy
```bash
cd C:\Users\dinhx\Downloads\survey-master\survey-master

# Login
fly auth login

# Launch app (tạo fly.toml)
fly launch

# Chọn:
# - App name: survey-app
# - Region: Singapore (sin)
# - Would you like to set up a PostgreSQL database? NO
# - Would you like to deploy now? YES

# Deploy (lần sau)
fly deploy
```

**Bước 3**: Xem logs và status
```bash
fly logs
fly status
fly open
```

URL: `https://survey-app.fly.dev`

---

### 4️⃣ GOOGLE CLOUD RUN

**Bước 1**: Setup Google Cloud
```bash
# Install gcloud CLI
# https://cloud.google.com/sdk/docs/install

# Login
gcloud auth login

# Set project
gcloud config set project YOUR_PROJECT_ID
```

**Bước 2**: Build và Push Image
```bash
cd C:\Users\dinhx\Downloads\survey-master\survey-master

# Tag image
docker tag emaillistwebapp:latest gcr.io/YOUR_PROJECT_ID/survey-app:latest

# Configure Docker for GCR
gcloud auth configure-docker

# Push image
docker push gcr.io/YOUR_PROJECT_ID/survey-app:latest
```

**Bước 3**: Deploy to Cloud Run
```bash
gcloud run deploy survey-app \
  --image gcr.io/YOUR_PROJECT_ID/survey-app:latest \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 8080
```

URL: `https://survey-app-xxx.run.app`

---

### 5️⃣ HEROKU (Cần credit card)

**Bước 1**: Install Heroku CLI
```bash
# https://devcenter.heroku.com/articles/heroku-cli
heroku login
```

**Bước 2**: Deploy
```bash
cd C:\Users\dinhx\Downloads\survey-master\survey-master

# Create app
heroku create survey-app

# Set stack to container
heroku stack:set container

# Deploy
git push heroku main

# Open app
heroku open
```

URL: `https://survey-app.herokuapp.com`

---

### 6️⃣ DOCKER HUB + VPS (DigitalOcean, Linode, etc.)

**Bước 1**: Push to Docker Hub
```bash
# Login Docker Hub
docker login

# Tag image
docker tag emaillistwebapp:latest your-username/survey-app:latest

# Push
docker push your-username/survey-app:latest
```

**Bước 2**: Deploy trên VPS
```bash
# SSH vào VPS
ssh root@your-vps-ip

# Install Docker (nếu chưa có)
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Pull và run
docker pull your-username/survey-app:latest
docker run -d -p 80:8080 --name survey-app your-username/survey-app:latest

# Setup reverse proxy với Nginx (optional)
# Hoặc expose port 80 trực tiếp
```

URL: `http://your-vps-ip`

---

## 🔧 CẤU HÌNH ENVIRONMENT VARIABLES (Nếu cần)

Nếu sau này cần kết nối database hoặc cấu hình khác:

```dockerfile
# Thêm vào Dockerfile (trước CMD)
ENV DB_HOST=localhost
ENV DB_PORT=3306
ENV DB_NAME=survey_db
ENV DB_USER=root
ENV DB_PASSWORD=password
```

Hoặc set trong platform:
- **Render**: Environment → Add Variable
- **Railway**: Variables tab
- **Fly.io**: `fly secrets set KEY=VALUE`
- **Cloud Run**: `--set-env-vars KEY=VALUE`

---

## 📊 SO SÁNH CÁC HOSTING PLATFORMS

| Platform | Free Tier | Ease | Cold Start | Custom Domain | SSL |
|----------|-----------|------|------------|---------------|-----|
| **Render** | ✅ 750h/month | ⭐⭐⭐⭐⭐ | ~30s | ✅ | ✅ |
| **Railway** | ✅ $5 credit | ⭐⭐⭐⭐⭐ | ~10s | ✅ | ✅ |
| **Fly.io** | ✅ 3 VMs | ⭐⭐⭐⭐ | ~5s | ✅ | ✅ |
| **Cloud Run** | ✅ 2M requests | ⭐⭐⭐ | ~3s | ✅ | ✅ |
| **Heroku** | ❌ (paid) | ⭐⭐⭐⭐ | ~10s | ✅ | ✅ |
| **VPS** | ❌ ($5+/mo) | ⭐⭐ | None | ✅ | Manual |

**Khuyến nghị cho beginners**: **Render** hoặc **Railway**

---

## 🔍 TROUBLESHOOTING

### Lỗi: "Address already in use"
```bash
# Kiểm tra port 8080
netstat -ano | findstr :8080

# Kill process
taskkill /PID <PID> /F
```

### Lỗi: "Cannot resolve symbol 'servlet'"
- Đảm bảo đã reload Maven dependencies
- Kiểm tra `javax.servlet-api` trong pom.xml

### Lỗi: Container crash sau deploy
```bash
# Xem logs
docker logs <container-id>

# Hoặc trên platform
fly logs
railway logs
```

### Lỗi: Port binding
Một số platform yêu cầu bind port từ env variable:
```dockerfile
# Thêm vào Dockerfile (nếu cần)
ENV PORT=8080
```

---

## 📝 CHECKLIST TRƯỚC KHI DEPLOY

- [x] Dockerfile đã được sửa (xóa dòng COPY thừa)
- [x] Code dùng `javax.servlet` (tương thích Tomcat 9)
- [x] WAR file build thành công local
- [x] Test Docker image local (`docker run`)
- [x] .dockerignore đã loại trừ file không cần thiết
- [ ] Code đã push lên Git repository
- [ ] Chọn hosting platform
- [ ] Deploy và test URL công khai

---

## 🎯 SAU KHI DEPLOY THÀNH CÔNG

1. **Test application**:
   ```bash
   curl https://your-app-url.com/
   ```

2. **Xem logs** để debug nếu có lỗi

3. **Setup custom domain** (optional):
   - Mua domain từ Namecheap, GoDaddy, etc.
   - Add CNAME record trỏ đến URL của hosting
   - Cấu hình SSL (thường tự động)

4. **Monitor performance**:
   - Response time
   - Memory usage
   - Error rate

---

## 💡 TIPS

1. **Tối ưu Docker image**:
   - Dùng Alpine Linux base images (nhỏ hơn)
   - Multi-stage build (đã làm)
   - .dockerignore đầy đủ

2. **Bảo mật**:
   - Non-root user (đã làm)
   - Environment variables cho sensitive data
   - HTTPS only

3. **Performance**:
   - Enable caching
   - Compress responses
   - CDN cho static assets

---

## 📞 HỖ TRỢ

- **Render Docs**: https://render.com/docs
- **Railway Docs**: https://docs.railway.app
- **Fly.io Docs**: https://fly.io/docs
- **Docker Docs**: https://docs.docker.com

---

**Chúc mừng! Ứng dụng của bạn đã sẵn sàng deploy! 🎉**

