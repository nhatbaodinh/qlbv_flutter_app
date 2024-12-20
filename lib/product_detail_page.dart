import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'cart_controller.dart';
import 'cart_detail.dart';
import 'products_model.dart';
import 'package:badges/badges.dart' as badges;

class ProductDetailPage extends StatelessWidget {
  final Products product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);
  String formatCurrency(int amount) {
    final formatter = NumberFormat.decimalPattern(); // Định dạng theo hệ thập phân
    return "${formatter.format(amount)} VND";
  }


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
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(()=>  CartDetailPage());// Hiển thị chi tiết giỏ hàng
            },
            child: GetBuilder<CartController>(
              id: 'cart',
              builder: (controller) {
                return badges.Badge(
                  showBadge: controller.totalItems > 0,
                  badgeContent: Text('${controller.totalItems}'),
                  child: const Icon(Icons.shopping_cart),
                );
              },
            ),
          ),

          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hiển thị hình ảnh sản phẩm
              product.anh != null && product.anh!.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  product.anh!,
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
                product.ten,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              // Loại
              Text(
                'Loại: ${product.loai ?? 'Chưa phân loại'}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 16),

              // Giá vé
              Text(
                formatCurrency(product.gia),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

              const SizedBox(height: 16),

              // Số lượng vé còn lại
              Text(
                'Số lượng còn lại: ${product.soLuong}',
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
                    product.trangThai ? 'Còn hàng' : 'Hết hàng',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: product.trangThai ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Nút mua vé và thêm vào giỏ hàng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 160, // Đặt độ rộng của nút
                    child: ElevatedButton(
                        onPressed: () {
                          final cartController = Get.find<CartController>();
                          // Provide a fallback for anh if it's null
                          cartController.addToCart(
                            product.ten, // Product name
                            product.gia, // Product price
                            product.anh ?? "https://via.placeholder.com/150", // Provide default image URL if anh is null
                          );
                        },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: product.trangThai ? Colors.green : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Icon(
                        Icons.add_shopping_cart, color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150, // Đặt độ rộng của nút
                    child: ElevatedButton(
                      onPressed: product.trangThai
                          ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Mua vé "${product.ten}" thành công!'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: product.trangThai ? Colors.blue : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Mua ngay',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}