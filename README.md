# Hotel Booking System

Hệ thống đặt phòng khách sạn được xây dựng với Spring Boot và MySQL.

## 📋 Yêu cầu hệ thống

- Java 17+
- Maven 3.6+
- MySQL 8.0+
- Spring Boot 3.2.0

## Cài đặt

### 1. Cấu hình Database

Tạo database và chạy script SQL:

```bash
mysql -u root -p123456 < database/schema.sql
```

Hoặc chạy từng lệnh trong MySQL:

```sql
CREATE DATABASE IF NOT EXISTS hotel_booking CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hotel_booking;
-- Sau đó chạy các lệnh CREATE TABLE từ file database/schema.sql
```

### 2. Cấu hình ứng dụng

File `src/main/resources/application.properties` đã được cấu hình với:
- Database: `hotel_booking`
- Username: `root`
- Password: `123456`
- Port: `8080`

### 3. Chạy ứng dụng

```bash
mvn clean install
mvn spring-boot:run
```

Ứng dụng sẽ chạy tại: `http://localhost:8080`

## API Endpoints

### Authentication

- `POST /api/auth/register` - Đăng ký tài khoản
- `POST /api/auth/login` - Đăng nhập

### Admin APIs (Yêu cầu role ADMIN)

- `GET /api/admin/users` - Lấy danh sách tất cả users
- `GET /api/admin/users/{id}` - Lấy thông tin user theo ID
- `POST /api/admin/users` - Tạo user mới
- `PUT /api/admin/users/{id}` - Cập nhật user
- `DELETE /api/admin/users/{id}` - Xóa user
- `PUT /api/admin/users/{id}/toggle-status` - Kích hoạt/vô hiệu hóa user
- `GET /api/admin/statistics` - Thống kê tổng quan hệ thống
- `GET /api/rooms/pending` - Lấy danh sách phòng chờ duyệt
- `PUT /api/rooms/{id}/approve` - Duyệt phòng
- `PUT /api/rooms/{id}/reject` - Từ chối phòng

### Hotel Owner APIs (Yêu cầu role HOTEL_OWNER hoặc ADMIN)

- `GET /api/hotels/owner/{ownerId}` - Lấy danh sách khách sạn của owner
- `POST /api/hotels` - Tạo khách sạn mới
- `PUT /api/hotels/{id}` - Cập nhật khách sạn
- `DELETE /api/hotels/{id}` - Xóa khách sạn
- `POST /api/rooms` - Tạo phòng mới
- `PUT /api/rooms/{id}` - Cập nhật phòng
- `DELETE /api/rooms/{id}` - Xóa phòng
- `GET /api/bookings/hotel/{hotelId}` - Lấy danh sách booking của khách sạn
- `GET /api/owner/statistics` - Thống kê doanh thu và booking

### User APIs (Yêu cầu role USER, HOTEL_OWNER hoặc ADMIN)

- `GET /api/user/bookings?userId={id}` - Lấy danh sách booking của user
- `GET /api/rooms` - Lấy danh sách tất cả phòng
- `GET /api/rooms/{id}` - Lấy thông tin chi tiết phòng
- `GET /api/rooms/search?city={city}&minPrice={min}&maxPrice={max}&guests={guests}` - Tìm kiếm phòng
- `POST /api/bookings?userId={id}` - Tạo booking mới
- `PUT /api/bookings/{id}/cancel?userId={id}` - Hủy booking

## Authentication

Tất cả các API (trừ `/api/auth/**`) yêu cầu JWT token trong header:

```
Authorization: Bearer <token>
```

Token được trả về sau khi đăng nhập thành công.

## Default Admin Account

Sau khi chạy schema.sql, có một tài khoản admin mặc định:
- Username: `admin`
- Password: `admin123`

**Lưu ý:** Trong production, nên thay đổi password ngay sau khi deploy.

## Cấu trúc Database

### Users
- Quản lý tất cả users (Admin, Hotel Owner, User)
- Role: ADMIN, HOTEL_OWNER, USER

### Hotels
- Thông tin khách sạn
- Mỗi hotel thuộc về một Hotel Owner

### Rooms
- Thông tin phòng
- Status: PENDING, APPROVED, REJECTED
- Phòng mới tạo có status PENDING, cần Admin duyệt

### Bookings
- Thông tin đặt phòng
- Booking Status: PENDING, CONFIRMED, CANCELLED, COMPLETED
- Payment Status: PAID, UNPAID, REFUNDED

### Reviews
- Đánh giá phòng (tùy chọn)

## Flow chính

1. **Hotel Owner đăng phòng**
   - Tạo phòng mới → status: PENDING
   - Admin duyệt → status: APPROVED hoặc REJECTED

2. **User tìm kiếm và đặt phòng**
   - Tìm kiếm phòng theo city, giá, số người
   - Chỉ hiển thị phòng có status APPROVED
   - Tạo booking → check availability → tính giá

3. **Hủy booking**
   - User có thể hủy booking của mình
   - Tự động cập nhật payment status nếu đã thanh toán

4. **Thống kê**
   - Admin: thống kê toàn hệ thống
   - Hotel Owner: thống kê doanh thu, booking, occupancy rate

## 📁 Cấu trúc Project

Xem chi tiết trong [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)

## 🔧 Bảo trì và Nâng cấp

Xem hướng dẫn chi tiết trong [MAINTENANCE.md](MAINTENANCE.md)

## 🚀 Development

### Build project
```bash
mvn clean package
```

### Run application
```bash
mvn spring-boot:run
```

### Run tests
```bash
mvn test
```

## 📚 Documentation

- [Project Structure](PROJECT_STRUCTURE.md) - Cấu trúc thư mục và tổ chức code
- [Maintenance Guide](MAINTENANCE.md) - Hướng dẫn bảo trì và nâng cấp
- [System Analysis](anlytic/anlytic.md) - Phân tích hệ thống và requirements

## 📝 Notes

### Static Resources

Do cấu trúc thư mục có duplicate (`assets/assets/`, `js/js/`), các JSP files sử dụng paths như:
- `/assets/assets/css/style.css`
- `/js/js/api.js`

Cấu hình này được xử lý tự động bởi `WebMvcConfig.java`.

### Configuration

Tất cả constants và paths được quản lý tập trung trong `AppConstants.java` để dễ dàng thay đổi và bảo trì.

## License

MIT

