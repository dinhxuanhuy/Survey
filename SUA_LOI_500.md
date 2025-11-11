# 🔧 SỬA LỖI 500 - ClassNotFoundException: jakarta.servlet.http.HttpServlet

**Ngày**: 11/11/2025  
**Lỗi**: HTTP Status 500 – Internal Server Error  
**Root Cause**: `java.lang.ClassNotFoundException: jakarta.servlet.http.HttpServlet`

---

## 🔴 NGUYÊN NHÂN

Bạn đang dùng **Tomcat 9.0.111** nhưng code sử dụng **Jakarta EE** (package `jakarta.servlet.*`).

### Bảng tương thích:

| Tomcat Version | Servlet API | Package Name |
|----------------|-------------|--------------|
| Tomcat 9.x | Java EE 8 (Servlet 4.0) | `javax.servlet.*` |
| Tomcat 10.x+ | Jakarta EE 9+ (Servlet 5.0+) | `jakarta.servlet.*` |

**Kết luận**: Tomcat 9 không hỗ trợ `jakarta.servlet.*`, chỉ hỗ trợ `javax.servlet.*`

---

## ✅ ĐÃ SỬA

Tôi đã đổi code từ **Jakarta EE** về **Java EE** để tương thích với Tomcat 9:

### 1. **EmailListServlet.java** ✅
```java
// TỪ (Jakarta EE - không tương thích Tomcat 9)
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// SANG (Java EE - tương thích Tomcat 9)
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
```

### 2. **pom.xml** ✅
```xml
<!-- TỪ (Jakarta EE) -->
<dependency>
    <groupId>jakarta.servlet</groupId>
    <artifactId>jakarta.servlet-api</artifactId>
    <version>5.0.0</version>
    <scope>provided</scope>
</dependency>

<!-- SANG (Java EE) -->
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>4.0.1</version>
    <scope>provided</scope>
</dependency>
```

### 3. **web.xml** ✅
```xml
<!-- TỪ (Jakarta EE namespace) -->
<web-app version="6.0" 
         xmlns="https://jakarta.ee/xml/ns/jakartaee" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee 
         https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd">

<!-- SANG (Java EE namespace) -->
<web-app version="4.0" 
         xmlns="http://xmlns.jcp.org/xml/ns/javaee" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee 
         http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd">
```

---

## 🚀 CÁC BƯỚC THỰC HIỆN TRONG INTELLIJ

### Bước 1: Reload Maven Dependencies

1. Mở **Maven tool window** (View → Tool Windows → Maven)
2. Click vào icon **Reload All Maven Projects** (⟳)
3. Đợi IntelliJ download dependency `javax.servlet-api`

### Bước 2: Clean và Rebuild

1. Trong Maven tool window
2. Click **clean** (double-click)
3. Click **compile** (double-click)
4. Click **package** (double-click)

### Bước 3: Copy files vào WAR exploded

Mở terminal trong IntelliJ hoặc PowerShell và chạy:

```powershell
cd C:\Users\dinhx\Downloads\survey-master\survey-master

# Copy web.xml
copy web\WEB-INF\web.xml target\EmailListWebApp\WEB-INF\web.xml

# Copy static files
copy web\index.html target\EmailListWebApp\index.html
copy web\thanks.jsp target\EmailListWebApp\thanks.jsp
xcopy web\styles target\EmailListWebApp\styles\ /E /I /Y
xcopy web\image target\EmailListWebApp\image\ /E /I /Y
xcopy web\META-INF target\EmailListWebApp\META-INF\ /E /I /Y
```

### Bước 4: Clean Tomcat cache và Restart

