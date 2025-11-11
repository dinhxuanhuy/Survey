# 📋 TÓM TẮT CÁC LỖI ĐÃ GẶP VÀ CÁCH SỬA

**Ngày**: 11/11/2025  
**Project**: EmailListWebApp - Survey Application  
**Lỗi ban đầu**: 
1. HTTP Status 404 – Not Found
2. HTTP Status 500 – Internal Server Error (ClassNotFoundException)

---

## 🔴 CÁC LỖI ĐÃ GẶP

### Lỗi 1: Package Name Sai ❌

**Hiện tượng**: 
- Servlet không được tìm thấy khi deploy
- ClassNotFoundException trong Tomcat logs

**Nguyên nhân**:
```java
// SAI - Có tiền tố "java" trong package
package java.murach.email;
package java.murach.business;
```

**Cách sửa**:
```java
// ĐÚNG - Bỏ tiền tố "java"
package murach.email;
package murach.business;
```

**File đã sửa**:
- `src/java/murach/email/EmailListServlet.java`
- `src/java/murach/business/User.java`

---

### Lỗi 2: Servlet Class Mapping Sai trong web.xml ❌

**Hiện tượng**:
- Tomcat không thể load servlet class
- 404 error khi submit form

**Nguyên nhân**:
```xml
<!-- SAI - Có tiền tố "java" trong class name -->
<servlet-class>java.murach.email.EmailListServlet</servlet-class>
```

**Cách sửa**:
```xml
<!-- ĐÚNG - Bỏ tiền tố "java" -->
<servlet-class>murach.email.EmailListServlet</servlet-class>
```

**File đã sửa**:
- `web/WEB-INF/web.xml`

---

### Lỗi 3: Parameter Name Không Khớp ❌

**Hiện tượng**:
- Ngày sinh không được hiển thị trong trang kết quả
- Giá trị null cho field dateOfBirth

**Nguyên nhân**:
```html
<!-- Form gửi parameter tên "dateOfBirth" -->
<input type="date" name="dateOfBirth" required>
```

```java
// Nhưng servlet đọc parameter tên "dob"
String dob = request.getParameter("dob");  // ❌ SAI
```

**Cách sửa**:
```java
// ĐÚNG - Đọc đúng tên parameter từ form
String dob = request.getParameter("dateOfBirth");  // ✅ ĐÚNG
```

**File đã sửa**:
- `src/java/murach/email/EmailListServlet.java`

---

### Lỗi 4: Context Path Không Khớp ❌

**Hiện tượng**:
- URL `/EmailListWebApp_war/` trả về 404
- Không tìm thấy resource

**Nguyên nhân**:
```xml
<!-- Context path trong context.xml -->
<Context path="/EmailListApp"/>
```

Nhưng IntelliJ tự động đặt context là `/EmailListWebApp_war/` khi deploy WAR file.

**Cách sửa**:
```xml
<!-- Đổi thành tên khớp với WAR file -->
<Context path="/EmailListWebApp"/>
```

**File đã sửa**:
- `web/META-INF/context.xml`

**Bước bổ sung trong IntelliJ**:
1. Run → Edit Configurations...
2. Tab Deployment
3. Đổi Application context từ `/EmailListWebApp_war` → `/EmailListWebApp`
4. Apply → OK
5. Restart Tomcat

---

### Lỗi 5: Maven Configuration Thiếu ❌

**Hiện tượng**:
- Maven không tìm thấy source files
- Maven không copy web.xml và các file tĩnh vào WAR

**Nguyên nhân**:
Maven mặc định tìm:
- Java source: `src/main/java/` (nhưng project dùng `src/java/`)
- Web resources: `src/main/webapp/` (nhưng project dùng `web/`)

**Cách sửa**:
```xml
<build>
    <!-- Chỉ định thư mục source đúng -->
    <sourceDirectory>src/java</sourceDirectory>
    <finalName>EmailListWebApp</finalName>
    
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-war-plugin</artifactId>
            <version>3.3.2</version>
            <configuration>
                <!-- Chỉ định thư mục web resources đúng -->
                <warSourceDirectory>web</warSourceDirectory>
                <failOnMissingWebXml>false</failOnMissingWebXml>
            </configuration>
        </plugin>
    </plugins>
</build>
```

**File đã sửa**:
- `pom.xml`

---

