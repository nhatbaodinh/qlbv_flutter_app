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
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo PageController với trang ban đầu
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose(); // Đảm bảo giải phóng tài nguyên
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ứng dụng mua vé"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          const SizedBox(width: 15,)
        ],
      ),
      body: PageView(
        controller: _pageController, // Điều khiển trang hiện tại
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // Cập nhật chỉ số khi cuộn trang
          });
        },
        children: widget.pages, // Các trang trong body
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pinkAccent,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Cập nhật chỉ số khi người dùng chọn mục
            _pageController.jumpToPage(index); // Chuyển đến trang tương ứng
          });
        },
        items: widget.navItems, // Các mục trong BottomNavigationBar
      ),
    );
  }
}

