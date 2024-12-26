import 'package:get/get.dart';
import 'package:qlbv_flutter_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartItem {
  String ten;
  int soluong;
  int gia;
  String? anh;
  DateTime ngaytao;
  String email;

  CartItem({
    required this.ten,
    required this.soluong,
    required this.gia,
    this.anh,
    required this.ngaytao,
    required this.email,
  });
}

class CartController extends GetxController {
  final cart = <CartItem>[].obs;
  final supabase = Supabase.instance.client;

  Future<String> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail') ?? 'guest@gmail.com'; // Default to guest if not found
  }

  Future<void> fetchCartItems() async {
    try {
      var currentUser = await getCurrentUserEmail();
      print(currentUser);
      final response = await supabase
          .from('CartItem')
          .select('soLuong, tenSP, gia, anh, created_at, user_email')
          .eq('user_email', currentUser);

      if (response != null) {
        cart.clear(); // Xóa giỏ hàng hiện tại để đồng bộ hóa lại
        for (var item in response) {
          cart.add(CartItem(
            ten: item['tenSP'],
            soluong: item['soLuong'],
            gia: item['gia'],
            anh: item['anh'],
            ngaytao: DateTime.parse(item['created_at']),
            email: item['user_email'],
          ));
        }
        update(); // Cập nhật UI sau khi tải lại giỏ hàng
      }
    } catch (e) {
      print("Error fetching cart items: $e");
    }
  }

  Future<void> addToCart(String ten, int gia, String anh) async {
    try {
      var currentUser = await getCurrentUserEmail();  // Await the value here

      final response = await supabase
          .from('CartItem')
          .select('id, soLuong')
          .eq('tenSP', ten)
          .eq('user_email', currentUser)
          .maybeSingle();

      if (response != null) {
        int currentQuantity = response['soLuong'] as int;
        int updatedQuantity = currentQuantity + 1;
        await supabase
            .from('CartItem')
            .update({'soLuong': updatedQuantity})
            .eq('tenSP', ten);

        final itemIndex = cart.indexWhere((item) => item.ten == ten);
        if (itemIndex >= 0) {
          cart[itemIndex].soluong = updatedQuantity;
        }
      } else {
        final newItem = CartItem(
          ten: ten,
          soluong: 1,
          gia: gia,
          anh: anh,
          ngaytao: DateTime.now(),
          email: currentUser,
        );

        await supabase.from('CartItem').insert({
          'tenSP': ten,
          'soLuong': 1,
          'gia': gia,
          'anh': anh,
          'user_email': currentUser,
        });

        cart.add(newItem);
      }

      update(['cart']);
    } catch (e) {
      print("Error in addToCart: $e");
    }
  }

  Future<void> updateQuantity(int index, int newQuantity) async {
    if (newQuantity > 0) {
      try {
        var currentUser = await getCurrentUserEmail();  // Await the value here

        final cartItem = cart[index];

        await supabase
            .from('CartItem')
            .update({'soLuong': newQuantity})
            .eq('tenSP', cartItem.ten)
            .eq('user_email', currentUser);

        cart[index].soluong = newQuantity;
        update(['cart']);
      } catch (e) {
        print("Error updating quantity: $e");
      }
    } else {
      print("New quantity must be greater than 0");
    }
  }

  Future<void> removeItem(int index) async {
    try {
      var currentUser = await getCurrentUserEmail();  // Await the value here

      final cartItem = cart[index];

      await supabase
          .from('CartItem')
          .delete()
          .eq('tenSP', cartItem.ten)
          .eq('user_email', currentUser);

      cart.removeAt(index);
      update(['cart']);
    } catch (e) {
      print("Error removing item: $e");
    }
  }

  void clearCart() {
    cart.clear();
    update();
  }

  Future<void> clearCartafterPay() async {
    try {
      var currentUser = await getCurrentUserEmail();  // Await the value here
      await supabase
          .from('CartItem')
          .delete()
          .eq('user_email', currentUser);

      cart.clear();
      update(['cart']);
    } catch (e) {
      print("Error clearing cart after payment: $e");
    }
  }

  Future<int> fetchTotalItems() async {
    try {
      var currentUser = await getCurrentUserEmail();  // Await the value here

      final List<dynamic> response = await supabase
          .from('CartItem')
          .select('soLuong')
          .eq('user_email', currentUser);

      final total = response.fold<int>(0, (sum, item) => sum + (item['soLuong'] as int));
      return total;
    } catch (e) {
      print("Error fetching totalItems: $e");
      return 0;
    }
  }

  int get totalItems => cart.fold(0, (sum, item) => sum + item.soluong);
}

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CartController());
  }
}
