import 'package:flutter/material.dart';
import 'package:qlbv_flutter_app/cart_controller.dart';
import 'package:qlbv_flutter_app/cart_detail.dart';
import 'products_model.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

class ProductDetailPage extends StatelessWidget {
  final Products product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

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
        actions: [
          GestureDetector(
            onTap: () {
              print("Giỏ hàng được nhấn");
              Get.dialog(buildCartDialog());
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
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow under AppBar
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display product image
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

              // Product name
              Text(
                product.ten,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              // Product type
              Text(
                'Loại: ${product.loai ?? 'Chưa phân loại'}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 16),

              // Product price
              Text(
                'Giá: ${product.gia} VND',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

              const SizedBox(height: 16),

              // Product quantity
              Text(
                'Số lượng còn lại: ${product.soLuong}',
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),

              const SizedBox(height: 16),

              // Product status
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

              // Buttons to add to cart and purchase
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 160, // Set width of the button
                    child: ElevatedButton(
                      onPressed: () {
                        final cartController = Get.find<CartController>();
                        cartController.addToCart(
                          product.ten, // Corrected argument
                          product.gia, // Corrected argument
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: product.trangThai ? Colors.green : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Thêm vào Giỏ hàng',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150, // Set width of the button
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