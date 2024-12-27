import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'cart_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class CartDetailPage extends StatelessWidget {
  CartDetailPage({Key? key}) : super(key: key);

  Future<void> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (!status.isGranted) {
      Get.snackbar('Lỗi', 'Bạn cần cấp quyền lưu trữ để lưu ảnh');
    }
  }

  final ScreenshotController screenshotController = ScreenshotController(); // Controller để chụp màn hình

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
                      key: Key(cartItem.ten),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
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
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      scrollable: true,
                      title: const Text("Mã đơn"),
                      content: Screenshot(
                        controller: screenshotController,
                        child: SizedBox(
                          width: 250,
                          height: 250,
                          child: QrImageView(
                            data: generateCartData(controller),
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => {
                            Navigator.pop(context),
                            controller.clearCartafterPay(),
                          },
                          child: const Text("Đóng"),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await requestStoragePermission();
                            // saveQrCode();
                          },
                          icon: const Icon(Icons.save),
                          label: const Text("Lưu Mã QR"),
                        ),
                      ],
                    ),
                  );

                },
                child: const Text("Thanh Toán"),
              ),
            ],
          );
        },
      ),
    );
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,##0', 'vi_VN');
    return '${formatter.format(amount)} VND';
  }

  String generateCartData(CartController controller) {
    final today = DateTime.now();
    final threeDaysLater = today.add(Duration(days: 7));

    final items = controller.cart
        .map((item) => '${item.ten} x ${item.soluong}') // Tên vé và số lượng
        .join('\n'); // Đưa các vé lên dòng mới

    final total = formatCurrency(controller.cart.fold(
      0,
          (sum, item) => sum + (item.gia * item.soluong),
    ));

    // Định dạng thời gian
    final dateFormat = DateFormat('dd/MM/yyyy');
    final startDate = dateFormat.format(today);
    final endDate = dateFormat.format(threeDaysLater);

    return 'Sản phẩm của bạn:\n$items\n\nThời hạn: $startDate đến $endDate\nTổng tiền: $total';
  }


  // Future<void> saveQrCode() async {
  //   try {
  //     final image = await screenshotController.capture();
  //     if (image != null) {
  //       final result = await SaverGallery.saveImage(
  //         Uint8List.fromList(image),
  //         fileName: 'QRCode',
  //         quality: 100,
  //         skipIfExists: true
  //       );
  //       if (result==true) {
  //         Get.snackbar('Thành công', 'Mã QR đã được lưu vào thư viện!');
  //       } else {
  //         Get.snackbar('Lỗi', 'Không thể lưu mã QR!');
  //       }
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
