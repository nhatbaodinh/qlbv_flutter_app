import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:qlbv_flutter_app/home_page.dart';
import 'package:qlbv_flutter_app/main.dart';
import 'package:qlbv_flutter_app/products_page.dart';
import 'package:qlbv_flutter_app/user_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cart_controller.dart';
import 'cart_detail.dart';
import 'login_page.dart'; // Đảm bảo import file login_page.dart

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
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

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

  // Function to logout user
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    final CartController cartController = Get.find<CartController>();
    await prefs.clear(); // Clear all data in SharedPreferences
    cartController.clearCart(); // Clear the cart
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainLayout(
          pages: [
            HomePage(),
            ProductsPage(),
            LoginPage(),
          ],
          navItems: [
            BottomNavigationBarItem(
              label: "Trang chủ",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Sản phẩm",
              icon: Icon(Icons.shopping_cart),
            ),
            BottomNavigationBarItem(
              label: "Tôi",
              icon: Icon(Icons.login),
            ),
          ],
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ứng dụng mua vé"),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => CartDetailPage()); // Hiển thị chi tiết giỏ hàng
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
          GestureDetector(
            onTap: () {
              // Show logout confirmation modal
              _showLogoutModal();
            },
            child: const Icon(Icons.account_circle),
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

  // Function to show logout modal
  void _showLogoutModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đăng Xuất'),
          content: const Text('Bạn có chắc muốn đăng xuất không?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the modal without logging out
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Perform logout and navigate to login page
                _logout();
              },
              child: const Text('Đăng Xuất'),
            ),
          ],
        );
      },
    );
  }
}
