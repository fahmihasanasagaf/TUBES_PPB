class CartItem {
  final String id;
  final String name;
  final int price;
  int quantity;
  bool isSelected;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.isSelected,
    required this.imageUrl,
  });
}
