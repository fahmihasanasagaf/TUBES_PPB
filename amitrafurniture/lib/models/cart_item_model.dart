import 'product_model.dart';

class CartItemModel {
  final String id;
  final Product product;
  final int quantity;

  CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id']?.toString() ?? '',
      product: Product.fromJson(json['products'] ?? {}),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
    };
  }
}
