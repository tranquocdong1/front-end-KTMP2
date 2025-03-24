import 'package:flutter/material.dart';
import 'package:front_end_ktpm2/services/order_service.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<dynamic> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrderHistory();
  }

  Future<void> loadOrderHistory() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedOrders = await OrderService.getOrderHistory();
      setState(() {
        orders = fetchedOrders;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử đơn hàng'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? Center(child: Text('Không có đơn hàng nào'))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text('Đơn hàng #${order['_id']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tổng tiền: \$${order['totalPrice']}'),
                            Text('Trạng thái: ${order['status']}'),
                            Text('Ngày: ${order['createdAt']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}