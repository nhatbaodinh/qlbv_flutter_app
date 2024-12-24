import 'package:get/get.dart';
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
  Future<void> addToCart(String ten, int gia, String anh) async {
    String currentUser = supabase.auth.currentUser?.email ?? "guest@gmail.com";
    final itemIndex = cart.indexWhere((item) => item.ten == ten);
    if (itemIndex >= 0) {
      // Nếu có, tăng số lượng
      cart[itemIndex].soluong += 1;
    } else {
      // Nếu chưa, thêm mới sản phẩm
      cart.add(CartItem(ten: ten, soluong: 1, gia: gia,anh: anh?? "https://via.placeholder.com/150", email: currentUser,ngaytao: DateTime.now()));
      final itemData={
        'tenSP':ten,
        'soLuong':1,
        'gia':gia,
        'anh':anh,
        'user_email':currentUser
      };
      await supabase.from('CartItem').insert(itemData);
    }
    update(['cart']);
  }
  void updateQuantity(int index, int newQuantity) {
    if (newQuantity > 0) {
      cart[index].soluong = newQuantity;
      update(['cart']); // Cập nhật UI
    }
  }
  void removeItem(int index) {
    cart.removeAt(index);
    update(['cart']);
  }
  void clearCart(){
    cart.clear();
    update(['cart']);
  }


  int get totalItems => cart.fold(0, (sum, item) => sum + item.soluong);
}
class CartBinding extends Bindings{

  @override
  void dependencies() {
    Get.put(CartController());
  }
}