### Lỗi 6: WAR Exploded Thiếu Files ❌

**Hiện tượng**:
- 404 error ngay cả khi URL đúng
- Tomcat logs không có lỗi rõ ràng

**Nguyên nhân**:
Thư mục `target/EmailListWebApp/` (WAR exploded) thiếu:
- `WEB-INF/web.xml`
- `index.html`, `thanks.jsp`
- `styles/`, `image/`

**Cách sửa**:
Copy thủ công các file cần thiết:
```cmd
copy web\WEB-INF\web.xml target\EmailListWebApp\WEB-INF\web.xml
copy web\index.html target\EmailListWebApp\index.html
copy web\thanks.jsp target\EmailListWebApp\thanks.jsp
xcopy web\styles target\EmailListWebApp\styles\ /E /I /Y
xcopy web\image target\EmailListWebApp\image\ /E /I /Y
```

**Giải pháp dài hạn**: Sử dụng Maven để build:
```cmd
mvn clean package
```

### Lỗi 7: Jakarta vs Javax Servlet API (Tomcat Version Mismatch) ❌

**Hiện tượng**:
- HTTP Status 500 – Internal Server Error
- ClassNotFoundException: `jakarta.servlet.http.HttpServlet`
| `src/java/murach/email/EmailListServlet.java` | Package: `java.murach.email`<br>Import: `java.murach.business.User`<br>Import: `jakarta.servlet.*`<br>Parameter: `dob` | Package: `murach.email`<br>Import: `murach.business.User`<br>Import: `javax.servlet.*`<br>Parameter: `dateOfBirth` |
| `web/WEB-INF/web.xml` | `<servlet-class>java.murach.email.EmailListServlet</servlet-class>`<br>Namespace: Jakarta EE | `<servlet-class>murach.email.EmailListServlet</servlet-class>`<br>Namespace: Java EE |
**Nguyên nhân**:
| `pom.xml` | Thiếu `<sourceDirectory>` và `<warSourceDirectory>`<br>Dependency: `jakarta.servlet-api:5.0.0` | Đã thêm cả hai<br>Dependency: `javax.servlet-api:4.0.1` |

```java
// SAI - Jakarta EE (chỉ tương thích Tomcat 10+)
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
```

```xml
<!-- SAI - Jakarta EE dependency -->
<dependency>
    <groupId>jakarta.servlet</groupId>
    <artifactId>jakarta.servlet-api</artifactId>
    <version>5.0.0</version>
</dependency>
```

**Bảng tương thích**:
| Tomcat Version | Servlet API | Package |
|----------------|-------------|---------|
| Tomcat 9.x | Java EE 8 (Servlet 4.0) | `javax.servlet.*` |
| Tomcat 10.x+ | Jakarta EE 9+ (Servlet 5.0+) | `jakarta.servlet.*` |

**Cách sửa** (Option 1 - Đổi về Java EE):
```java
// ĐÚNG - Java EE (tương thích Tomcat 9)
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
```

```xml
<!-- ĐÚNG - Java EE dependency -->
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>4.0.1</version>
    <scope>provided</scope>
</dependency>
```

```xml
<!-- ĐÚNG - Java EE namespace trong web.xml -->
<web-app version="4.0" 
         xmlns="http://xmlns.jcp.org/xml/ns/javaee" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee 
         http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd">
```

**Cách sửa** (Option 2 - Nâng cấp Tomcat):
- Nâng cấp lên Tomcat 10.1 hoặc 11.x
- Giữ nguyên code với `jakarta.servlet.*`

**File đã sửa**:
- `src/java/murach/email/EmailListServlet.java` (đổi import)
- `pom.xml` (đổi dependency)
- `web.xml` (đổi namespace)

---

---

## ✅ TỔNG HỢP CÁC FILE ĐÃ SỬA

| File | Lỗi | Sửa |
|------|-----|-----|
| `src/java/murach/business/User.java` | Package: `java.murach.business` | Package: `murach.business` |
| `src/java/murach/email/EmailListServlet.java` | Package: `java.murach.email`<br>Import: `java.murach.business.User`<br>Parameter: `dob` | Package: `murach.email`<br>Import: `murach.business.User`<br>Parameter: `dateOfBirth` |
| `web/WEB-INF/web.xml` | `<servlet-class>java.murach.email.EmailListServlet</servlet-class>` | `<servlet-class>murach.email.EmailListServlet</servlet-class>` |
| `web/META-INF/context.xml` | `<Context path="/EmailListApp"/>` | `<Context path="/EmailListWebApp"/>` |
| `pom.xml` | Thiếu `<sourceDirectory>` và `<warSourceDirectory>` | Đã thêm cả hai |

