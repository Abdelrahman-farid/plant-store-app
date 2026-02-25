import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project1/models/order_model.dart';

class OrderService {
  static const String _ordersKey = 'user_orders';

  // Get user-specific key for orders
  static String _getUserOrdersKey() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return '${user.uid}_$_ordersKey';
    }
    return 'guest_$_ordersKey';
  }

  static Future<void> saveOrders(List<OrderModel> orders) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(
        orders.map((order) => order.toMap()).toList(),
      );
      await prefs.setString(_getUserOrdersKey(), jsonString);
    } catch (e) {
      print('Error saving orders: $e');
    }
  }

  static Future<List<OrderModel>> loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_getUserOrdersKey());

      if (jsonString == null) {
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((item) => OrderModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading orders: $e');
      return [];
    }
  }

  static Future<void> addOrder(OrderModel order) async {
    final orders = await loadOrders();
    orders.insert(0, order); // Add new order at the beginning
    await saveOrders(orders);
  }

  static Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final orders = await loadOrders();
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      orders[index] = orders[index].copyWith(status: newStatus);
      await saveOrders(orders);
    }
  }

  static Future<void> deleteOrder(String orderId) async {
    final orders = await loadOrders();
    orders.removeWhere((o) => o.id == orderId);
    await saveOrders(orders);
  }
}
