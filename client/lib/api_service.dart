import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080';

  static Future<List<Order>> getOrders() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        List<Order> orders =
            jsonList.map((json) => Order.fromJson(json)).toList();
        return orders;
      } else {
        throw Exception(
            'Failed to load orders. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      return [];
    }
  }

  static Future<void> deleteOrder(int id) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/orders/delete_order?id=$id'));

      if (response.statusCode == 200) {
        print("Success!");
      } else {
        throw Exception(
            'Failed to delete order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  static Future<void> skipOrder() async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/orders/skip_order'));

      if (response.statusCode == 200) {
        print("Success!");
      } else {
        throw Exception(
            'Failed to skip order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  static Future<void> updateOrderStatus(int id, String status) async {
    try {
      final response = await http.post(Uri.parse(
          '$baseUrl/orders/update_order_status?id=$id&status=$status'));

      if (response.statusCode == 200) {
        print("Success!");
      } else {
        throw Exception(
            'Failed to update order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  static Future<void> createNewOrder(Map<String, Object> body) async {
    try {
      final response = await http.post(
          Uri.parse('$baseUrl/orders/create_new_order'),
          body: json.encode(body));

      if (response.statusCode == 200) {
        print("Success!");
      } else {
        throw Exception(
            'Failed to save order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
