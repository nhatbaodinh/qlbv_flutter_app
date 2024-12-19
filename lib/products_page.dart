import 'package:flutter/material.dart';
import 'package:qlbv_flutter_app/tickets_model.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Danh Sách Sản Phẩm",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<List<Tickets_Snapshot>>(
        future: Tickets_Snapshot.getAll(),  // Fetch all tickets
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),  // Show error message if any
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),  // Show loading spinner if no data is available
            );
          }

          var list = snapshot.data!;  // List of tickets
          print("Fetched tickets: $list");  // Log to check the fetched data

          if (list.isEmpty) {
            return const Center(
              child: Text("Không có vé nào được hiển thị."),  // Message if no tickets
            );
          }

          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: GridView.extent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 0.75,
              children: list.map(
                    (ticket) {
                  print("Ticket details: ${ticket.tickets.ten}");  // Log each ticket's details
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the image of the ticket (fallback image if no URL)
                        Expanded(
                          child: Image.network(
                            ticket.tickets.anh ?? "https://via.placeholder.com/150", // Placeholder image
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        // Display the ticket name (ten)
                        Text(
                          ticket.tickets.ten,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4.0),
                        // Display the ticket price (gia)
                        Text(
                          "Giá: ${ticket.tickets.gia} VND",
                          style: const TextStyle(color: Colors.green),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4.0),
                        // Display the ticket type (loaiVe)
                        Text(
                          "Loại vé: ${ticket.tickets.loaiVe}",
                          style: const TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
          );
        },
      ),
    );
  }
}