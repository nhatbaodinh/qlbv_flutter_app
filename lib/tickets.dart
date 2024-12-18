import 'package:flutter/material.dart';
import 'package:qlbv_flutter_app/TicketsModel.dart';

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
        title: Text("Products Page"),
      ),
      body: FutureBuilder<List<Tickets_Snapshot>>(
        future: Tickets_Snapshot.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var list = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: GridView.extent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 0.75,
              children: list.map(
                    (ticket) {
                  return Column(
                    children: [
                      // Giả sử mỗi ticket có ảnh URL
                      Image.network(ticket.tickets.anh ?? "no url"),
                      Text(ticket.tickets.ten),
                      Text("${ticket.tickets.giaVe}"),
                      Text("${ticket.tickets.loaiVe}"),
                    ],
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
