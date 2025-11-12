class Product {
  final String name;
  final String price;
  final String image;
  final String description;
  final List<String> specifications;
  final List<String>? material;

  // Legacy properties untuk kompatibilitas dengan kode lama
  String get specification1 => specifications.isNotEmpty ? specifications[0] : '';
  String get specification2 => specifications.length > 1 ? specifications[1] : '';
  String get specification3 => specifications.length > 2 ? specifications[2] : '';

  Product({
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.specifications,
    this.material,
  });

  // Factory constructor untuk parsing dari JSON jika diperlukan
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      specifications: List<String>.from(json['specifications'] ?? []),
      material: json['material'] != null 
          ? List<String>.from(json['material']) 
          : null,
    );
  }

  // Method untuk convert ke JSON jika diperlukan
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'image': image,
      'description': description,
      'specifications': specifications,
      'material': material,
    };
  }
}