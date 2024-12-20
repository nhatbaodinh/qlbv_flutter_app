import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qlbv_flutter_app/product_detail_page.dart';
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
            childAspectRatio: 0.5,
            children: list.map((product) {
              return InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: product.products), // Truyền sản phẩm đúng kiểu
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          product.products.anh ?? "https://via.placeholder.com/150", // Ensure fallback to placeholder image if anh is null
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        product.products.ten ,
                        style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        formatCurrency(product.products.gia),
                        style: const TextStyle(color: Colors.green,fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4.0),
                      Text('Loại: ${product.products.loai}',style: TextStyle(color: Colors.grey),)

                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
