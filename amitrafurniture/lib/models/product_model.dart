class Product {
  final String id;
  final String name;
  final String price;
  final String image;
  final String description;
  final List<String> specifications;
  final List<String>? material;
  final int stock;

  String get specification1 =>
      specifications.isNotEmpty ? specifications[0] : '';
  String get specification2 =>
      specifications.length > 1 ? specifications[1] : '';
  String get specification3 =>
      specifications.length > 2 ? specifications[2] : '';

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.specifications,
    this.material,
    this.stock = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Handle price - bisa string atau number dari Supabase
    String priceStr;
    if (json['price'] is num) {
      priceStr = 'Rp.${json['price']}';
    } else {
      priceStr = json['price']?.toString() ?? '';
    }

    // Handle specifications - bisa dari JSONB atau list
    List<String> specs = [];
    if (json['specifications'] != null) {
      if (json['specifications'] is List) {
        specs = List<String>.from(json['specifications']);
      }
    }

    // Handle materials - bisa dari JSONB atau list
    List<String>? mats;
    if (json['materials'] != null || json['material'] != null) {
      final matData = json['materials'] ?? json['material'];
      if (matData is List) {
        mats = List<String>.from(matData);
      }
    }

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: priceStr,
      image: json['image_url'] ?? json['image'] ?? '',
      description: json['description'] ?? '',
      specifications: specs,
      material: mats,
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'description': description,
      'specifications': specifications,
      'material': material,
      'stock': stock,
    };
  }
}
