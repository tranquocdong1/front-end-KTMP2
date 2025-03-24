import 'package:flutter/material.dart';
import 'package:front_end_ktpm2/screens/home_screen.dart';
import 'package:front_end_ktpm2/services/cart_service.dart';
import '../services/order_service.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<dynamic> cartItems = [];
  double subtotal = 0.0;
  double shipping = 10.99;
  bool isLoading = true;

  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();

  // Selected payment method
  String _selectedPayment = 'Credit Card';
  final List<String> _paymentMethods = [
    'Credit Card',
    'PayPal',
    'Apple Pay',
    'Google Pay'
  ];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  Future<void> loadCart() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await CartService.getCart();
      setState(() {
        cartItems = response['items'] ?? [];
        subtotal = double.tryParse(response['subtotal'].toString()) ?? 0.0;
        isLoading = false;
      });
    } catch (e) {
      print('Lỗi khi tải giỏ hàng: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  double get total => subtotal + shipping;

  Future<void> placeOrder() async {
  // Validate form
  if (_nameController.text.isEmpty ||
      _emailController.text.isEmpty ||
      _phoneController.text.isEmpty ||
      _addressController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
    );
    return;
  }

  // Show loading indicator
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(child: CircularProgressIndicator()),
  );

  try {
    final response = await OrderService.placeOrder(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      city: _cityController.text,
      zip: _zipController.text,
      paymentMethod: _selectedPayment,
    );

    // Close loading dialog
    Navigator.pop(context);

    // Show success and navigate to confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Đặt hàng thành công'),
        content: Text(response['message'] ?? 'Đơn hàng của bạn đã được xác nhận.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false,
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  } catch (e) {
    // Close loading dialog
    Navigator.pop(context);

    // Show error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xảy ra lỗi: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán'),
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Center(child: Text('Giỏ hàng trống'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order summary
                      Container(
                        color: Colors.grey[100],
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tóm tắt đơn hàng',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: cartItems.length,
                                itemBuilder: (context, index) {
                                  final item = cartItems[index];
                                  return Card(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Container(
                                      width: 120,
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: Image.network(
                                                item['image'] ??
                                                    'https://via.placeholder.com/150',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            item['name'] ?? 'Sản phẩm',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          Text(
                                            'SL: ${item['quantity']} x \$${item['price'].toStringAsFixed(2)}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[700]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Tạm tính'),
                                Text('\$${subtotal.toStringAsFixed(2)}'),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Phí vận chuyển'),
                                Text('\$${shipping.toStringAsFixed(2)}'),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tổng thanh toán',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '\$${total.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Shipping information
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thông tin giao hàng',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Họ và tên',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                labelText: 'Số điện thoại',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.phone),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                labelText: 'Địa chỉ',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.home),
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _cityController,
                                    decoration: InputDecoration(
                                      labelText: 'Thành phố',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _zipController,
                                    decoration: InputDecoration(
                                      labelText: 'Mã bưu điện',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Phương thức thanh toán',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                children: _paymentMethods.map((method) {
                                  return RadioListTile<String>(
                                    title: Text(method),
                                    value: method,
                                    groupValue: _selectedPayment,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedPayment = value!;
                                      });
                                    },
                                    secondary: _getPaymentIcon(method),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: placeOrder,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Đặt hàng',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _getPaymentIcon(String method) {
    switch (method) {
      case 'Credit Card':
        return Icon(Icons.credit_card);
      case 'PayPal':
        return Icon(Icons.payment);
      case 'Apple Pay':
        return Icon(Icons.apple);
      case 'Google Pay':
        return Icon(Icons.android);
      default:
        return Icon(Icons.payment);
    }
  }
}
