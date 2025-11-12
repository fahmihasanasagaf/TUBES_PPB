import '../models/product_model.dart';

class ProductData {
  static List<Product> getAllProducts() {
    return [
      // KURSI (2 produk)
      Product(
        name: 'Kursi Goyang',
        price: 'Rp.1.450.000',
        image: 'assets/images/dan1.jpg',
        description: 'Kursi goyang klasik dengan desain timeless yang cocok untuk ruang santai. Terbuat dari kayu jati solid dengan mekanisme goyang yang halus dan nyaman.',
        specifications: [
          'Bahan: Kayu Jati Solid Premium',
          'Dimensi: 68cm x 92cm x 108cm',
          'Kapasitas: Hingga 140kg',
          'Finishing: Natural Wood Stain',
        ],
        material: [
          'Kayu jati pilihan grade A',
          'Busa high density premium',
          'Mekanisme goyang yang smooth',
          'Kaki kayu solid dengan reinforcement',
        ],
      ),
      Product(
        name: 'Kursi Santai',
        price: 'Rp.750.000',
        image: 'assets/images/dan2.jpg',
        description: 'Kursi santai ergonomis dengan desain modern dan material yang nyaman. Perfect untuk corner reading, ruang tamu, atau area relaksasi di rumah.',
        specifications: [
          'Bahan: Fabric Premium + Rangka Kayu',
          'Dimensi: 72cm x 78cm x 88cm',
          'Kapasitas: 110kg',
          'Warna: Dark Grey/Beige',
        ],
        material: [
          'Fabric premium anti-stain',
          'Busa memory foam medium firm',
          'Rangka kayu maple reinforced',
          'Kaki kayu dengan rubber feet',
        ],
      ),

      // RANJANG (2 produk)
      Product(
        name: 'Ranjang Susun Tingkat',
        price: 'Rp.2.850.000',
        image: 'assets/images/dan3.jpg',
        description: 'Ranjang susun tingkat praktis dengan desain modern yang hemat space. Cocok untuk kamar anak, guest room, atau apartemen dengan space terbatas.',
        specifications: [
          'Bahan: Kayu Solid + Metal',
          'Dimensi: 100cm x 200cm x 160cm',
          'Kapasitas: 2 tempat tidur',
          'Include: Tangga dan safety rail',
        ],
        material: [
          'Kayu solid dengan metal reinforcement',
          'Safety rail pada bagian atas',
          'Tangga yang kokoh dan aman',
          'Slat system untuk mattress support',
        ],
      ),
      Product(
        name: 'Ranjang Modern',
        price: 'Rp.3.950.000',
        image: 'assets/images/dan4.jpg',
        description: 'Ranjang modern minimalis dengan headboard yang elegant dan desain low-profile. Cocok untuk kamar tidur utama dengan gaya kontemporer.',
        specifications: [
          'Bahan: Fabric Headboard + Kayu Solid',
          'Dimensi: 160cm x 200cm',
          'Ukuran: Queen Size',
          'Style: Modern Minimalist',
        ],
        material: [
          'Headboard fabric premium dengan padding',
          'Rangka kayu oak solid',
          'Low-profile design',
          'Center support reinforcement',
        ],
      ),

      // LACI (2 produk)
      Product(
        name: 'Laci Modern Retro',
        price: 'Rp.1.350.000',
        image: 'assets/images/dan5.jpg',
        description: 'Laci dengan gaya modern retro yang unique dan artistic. Kombinasi warna yang bold dengan handle karakter yang menjadi focal point.',
        specifications: [
          'Bahan: MDF + Kayu Solid',
          'Dimensi: 85cm x 45cm x 90cm',
          'Jumlah Laci: 5 drawers',
          'Style: Modern Retro Vintage',
        ],
        material: [
          'MDF premium dengan finishing khusus',
          'Drawer slides soft-close',
          'Handle karakter retro',
          'Kaki kayu dengan metal accent',
        ],
      ),
      Product(
        name: 'Buffet Jati Laci',
        price: 'Rp.2.650.000',
        image: 'assets/images/dan6.jpg',
        description: 'Buffet serbaguna dari kayu jati asli dengan kombinasi laci dan pintu. Cocok untuk dining room, living room, atau sebagai storage cabinet.',
        specifications: [
          'Bahan: Kayu Jati Solid',
          'Dimensi: 120cm x 45cm x 85cm',
          'Kombinasi: 3 laci + 2 pintu',
          'Finishing: Dark Teak',
        ],
        material: [
          'Kayu jati solid 100%',
          'Engsel dan slide premium',
          'Finishing natural oil protection',
          'Adjustable shelves',
        ],
      ),

      // SOFA (2 produk)
      Product(
        name: 'Sofa Metal Feet',
        price: 'Rp.2.950.000',
        image: 'assets/images/dan7.jpg',
        description: 'Sofa modern dengan metal feet yang elegant dan desain clean lines. Kombinasi antara kekuatan metal dan kenyamanan fabric premium.',
        specifications: [
          'Bahan: Linen Fabric + Metal Frame',
          'Dimensi: 185cm x 88cm x 78cm',
          'Kapasitas: 3 seater',
          'Kaki: Chrome Metal Feet',
        ],
        material: [
          'Linen fabric premium anti-stain',
          'Metal feet chrome finishing',
          'High resilience foam',
          'Solid wood frame internal',
        ],
      ),
      Product(
        name: 'Lorenz Seater Sofa',
        price: 'Rp.4.250.000',
        image: 'assets/images/dan8.jpg',
        description: 'Sofa premium "Lorenz" dengan desain luxurious dan kenyamanan maksimal. Perfect untuk ruang tamu utama yang mengutamakan style dan comfort.',
        specifications: [
          'Bahan: Premium Chenille Fabric',
          'Dimensi: 210cm x 95cm x 82cm',
          'Kapasitas: 3-4 seater',
          'Include: 6 throw pillows',
        ],
        material: [
          'Chenille fabric luxury grade',
          'Pocket spring + foam hybrid system',
          'Solid hardwood frame',
          'Premium feather filled pillows',
        ],
      ),
    ];
  }

  // Method untuk mendapatkan produk berdasarkan kategori
  static List<Product> getProductsByCategory(String category) {
    final allProducts = getAllProducts();
    
    switch (category.toLowerCase()) {
      case 'kursi':
        return allProducts.where((p) => 
          p.name.toLowerCase().contains('kursi')
        ).toList();
      case 'sofa':
        return allProducts.where((p) => 
          p.name.toLowerCase().contains('sofa')
        ).toList();
      case 'meja':
        return allProducts.where((p) => 
          p.name.toLowerCase().contains('meja') ||
          p.name.toLowerCase().contains('buffet')
        ).toList();
      case 'ranjang':
        return allProducts.where((p) => 
          p.name.toLowerCase().contains('ranjang')
        ).toList();
      case 'laci':
        return allProducts.where((p) => 
          p.name.toLowerCase().contains('laci') ||
          p.name.toLowerCase().contains('buffet')
        ).toList();
      default:
        return allProducts;
    }
  }
}