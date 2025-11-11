# 🔧 HƯỚNG DẪN REBUILD VÀ DEPLOY LẠI PROJECT

## ⚠️ LỖI HIỆN TẠI: `/EmailListWebApp_war/` not available

**Nguyên nhân**: Application context trong Tomcat configuration không đúng!

## 🎯 GIẢI PHÁP NHANH (LÀM NGAY):

### Bước 1: Sửa Application Context trong IntelliJ

1. Nhấn **Shift + Alt + F10** hoặc click vào dropdown Tomcat ở góc trên bên phải
2. Chọn **Edit Configurations...**
3. Chọn cấu hình Tomcat của bạn (bên trái)
4. Chuyển sang tab **Deployment**
5. Tìm artifact hoặc WAR file đã deploy
6. Nhìn vào cột **Application context** bên phải
7. **QUAN TRỌNG**: Thay đổi từ `/EmailListWebApp_war` thành `/EmailListWebApp` hoặc `/`
8. Click **Apply** rồi **OK**

### Bước 2: Restart Tomcat

1. **Stop** Tomcat (nút Stop màu đỏ hoặc Shift + F5)
2. **Start** Tomcat lại (nút Run màu xanh hoặc Shift + F10)

### Bước 3: Truy cập đúng URL

- Nếu đặt context là `/EmailListWebApp`: 
  ```
  http://localhost:8080/EmailListWebApp/
  ```

- Nếu đặt context là `/` (root):
  ```
  http://localhost:8080/
  ```

---

## ✅ Các lỗi đã được sửa:

1. ✅ **Package name**: Đã sửa từ `java.murach.*` → `murach.*`
2. ✅ **web.xml**: Đã sửa servlet-class từ `java.murach.email.EmailListServlet` → `murach.email.EmailListServlet`
3. ✅ **Parameter name**: Đã sửa từ `dob` → `dateOfBirth` để khớp với form
4. ✅ **Context path**: Đã sửa từ `/EmailListApp` → `/EmailListWebApp` 
5. ✅ **Maven configuration**: Đã cấu hình `warSourceDirectory` và `sourceDirectory`

---

## 📋 CÁC BƯỚC THỰC HIỆN TRONG INTELLIJ IDEA:

### Bước 1: Clean project
1. Mở **Maven** tool window (View → Tool Windows → Maven)
2. Mở **Lifecycle**
3. Double-click vào **clean**

### Bước 2: Compile project
1. Trong Maven tool window
2. Double-click vào **compile**

### Bước 3: Package thành WAR
1. Trong Maven tool window
2. Double-click vào **package**
3. Kiểm tra console để đảm bảo không có lỗi

### Bước 4: Cấu hình Tomcat
1. Chọn **Run** → **Edit Configurations...**
2. Nếu chưa có Tomcat configuration:
   - Click **+** → **Tomcat Server** → **Local**
   - Configure Tomcat home: `C:\Program Files\Apache Software Foundation\Tomcat 10.1`
3. Trong tab **Deployment**:
   - Click **+** → **Artifact** → Chọn **EmailListWebApp:war exploded**
   - Hoặc chọn **External Source** → chọn file `target\EmailListWebApp.war`
   - **Application context**: Đặt là `/EmailListWebApp` hoặc `/`
4. Trong tab **Server**:
   - **On 'Update' action**: Chọn **Redeploy**
   - **On frame deactivation**: Chọn **Update classes and resources**
5. Click **OK**

### Bước 5: Deploy và chạy
1. Stop Tomcat nếu đang chạy (Shift + F5)
2. **Clean Tomcat cache**:
   - Vào thư mục: `C:\Users\dinhx\.IntelliJIdea20XX\system\tomcat\`
   - Xóa thư mục có tên project của bạn
3. Start Tomcat (Shift + F10)

### Bước 6: Truy cập ứng dụng
Thử các URL sau trong trình duyệt:
- `http://localhost:8080/EmailListWebApp/`
- `http://localhost:8080/EmailListWebApp/index.html`

---

## 🔍 KIỂM TRA LỖI

### Nếu vẫn lỗi 404:

1. **Kiểm tra Tomcat logs**:
   - Xem tab **Tomcat Localhost Log** hoặc **Tomcat Catalina Log**
   - Tìm dòng có chứa `Deployment of web application`
   - Xem context path thực tế là gì

2. **Kiểm tra WAR đã deploy đúng chưa**:
   ```
   dir target\EmailListWebApp\WEB-INF
   ```
   Phải có file `web.xml` và thư mục `classes`

3. **Kiểm tra servlet mapping**:
   ```
   type target\EmailListWebApp\WEB-INF\web.xml
   ```
   Phải thấy servlet-class là `murach.email.EmailListServlet`

4. **Kiểm tra class files**:
   ```
   dir target\EmailListWebApp\WEB-INF\classes\murach\email
   dir target\EmailListWebApp\WEB-INF\classes\murach\business
   ```
   Phải có file `EmailListServlet.class` và `User.class`

---

## ⚠️ LƯU Ý QUAN TRỌNG:

- **URL đúng**: `http://localhost:8080/EmailListWebApp/` (không phải `/EmailListWebApp_war/`)
- **Context path**: Phải khớp với cấu hình trong `context.xml` và Tomcat configuration
- **Java version**: Project yêu cầu JDK 17+
- **Tomcat version**: Phải là Tomcat 10.x (hỗ trợ Jakarta EE)

---

## 🎯 TEST WORKFLOW:

1. Truy cập: `http://localhost:8080/EmailListWebApp/index.html`
2. Điền form và submit
3. Servlet sẽ xử lý tại `/emailList` 
4. Redirect tới `thanks.jsp` để hiển thị kết quả

---

## 📞 NẾU VẪN CÒN LỖI:

Cung cấp thông tin sau:
1. URL chính xác bạn đang truy cập
2. Nội dung trong **Tomcat Catalina Log** khi start server
3. Screenshot của **Run Configuration** (tab Deployment)

