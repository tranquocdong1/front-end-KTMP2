import 'package:dio/dio.dart';
import 'package:front_end_ktpm2/services/auth_service.dart'; // Import AuthService

class OrderService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: "https://back-end-ktpm2.onrender.com")); // Thay bằng URL server thực tế

  // Đặt hàng
  static Future<Map<String, dynamic>> placeOrder({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String zip,
    required String paymentMethod,
  }) async {
    final userId = await AuthService.getUserId(); // Lấy userId từ SharedPreferences
    if (userId == null) {
      throw Exception('Vui lòng đăng nhập để tiếp tục');
    }

    try {
      final response = await _dio.post(
        "/place-order",
        options: Options(headers: {'x-user-id': userId}), // Gửi userId qua header
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'address': address,
          'city': city,
          'zip': zip,
          'paymentMethod': paymentMethod,
        },
      );
      return response.data;
    } catch (e) {
      print('Lỗi khi đặt hàng: $e');
      throw Exception('Lỗi khi đặt hàng: $e');
    }
  }

  // Lấy lịch sử đơn hàng
  static Future<List<dynamic>> getOrderHistory() async {
    final userId = await AuthService.getUserId();
    if (userId == null) {
      throw Exception('Vui lòng đăng nhập để tiếp tục');
    }

    try {
      final response = await _dio.get(
        "/order-history/json", // Gọi endpoint mới
        options: Options(headers: {'x-user-id': userId}),
      );

      if (response.data['success'] == true) {
        return response.data['orders']; // Trả về danh sách orders
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      print('Lỗi khi tải lịch sử đơn hàng: $e');
      throw Exception('Lỗi khi tải lịch sử đơn hàng: $e');
    }
  }
}