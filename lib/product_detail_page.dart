import 'package:flutter/material.dart';
import 'tickets_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Tickets ticket; // Dữ liệu vé được truyền từ trang trước

  const ProductDetailPage({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi Tiết Vé',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Xóa bóng dưới AppBar
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hiển thị hình ảnh sản phẩm
              ticket.anh != null && ticket.anh!.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  ticket.anh!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 150,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              )
                  : Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.image_not_supported,
                  size: 100,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              // Tên vé
              Text(
                ticket.ten,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              // Loại vé
              Text(
                'Loại vé: ${ticket.loaiVe ?? 'Chưa có loại vé'}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 16),

              // Giá vé
              Text(
                'Giá: ${ticket.gia} VND',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

              const SizedBox(height: 16),

              // Số lượng vé còn lại
              Text(
                'Số lượng còn lại: ${ticket.soLuong}',
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),

              const SizedBox(height: 16),

              // Trạng thái vé
              Row(
                children: [
                  const Text(
                    'Trạng thái: ',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Text(
                    ticket.trangThai ? 'Còn hàng' : 'Hết hàng',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ticket.trangThai ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Nút mua vé
              Center(
                child: ElevatedButton(
                  onPressed: ticket.trangThai
                      ? () {
                    // Xử lý logic khi người dùng muốn mua vé
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Mua vé "${ticket.ten}" thành công!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                      : null, // Nút sẽ bị disable nếu hết hàng
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ticket.trangThai
                        ? Colors.blue
                        : Colors.grey, // Màu nút thay đổi theo trạng thái
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Mua Vé Ngay',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}