import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_controller.dart'; // Đảm bảo bạn import CartController

// Widget hiển thị giỏ hàng
Widget buildCartDialog() {
  return GetBuilder<CartController>(
    id: 'cart',
    builder: (controller) {
      print('Giỏ hàng: ${controller.cart.length} sản phẩm'); // Debug giỏ hàng
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Giỏ Hàng',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Kiểm tra xem giỏ hàng có sản phẩm nào không
              if (controller.cart.isEmpty)
                const Center(
                  child: Text("Giỏ hàng trống"),
                )
              else
              // Hiển thị danh sách sản phẩm trong giỏ hàng
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.cart.length,
                  itemBuilder: (context, index) {
                    final cartItem = controller.cart[index];
                    return ListTile(
                      title: Text(cartItem.ten),
                      subtitle: Text('Số lượng: ${cartItem.soluong}'),
                      trailing: Text(formatCurrency(cartItem.gia * cartItem.soluong)),
                    );
                  },
                ),
              const Divider(),
              // Tổng tiền
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tổng:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    formatCurrency(controller.cart.fold(0, (sum, item) => sum + (item.gia * item.soluong))),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Get.back(); // Đóng modal
                },
                child: const Text("Đóng"),
              ),
            ],
          ),
        ),
      );
    },
  );
}


// Hàm định dạng giá tiền
String formatCurrency(int amount) {
  final currency = amount.toString().replaceAll(RegExp(r'(?<=\d)(?=(\d{3})+(?!\d))'), ',');
  return '$currency VND';
}
