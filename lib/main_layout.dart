import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
class MainLayout extends StatefulWidget {
  final List<Widget> pages; // Các trang sẽ được truyền vào
  final List<BottomNavigationBarItem> navItems; // Các mục trong BottomNavigationBar
  const MainLayout({
    Key? key,
    required this.pages,
    required this.navItems,
  }) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ứng dụng mua vé"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          BuildCart(),
          const SizedBox(width: 15,)
        ],

      ),
      body: IndexedStack(
        index: _currentIndex, // Hiển thị trang dựa trên chỉ mục
        children: widget.pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pinkAccent,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Thay đổi trang khi người dùng chọn
          });
        },
        items: widget.navItems,
      ),
    );
  }
}

Widget BuildCart() {
  return GestureDetector(
    onTap: () {
      // TODO: Implement your cart navigation logic
    },
    child: const SizedBox(
      width: 50,
      height: 50,
      child: badges.Badge(
        showBadge: true,
        badgeContent: Text(
          '3', // Tạm thời sử dụng giá trị giả lập
          style: TextStyle(color: Colors.white),
        ),
        child: const Icon(Icons.add_shopping_cart_outlined, size: 30),
      ),
    ),
  );
}