1. **Stop Tomcat** (Shift + F5)
2. Xóa Tomcat cache:
   - Vào `C:\Users\dinhx\.IntelliJIdea20XX\system\tomcat\`
   - Xóa thư mục có tên project của bạn
3. **Start Tomcat** (Shift + F10)

### Bước 5: Truy cập ứng dụng

```
http://localhost:8080/EmailListWebApp/
```

---

## 🔍 KIỂM TRA SAU KHI SỬA

### Kiểm tra dependency đã đúng:
```powershell
# Kiểm tra pom.xml có javax.servlet chưa
type pom.xml | findstr javax.servlet
```

### Kiểm tra import đã đúng:
```powershell
# Kiểm tra servlet có dùng javax chưa
type src\java\murach\email\EmailListServlet.java | findstr "import.*servlet"
```

### Kiểm tra class files đã compile:
```powershell
dir target\EmailListWebApp\WEB-INF\classes\murach\email\EmailListServlet.class
```

### Kiểm tra WAR structure:
```powershell
dir target\EmailListWebApp
```

Phải có:
- `index.html`
- `thanks.jsp`
- `WEB-INF\web.xml`
- `WEB-INF\classes\murach\email\EmailListServlet.class`
- `WEB-INF\classes\murach\business\User.class`
- `styles\main.css`
- `image\Murach_logo.jpg`

---

## 📊 SO SÁNH TRƯỚC VÀ SAU

| Component | Trước (Lỗi 500) | Sau (Hoạt động) |
|-----------|-----------------|-----------------|
| Servlet API | Jakarta EE (`jakarta.servlet`) | Java EE (`javax.servlet`) |
| Dependency | `jakarta.servlet-api:5.0.0` | `javax.servlet-api:4.0.1` |
| web.xml namespace | `https://jakarta.ee/xml/ns/jakartaee` | `http://xmlns.jcp.org/xml/ns/javaee` |
| Tomcat version | 9.0.111 | 9.0.111 (không đổi) |
| Tương thích | ❌ KHÔNG | ✅ TƯƠNG THÍCH |

---

## 🎯 GHI NHỚ

### Nếu muốn dùng Jakarta EE (jakarta.servlet.*):
- **Phải nâng cấp lên Tomcat 10.x hoặc 11.x**
- Download tại: https://tomcat.apache.org/download-10.cgi
- Cài đặt và cấu hình trong IntelliJ

### Nếu muốn giữ Tomcat 9:
- **Phải dùng Java EE (javax.servlet.*)** (đã làm)
- Đây là giải pháp nhanh hơn

---

## 💡 TẠI SAO CÓ SỰ THAY ĐỔI NÀY?

Oracle chuyển giao Java EE cho Eclipse Foundation → Đổi tên thành Jakarta EE → Phải đổi package từ `javax.*` sang `jakarta.*` do vấn đề bản quyền.

**Timeline**:
- Java EE 8 (2017) → Package: `javax.servlet.*` → Tomcat 9
- Jakarta EE 9 (2020+) → Package: `jakarta.servlet.*` → Tomcat 10+

---

## 🔧 DOCKERFILE ĐÃ ĐÚNG

Dockerfile đã dùng `tomcat:9.0-jdk17-corretto` nên tương thích với `javax.servlet.*`. Không cần sửa Dockerfile.

---

## ✅ CHECKLIST HOÀN THÀNH

- [x] Đổi import từ `jakarta.servlet` sang `javax.servlet`
- [x] Đổi dependency từ `jakarta.servlet-api` sang `javax.servlet-api`
- [x] Đổi web.xml namespace từ Jakarta EE sang Java EE
- [ ] **Reload Maven dependencies** ← BẠN CẦN LÀM
- [ ] **Clean và rebuild project** ← BẠN CẦN LÀM
- [ ] **Copy files vào WAR exploded** ← BẠN CẦN LÀM
- [ ] **Restart Tomcat** ← BẠN CẦN LÀM

---

## 📞 NẾU VẪN CÒN LỖI

1. Kiểm tra Tomcat logs để xem stack trace chi tiết
2. Đảm bảo IntelliJ đã reload Maven dependencies
3. Kiểm tra file `.class` đã được compile với `javax.servlet` chưa
4. Xóa hoàn toàn thư mục `target/` và rebuild lại

---

**Kết luận**: Sau khi reload Maven và rebuild, lỗi 500 sẽ được khắc phục và ứng dụng sẽ hoạt động bình thường!

