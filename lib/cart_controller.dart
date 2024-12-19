import 'package:get/get.dart';

class CartItem {
  String ten;
  int soluong;
  int gia;
  String? anh;

  CartItem({
    required this.ten,
    required this.soluong,
    required this.gia,
    this.anh,
  });
}

class CartController extends GetxController {
  final cart = <CartItem>[].obs;

  void addToCart(String ten, int gia, String anh) {
    // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
    final itemIndex = cart.indexWhere((item) => item.ten == ten);
    if (itemIndex >= 0) {
      // Nếu có, tăng số lượng
      cart[itemIndex].soluong += 1;
    } else {
      // Nếu chưa, thêm mới sản phẩm
      cart.add(CartItem(ten: ten, soluong: 1, gia: gia,anh: anh?? "https://via.placeholder.com/150"));
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


  int get totalItems => cart.fold(0, (sum, item) => sum + item.soluong);
}
class CartBinding extends Bindings{

  @override
  void dependencies() {
    Get.put(CartController());
  }
}
