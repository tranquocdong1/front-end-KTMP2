import 'package:flutter/material.dart';
import 'package:front_end_ktpm2/services/flowers_service.dart';
import 'package:front_end_ktpm2/services/cart_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  ProductDetailScreen({required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map<String, dynamic> product = {};
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  Future<void> _loadProductDetails() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final productDetails = await FlowersService.getProductDetail(widget.productId);

      setState(() {
        product = productDetails;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Không thể tải chi tiết sản phẩm: $e';
      });
      print('Lỗi khi tải chi tiết sản phẩm: $e');
    }
  }

  Future<void> _addToCart() async {
    try {
      final response = await CartService.addToCart(widget.productId, 1); // Giữ số lượng mặc định là 1
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã thêm vào giỏ hàng')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể thêm vào giỏ hàng')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
      print('Lỗi khi thêm vào giỏ hàng: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết sản phẩm'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hình ảnh sản phẩm
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.network(
                            product['image'] ?? 'https://via.placeholder.com/400',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              print('Lỗi tải hình: $error');
                              return Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 120,
                                  color: Colors.grey,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Tên sản phẩm
                      Text(
                        product['name'] ?? 'Sản phẩm',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),

                      // Giá sản phẩm
                      Text(
                        '\$${(product['price'] ?? 0).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Mô tả sản phẩm
                      Text(
                        'Mô tả:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        product['description'] ?? 'Không có mô tả.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 24),

                      // Nút thêm vào giỏ hàng
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _addToCart,
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text(
                            'Thêm vào giỏ hàng',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}