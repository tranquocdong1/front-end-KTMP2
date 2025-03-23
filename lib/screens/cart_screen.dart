import 'package:flutter/material.dart';
import 'package:front_end_ktpm2/services/auth_service.dart';
import 'package:front_end_ktpm2/services/cart_service.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> cartItems = [];
  double subtotal = 0.0;

  @override
  void initState() {
    super.initState();
    _checkLoginAndLoadCart();
  }

  Future<void> _checkLoginAndLoadCart() async {
    final userId = await AuthService.getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng đăng nhập để xem giỏ hàng')),
      );
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      loadCart();
    }
  }

  Future<void> loadCart() async {
    try {
      final response = await CartService.getCart();
      setState(() {
        cartItems = response['items'] ?? [];
        subtotal = double.tryParse(response['subtotal'].toString()) ?? 0.0;
      });
    } catch (e) {
      print('Lỗi khi tải giỏ hàng: $e');
    }
  }

  Future<void> removeItem(String? productId) async {
    if (productId == null || productId.isEmpty) {
      print('Không thể xóa sản phẩm: ID null hoặc rỗng');
      return;
    }
    try {
      print('Đang xóa sản phẩm có ID: $productId');
      final response = await CartService.removeFromCart(productId);
      if (response['success'] == false) {
        print('Lỗi khi xóa: ${response['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        return;
      }
      setState(() {
        cartItems = response['items'] ?? [];
        subtotal = double.tryParse(response['subtotal'].toString()) ?? 0.0;
      });
    } catch (e) {
      print('Exception khi xóa sản phẩm: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa sản phẩm')),
      );
    }
  }

  void updateQuantity(int index, int newQuantity) async {
    if (newQuantity < 1 || index >= cartItems.length || index < 0) return;

    setState(() {
      cartItems[index]['quantity'] = newQuantity;
      subtotal = cartItems.fold(0.0, (sum, item) {
        final price =
            double.tryParse(item['price']?.toString() ?? '0.0') ?? 0.0;
        return sum + (price * (item['quantity'] ?? 1));
      });
    });
    // TODO: Gọi API để cập nhật quantity trên server nếu cần
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Giỏ hàng của tôi")),
      body: cartItems.isEmpty
          ? Center(child: Text("Giỏ hàng trống"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: Image.network(
                            item['image'] ?? 'https://via.placeholder.com/150',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                  'Lỗi tải hình: $error, URL: ${item['image']}');
                              return Image.network(
                                'https://via.placeholder.com/150', // Hình ảnh mặc định
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                          title: Text(item['name'] ?? 'Sản phẩm'),
                          subtitle:
                              Text("\$${item['price'].toStringAsFixed(2)}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () =>
                                    updateQuantity(index, item['quantity'] - 1),
                              ),
                              Text("${item['quantity']}"),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () =>
                                    updateQuantity(index, item['quantity'] + 1),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  String? id = item['productId']?.toString();
                                  print('ID sản phẩm cần xóa: $id');
                                  if (id != null) {
                                    removeItem(id);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Không thể xóa: ID không hợp lệ')),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Tổng tiền: \$${subtotal.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
