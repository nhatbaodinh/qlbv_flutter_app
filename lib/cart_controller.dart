import 'package:get/get.dart';
import 'package:qlbv_flutter_app/main.dart';
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
  Future<void> fetchCartItems() async {
    try {
      var currentUser = await getCurrentUserEmail();
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
      // Lấy email người dùng hiện tại
      var currentUser = await getCurrentUserEmail();
      print("Current User: $currentUser");

      // Truy vấn sản phẩm từ bảng `CartItem`
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
        // Nếu sản phẩm chưa tồn tại, thêm mới vào bảng và giỏ hàng
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

        // Thêm vào danh sách giỏ hàng (UI)
        cart.add(newItem);
      }

      // Cập nhật UI
      update(['cart']);
    } catch (e) {
      print("Error in addToCart: $e");
    }
  }

  Future<void> updateQuantity(int index, int newQuantity) async {
    if (newQuantity > 0) {
      try {
        // Lấy email người dùng hiện tại
        var currentUser = await getCurrentUserEmail();

        // Lấy thông tin sản phẩm cần cập nhật từ giỏ hàng
        final cartItem = cart[index];

        // Cập nhật số lượng trong bảng CartItem
        await supabase
            .from('CartItem')
            .update({'soLuong': newQuantity})
            .eq('tenSP', cartItem.ten)
            .eq('user_email', currentUser);

        // Cập nhật số lượng trong danh sách giỏ hàng (UI)
        cart[index].soluong = newQuantity;

        // Cập nhật UI
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
      // Lấy email người dùng hiện tại
      var currentUser = await getCurrentUserEmail();

      // Lấy thông tin sản phẩm cần xóa
      final cartItem = cart[index];

      // Xóa sản phẩm khỏi bảng CartItem trên Supabase
      await supabase
          .from('CartItem')
          .delete()
          .eq('tenSP', cartItem.ten)
          .eq('user_email', currentUser);

      // Xóa sản phẩm khỏi danh sách giỏ hàng (UI)
      cart.removeAt(index);

      // Cập nhật UI
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
      // Lấy email người dùng hiện tại
      var currentUser = await getCurrentUserEmail();

      // Xóa toàn bộ sản phẩm thuộc người dùng hiện tại trong bảng CartItem
      await supabase
          .from('CartItem')
          .delete()
          .eq('user_email', currentUser);

      // Xóa toàn bộ sản phẩm khỏi danh sách giỏ hàng (UI)
      cart.clear();

      // Cập nhật UI
      update(['cart']);
    } catch (e) {
      print("Error clearing cart after payment: $e");
    }
  }


  Future<int> fetchTotalItems() async {
    try {
      // Lấy email người dùng hiện tại
      var currentUser = await getCurrentUserEmail();

      // Truy vấn tất cả sản phẩm thuộc email người dùng
      final List<dynamic> response = await supabase
          .from('CartItem')
          .select('soLuong')
          .eq('user_email', currentUser);

      // Tính tổng số lượng sản phẩm
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
