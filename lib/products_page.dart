import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:qlbv_flutter_app/products_model.dart';

import 'cart_controller.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String formatCurrency(int amount) {
    final formatter = NumberFormat.decimalPattern(); // Định dạng theo hệ thập phân
    return "${formatter.format(amount)} VND";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Danh Sách Sản Phẩm",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<List<Products_Snapshot>>(
        future: Products_Snapshot.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var list = snapshot.data!;
          if (list.isEmpty) {
            return const Center(
              child: Text("Không có sản phẩm nào được hiển thị."),
            );
          }

          return GridView.extent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 0.75,
            children: list.map((product) {
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.network(
                        product.products.anh ?? "https://via.placeholder.com/150",
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      product.products.ten,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      formatCurrency(product.products.gia),
                      style: const TextStyle(color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4.0),
                    ElevatedButton(
                      onPressed: () {
                        final cartController = Get.find<CartController>();
                        cartController.addToCart(
                          product.products.ten,
                          product.products.gia,
                        );
                      },
                      child: const Icon(Icons.add_shopping_cart),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
