# Quản Lý Bán Vé - Viện Hải Dương Học Nha Trang

Ứng dụng quản lý bán vé cho Viện Hải Dương Học Nha Trang được phát triển bằng **Flutter**. Đây là sản phẩm cuối kỳ của học phần **Lập Trình Ứng Dụng Di Động**, nhằm cung cấp một nền tảng bán vé tham quan trực tuyến.

---

## 📌 Mục Tiêu

Ứng dụng cho phép người quản lý và khách hàng:

- **Quản lý vé tham quan**: Quản lý số lượng vé, giá vé, thông tin vé.
- **Đặt vé trực tuyến**: Khách hàng có thể mua vé qua ứng dụng.
- **Thanh toán trực tuyến**: Cung cấp phương thức thanh toán tiện lợi và an toàn.
- **Quản lý thông tin khách hàng**: Lưu trữ thông tin đặt vé của khách hàng.
- **Báo cáo và thống kê**: Người quản lý có thể xem thống kê về số lượng vé đã bán, doanh thu và các báo cáo khác.

---

## 🔑 Tính Năng Chính

- **Đăng nhập/Đăng ký**: Người quản lý có thể đăng nhập để sử dụng các tính năng quản lý.
- **Quản lý vé**: Thêm, sửa, xóa vé tham quan, cấu hình giá vé và số lượng vé có sẵn.
- **Quản lý đơn hàng**: Xem các đơn hàng, trạng thái đơn hàng và thông tin khách hàng.
- **Thanh toán trực tuyến**: Tích hợp phương thức thanh toán qua các cổng thanh toán điện tử.

---

## 💻 Cài Đặt

### 📝 Yêu Cầu Hệ Thống

- **Flutter**: Cần cài đặt Flutter SDK phiên bản mới nhất.
- **Dart**: Phiên bản Dart tương thích với Flutter.

## 🚀 Cài Đặt Ứng Dụng

### Bước 1: Clone Dự Án
Sử dụng Git để clone dự án từ GitHub về máy của bạn:
```bash
git clone https://github.com/username/qlbv_flutter_app.git
cd qlbv_flutter_app
```

### Bước 2: Cài Đặt Dependencies
Sử dụng lệnh sau để cài đặt các dependencies cần thiết cho ứng dụng:
```bash
flutter pub get
```

### Bước 3: Cấu Hình Supabase
Cấu hình lib/main.dart với thông tin của Supabase:
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://your-supabase-url.supabase.co',
    anonKey: 'your-supabase-api-key',
  );
  runApp(MyApp());
}
```

### Bước 4: Chạy Ứng Dụng
Cuối cùng, sử dụng lệnh sau để chạy ứng dụng trên thiết bị hoặc máy ảo:
```bash
flutter run
```