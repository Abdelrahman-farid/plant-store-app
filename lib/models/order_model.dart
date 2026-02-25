class OrderModel {
  final String id;
  final DateTime orderDate;
  final double totalAmount;
  final String deliveryAddress;
  final String paymentMethod;
  final List<OrderItem> items;
  final String status; // 'pending', 'processing', 'delivered', 'cancelled'

  const OrderModel({
    required this.id,
    required this.orderDate,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.items,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderDate': orderDate.toIso8601String(),
      'totalAmount': totalAmount,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'items': items.map((item) => item.toMap()).toList(),
      'status': status,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      orderDate: DateTime.parse(map['orderDate']),
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      deliveryAddress: map['deliveryAddress'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      items: (map['items'] as List<dynamic>)
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      status: map['status'] ?? 'pending',
    );
  }

  OrderModel copyWith({
    String? id,
    DateTime? orderDate,
    double? totalAmount,
    String? deliveryAddress,
    String? paymentMethod,
    List<OrderItem>? items,
    String? status,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderDate: orderDate ?? this.orderDate,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      items: items ?? this.items,
      status: status ?? this.status,
    );
  }
}

class OrderItem {
  final String plantId;
  final String plantName;
  final String plantImage;
  final double price;
  final int quantity;

  const OrderItem({
    required this.plantId,
    required this.plantName,
    required this.plantImage,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'plantId': plantId,
      'plantName': plantName,
      'plantImage': plantImage,
      'price': price,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      plantId: map['plantId'] ?? '',
      plantName: map['plantName'] ?? '',
      plantImage: map['plantImage'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: (map['quantity'] ?? 1).toInt(),
    );
  }
}
