import 'dart:convert';

import 'package:http/http.dart' as http;

class FlowersService {
  static const String baseUrl = 'http://localhost:3000';
  static const int timeoutSeconds = 10;

  // Xử lý phản hồi API
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        if (response.body.isEmpty) {
          return [];
        }
        return jsonDecode(response.body);
      } catch (e) {
        print('Lỗi khi parse JSON: $e');
        throw Exception('Lỗi khi xử lý dữ liệu: $e');
      }
    } else {
      print('Lỗi API: ${response.statusCode} - ${response.body}');
      throw Exception('Lỗi API: ${response.statusCode}');
    }
  }

  // Lấy danh sách sản phẩm
  static Future<List<dynamic>> getProducts() async {
    try {
      // ignore: unused_local_variable
      final response = await http
          .get(Uri.parse('$baseUrl/'))
          .timeout(Duration(seconds: timeoutSeconds));


      // Xử lý dữ liệu từ server Express
      // Chú ý: Vì server Express render view, chúng ta cần API JSON riêng
      // Trong trường hợp này, giả định server cung cấp API /api/products
      final apiResponse = await http
          .get(Uri.parse('$baseUrl/api/products'))
          .timeout(Duration(seconds: timeoutSeconds));

      final data = _handleResponse(apiResponse);
      return data is List ? data : [];
    } catch (e) {
      print('Lỗi khi tải sản phẩm: $e');
      throw Exception('Không thể tải sản phẩm: $e');
    }
  }

  // Lấy chi tiết sản phẩm
  static Future<Map<String, dynamic>> getProductDetail(String productId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/product/$productId'))
          .timeout(Duration(seconds: timeoutSeconds));

      final data = _handleResponse(response);
      return data is Map<String, dynamic> ? data : {};
    } catch (e) {
      print('Lỗi khi tải chi tiết sản phẩm: $e');
      throw Exception('Không thể tải chi tiết sản phẩm: $e');
    }
  }

  // Thêm sản phẩm vào giỏ hàng
  static Future<Map<String, dynamic>> addToCart(
      String productId, int quantity) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/add-to-cart'), // Thay đổi endpoint này
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'productId': productId, 'quantity': quantity}),
          )
          .timeout(Duration(seconds: timeoutSeconds));

      final data = _handleResponse(response);
      return data is Map<String, dynamic> ? data : {'success': false};
    } catch (e) {
      print('Lỗi khi thêm sản phẩm vào giỏ hàng: $e');
      return {'success': false, 'message': 'Lỗi khi thêm sản phẩm: $e'};
    }
  }

  // Thêm sản phẩm mới (cho admin)
  static Future<Map<String, dynamic>> addProduct(
      Map<String, dynamic> productData) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/add'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(productData),
          )
          .timeout(Duration(seconds: timeoutSeconds));

      final data = _handleResponse(response);
      return data is Map<String, dynamic> ? data : {'success': false};
    } catch (e) {
      print('Lỗi khi thêm sản phẩm mới: $e');
      return {'success': false, 'message': 'Lỗi khi thêm sản phẩm mới: $e'};
    }
  }
}