---

## 🚀 WORKFLOW ĐÚNG ĐỂ DEPLOY

### Cách 1: Sử dụng Maven (Khuyến nghị)

```cmd
cd C:\Users\dinhx\Downloads\survey-master\survey-master
mvn clean compile
mvn package
```

Sau đó deploy file `target/EmailListWebApp.war` trong IntelliJ.

### Cách 2: Sử dụng IntelliJ Build

1. **Build → Rebuild Project**
2. **Run → Edit Configurations...**
   - Tab Deployment
   - Add Artifact: `EmailListWebApp:war exploded`
   - Application context: `/EmailListWebApp`
3. **Run Tomcat** (Shift + F10)

### Cách 3: Copy thủ công (Tạm thời)

```cmd
# Copy web.xml
copy web\WEB-INF\web.xml target\EmailListWebApp\WEB-INF\web.xml

# Copy static files
copy web\index.html target\EmailListWebApp\index.html
copy web\thanks.jsp target\EmailListWebApp\thanks.jsp
xcopy web\styles target\EmailListWebApp\styles\ /E /I /Y
xcopy web\image target\EmailListWebApp\image\ /E /I /Y
```

---

## 🎯 URL ĐÚNG ĐỂ TRUY CẬP

### ❌ SAI:
- `http://localhost:8080/EmailListWebApp_war/`
- `http://localhost:8080/EmailListApp/`
- `http://localhost:8080/survey/`

### ✅ ĐÚNG:
- `http://localhost:8080/EmailListWebApp/`
- `http://localhost:8080/EmailListWebApp/index.html`

---

## 📊 WORKFLOW CỦA APPLICATION

```
1. User truy cập: http://localhost:8080/EmailListWebApp/
   ↓
2. Tomcat serve file: index.html
   ↓
3. User điền form và submit
   ↓
4. Form POST đến: /emailList (servlet mapping)
   ↓
5. Tomcat gọi: murach.email.EmailListServlet.doPost()
   ↓
6. Servlet tạo User object và set attributes
   ↓
7. Forward request đến: thanks.jsp
   ↓
8. JSP hiển thị thông tin từ User object
   ↓
9. User thấy kết quả
```

---

## 🔍 CHECKLIST KIỂM TRA KHI GẶP LỖI 404

- [ ] Package name đúng (không có tiền tố "java")
- [ ] web.xml servlet-class đúng
- [ ] Parameter names khớp giữa form và servlet
- [ ] Context path đúng trong context.xml
- [ ] Application context trong IntelliJ đúng
- [ ] WAR exploded có đầy đủ files (web.xml, index.html, thanks.jsp, etc.)
- [ ] Class files đã được compile (.class files tồn tại)
- [ ] URL truy cập đúng format
- [ ] Tomcat đang chạy và không có lỗi trong logs
- [ ] Port 8080 không bị conflict

---

## 💡 BÀI HỌC KINH NGHIỆM

1. **Package naming**: Không dùng `java.*` làm package name vì conflict với Java standard library
2. **Maven structure**: Khi dùng cấu trúc khác với Maven convention, phải config rõ ràng trong pom.xml
3. **Context path**: Phải đồng nhất giữa context.xml, IntelliJ config, và URL truy cập
4. **Parameter names**: Phải khớp chính xác giữa HTML form và servlet code
5. **WAR structure**: Phải đầy đủ WEB-INF/web.xml và các resource files
6. **IntelliJ auto-naming**: IntelliJ thường thêm `_war` vào context, cần sửa thủ công

---

## 📞 LIÊN HỆ / HỖ TRỢ

Nếu gặp lỗi tương tự, kiểm tra theo thứ tự:
1. Tomcat Catalina log để xem stack trace
2. web.xml mapping đúng chưa
3. Class files đã được compile chưa
4. Context path trong Run Configuration
5. URL đang truy cập có đúng không

---

**Kết luận**: Tất cả các lỗi đã được sửa thành công. Application hiện đang hoạt động bình thường tại `http://localhost:8080/EmailListWebApp/`

