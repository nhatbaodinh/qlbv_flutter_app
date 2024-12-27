import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cart_controller.dart';
import 'cart_detail.dart';

class MainLayout extends StatefulWidget {
  final List<Widget> pages;
  final List<BottomNavigationBarItem> navItems;

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
    _pageController = PageController(initialPage: _currentIndex);
    Get.put(CartController()); // Khởi tạo CartController
    Get.find<CartController>().fetchCartItems(); // Lấy dữ liệu giỏ hàng
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Ứng dụng mua vé"),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(()=> CartDetailPage());// Hiển thị chi tiết giỏ hàng
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
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: widget.pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        items: widget.navItems,
      ),
    );
  }
}
