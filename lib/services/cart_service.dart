import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front_end_ktpm2/services/auth_service.dart';

class CartService {
  static const String baseUrl = 'https://back-end-ktpm2.onrender.com';
  static const int timeoutSeconds = 10;

  // Lấy header với userId
  static Future<Map<String, String>> _getHeaders() async {
    final userId = await AuthService.getUserId();
    print('Sending X-User-Id: $userId');
    return {
      'Content-Type': 'application/json',
      if (userId != null) 'X-User-Id': userId, // Gửi userId qua header
    };
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        jsonData['items'] ??= [];
        jsonData['subtotal'] ??= "0.00";
        jsonData['count'] ??= 0;
        return jsonData;
      } catch (e) {
        print('Lỗi khi parse JSON: $e');
        return {'items': [], 'subtotal': "0.00", 'count': 0, 'error': 'Lỗi parse dữ liệu'};
      }
    } else {
      print('Lỗi API: ${response.statusCode} - ${response.body}');
      throw Exception('Lỗi API: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> getCart() async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .get(Uri.parse('$baseUrl/api/cart'), headers: headers)
          .timeout(Duration(seconds: timeoutSeconds));

      if (response.body.isEmpty) {
        print('Phản hồi rỗng từ server');
        return {'items': [], 'subtotal': "0.00", 'count': 0};
      }
      return _handleResponse(response);
    } catch (e) {
      print('Lỗi khi tải giỏ hàng: $e');
      return {'items': [], 'subtotal': "0.00", 'count': 0, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> addToCart(String? productId, int quantity) async {
    try {
      if (productId == null || productId.isEmpty) {
        return {'message': 'ID sản phẩm không hợp lệ', 'success': false};
      }
      final headers = await _getHeaders();
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/add-to-cart'),
            headers: headers,
            body: jsonEncode({'productId': productId, 'quantity': quantity}),
          )
          .timeout(Duration(seconds: timeoutSeconds));
      return _handleResponse(response);
    } catch (e) {
      print('Lỗi khi thêm sản phẩm vào giỏ hàng: $e');
      return {'message': 'Lỗi khi thêm sản phẩm: $e', 'success': false};
    }
  }

  static Future<Map<String, dynamic>> removeFromCart(String? productId) async {
    try {
      if (productId == null || productId.isEmpty) {
        print('Lỗi: productId bị null hoặc rỗng');
        return {
          'message': 'ID sản phẩm không hợp lệ',
          'success': false,
          'items': [],
          'subtotal': "0.00"
        };
      }
      final headers = await _getHeaders();
      print('Đang xóa sản phẩm với ID: $productId');
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/remove-from-cart'),
            headers: headers,
            body: jsonEncode({'productId': productId}),
          )
          .timeout(Duration(seconds: timeoutSeconds));
      print('Phản hồi từ server khi xóa: ${response.statusCode} - ${response.body}');
      final result = _handleResponse(response);
      if (!result.containsKey('items')) {
        print('Server không trả về items, lấy giỏ hàng lại');
        return await getCart();
      }
      return result;
    } catch (e) {
      print('Lỗi khi xóa sản phẩm khỏi giỏ hàng: $e');
      return {
        'message': 'Lỗi khi xóa sản phẩm: $e',
        'success': false,
        'items': [],
        'subtotal': "0.00"
      };
    }
  }

  // Phương thức mới để cập nhật số lượng sản phẩm trong giỏ hàng
  static Future<Map<String, dynamic>> updateCartQuantity(String? productId, int quantity) async {
    try {
      if (productId == null || productId.isEmpty) {
        print('Lỗi: productId bị null hoặc rỗng');
        return {
          'message': 'ID sản phẩm không hợp lệ',
          'success': false,
          'items': [],
          'subtotal': "0.00"
        };
      }
      
      if (quantity < 1) {
        print('Lỗi: Số lượng phải lớn hơn 0');
        return {
          'message': 'Số lượng không hợp lệ',
          'success': false,
          'items': [],
          'subtotal': "0.00"
        };
      }
      
      final headers = await _getHeaders();
      print('Đang cập nhật số lượng sản phẩm với ID: $productId, số lượng: $quantity');
      
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/update-cart-quantity'),
            headers: headers,
            body: jsonEncode({'productId': productId, 'quantity': quantity}),
          )
          .timeout(Duration(seconds: timeoutSeconds));
          
      print('Phản hồi từ server khi cập nhật số lượng: ${response.statusCode} - ${response.body}');
      
      final result = _handleResponse(response);
      if (!result.containsKey('items')) {
        print('Server không trả về items, lấy giỏ hàng lại');
        return await getCart();
      }
      return result;
    } catch (e) {
      print('Lỗi khi cập nhật số lượng sản phẩm trong giỏ hàng: $e');
      return {
        'message': 'Lỗi khi cập nhật số lượng: $e',
        'success': false,
        'items': [],
        'subtotal': "0.00"
      };
    }
  }
}