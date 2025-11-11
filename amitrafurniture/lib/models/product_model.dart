class Product {
  final int id;
  final String name;
  final String price;
  final String image;
  final String description;
  final List<String> specifications;
  final List<String>? material;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.specifications,
    this.material,
  });
}