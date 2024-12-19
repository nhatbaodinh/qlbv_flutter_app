import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'cart_controller.dart';

class CartDetailPage extends StatelessWidget {
  const CartDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi Tiết Giỏ Hàng"),
      ),
      body: GetBuilder<CartController>(
        id: 'cart',
        builder: (controller) {
          if (controller.cart.isEmpty) {
            return const Center(
              child: Text("Giỏ hàng trống"),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.cart.length,
                  itemBuilder: (context, index) {
                    final cartItem = controller.cart[index];
                    return Dismissible(
                      key: Key(cartItem.ten), // Unique key for each item
                      direction: DismissDirection.endToStart, // Swipe direction
                      onDismissed: (direction) {
                        // Remove the item when swiped
                        controller.removeItem(index);
                        Get.snackbar('Đã xóa', '${cartItem.ten} đã được xóa khỏi giỏ hàng');
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Row(
                          children: [
                            // Hình ảnh sản phẩm
                            Container(
                              width: 80,
                              height: 80,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(cartItem.anh ?? "https://via.placeholder.com/150"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem.ten,
                                    style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                                  ),
                                  Text(
                                    formatCurrency(cartItem.gia * cartItem.soluong),
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            // Nút + và -
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (cartItem.soluong > 1) {
                                      controller.updateQuantity(index, cartItem.soluong - 1);
                                    }
                                  },
                                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                                ),
                                Text(
                                  '${cartItem.soluong}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller.updateQuantity(index, cartItem.soluong + 1);
                                  },
                                  icon: const Icon(Icons.add_circle, color: Colors.green),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      formatCurrency(controller.cart.fold(
                        0,
                            (sum, item) => sum + (item.gia * item.soluong),
                      )),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  print("Thanh toán được nhấn!");
                },
                child: const Text("Thanh Toán"),
              ),
            ],
          );
        },
      ),
    );
  }

  // Improved formatCurrency function using intl package
  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,##0', 'vi_VN'); // Using intl package for better formatting
    return '${formatter.format(amount)} VND';
  }
}
