import 'package:flutter/material.dart';
import 'package:front_end_ktpm2/services/flowers_service.dart';

class FlowersScreen extends StatefulWidget {
  @override
  _FlowersScreenState createState() => _FlowersScreenState();
}

class _FlowersScreenState extends State<FlowersScreen> {
  List<dynamic> products = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final fetchedProducts = await FlowersService.getProducts();

      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Không thể tải sản phẩm: $e';
      });
      print('Lỗi khi tải sản phẩm: $e');
    }
  }

  void navigateToProductDetail(String productId) {
    Navigator.pushNamed(
      context,
      '/product-detail',
      arguments: productId,
    );
  }

  Future<void> addToCart(String productId) async {
    try {
      final response = await FlowersService.addToCart(productId, 1);
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể thêm vào giỏ hàng')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã thêm vào giỏ hàng')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cửa hàng hoa"),
        actions: [
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : products.isEmpty
                  ? Center(child: Text('Không có sản phẩm nào'))
                  : GridView.builder(
                      padding: EdgeInsets.all(10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          elevation: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      navigateToProductDetail(product['_id']),
                                  child: Container(
                                    width: double.infinity,
                                    child: Image.network(
                                      product['image'] ??
                                          'https://via.placeholder.com/150',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        print('Lỗi tải hình: $error');
                                        return Icon(Icons.image_not_supported,
                                            size: 80);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'] ?? 'Sản phẩm',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '\$${(product['price'] ?? 0).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () =>
                                          addToCart(product['_id']),
                                      child: Text('Thêm vào giỏ'),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(double.infinity, 36),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => loadProducts(),
        child: Icon(Icons.refresh),
        tooltip: 'Làm mới',
      ),
    );
  }
}
