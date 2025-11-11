import '../models/product_model.dart';

class ProductData {
  static final List<Product> products = [
    Product(
      id: 1,
      name: 'Laci Meja Kayu',
      price: 'Rp.600.000',
      image: 'assets/images/Lemari.png',
      description: 'Laci meja kayu ini memiliki desain minimalis dengan sentuhan modern, cocok untuk semua jenis ruangan. Dilengkapi dengan tiga laci berukuran besar yang dapat menampung berbagai keperluan kantor maupun rumah. Terbuat dari kayu berkualitas tinggi dengan finishing yang halus dan rapi. Dilengkapi dengan roda yang memudahkan untuk dipindahkan sesuai kebutuhan.',
      specifications: [
        'Bahan Produk: Kayu Meja Kayu',
        'Jumlah laci: 3 laci (kapasitas menyesuaikan dengan finishing material)',
        'Dilengkapi dengan roda untuk mobilitas tinggi',
        'Ukuran: Panjang 50 cm x Lebar 40 cm x Tinggi 60 cm',
        'Laci bisa diatur lebar dan kedalaman sesuai kebutuhan',
      ],
      material: [
        'Material kayu solid dengan sistem struktur modern',
        'Biji kayu tidak dihaluskan sehingga mempertahankan tekstur alami',
        'Permukaan anti cacat digunakan untuk ketahanan jangka panjang',
        'Mudah dibersihkan',
        'Finishing berkualitas tinggi dengan detail sempurna',
      ],
    ),
    Product(
      id: 2,
      name: 'Kursi Kayu Jati',
      price: 'Rp.400.000',
      image: 'assets/images/Kursi.png',
      description: 'Kursi Kayu Jati Elegant adalah kursi yang dirancang dengan desain minimalis dan berkarakter tinggi untuk ruangan modern atau klasik. Terbuat dari kayu jati berkualitas tinggi yang tahan lama dengan finishing natural yang elegan. Kursi ini nyaman digunakan untuk waktu yang lama, dan juga relatif mudah dibersihkan. Desain sederhana namun kokoh membuat kursi ini cocok untuk berbagai keperluan, mulai dari ruang makan hingga ruang kerja atau studio desain.',
      specifications: [
        'Material Kursi: Kayu Jati Solid',
        'Dimensi: Lebar 45 cm x Kedalaman 50 cm x Tinggi 80 cm (tinggi sandaran: 45 cm tinggi)',
        'Warna: Cokelat Kayu Natural',
        'Kapasitas Duduk: Hingga 120 kg',
        'Finishing: Natural Wood',
        'Kemudahan: Sudah siap digunakan (tidak dirakit)',
      ],
      material: [
        'Kayu jati solid berkualitas premium',
        'Finishing natural tahan lama',
        'Desain ergonomis untuk kenyamanan maksimal',
        'Mudah dibersihkan dan dirawat',
        'Konstruksi kokoh dan stabil',
      ],
    ),
    Product(
      id: 3,
      name: 'SOFA',
      price: 'Rp.5.000.000',
      image: 'assets/images/sofa.png',
      description: 'Sofa Kayu Jati Minimalis ini menghadirkan kesan hangat dan elegan yang sempurna untuk ruang tamu Anda. Didesain dengan kombinasi desain minimalis modern dan kayu jati solid berkualitas tinggi, sofa ini menawarkan kenyamanan dan kekokohan yang luar biasa. Dengan bantalan empuk dan desain yang simple namun tetap elegan, sofa ini cocok untuk berbagai gaya interior.',
      specifications: [
        'Material Rangka: Kayu Jati Solid',
        'Material Bantalan: Busa dengan density tinggi + busa empuk berkualitas tinggi',
        'Warna Kayu: Cokelat Natural',
        'Pelapis: Kain linen',
        'Dimensi: Panjang 200 cm x Lebar 85 cm x Tinggi 80 cm PP',
        'Kapasitas: 3 Orang',
        'Finishing: Minimalis anti ngos-ngosan',
        'Fitur: Desain dengan sandaran tiff (tidak gross)',
        'Mudah dibersihkan (cushion cover, bisa dilepas)',
      ],
      material: [
        'Rangka kokoh dari kayu solid',
        'Busa berkualitas premium',
        'Pelapis dengan desain untuk ruang produk',
        'Tahan lama dan mudah dirawat',
        'Desain minimalis modern yang elegan',
      ],
    ),
    Product(
      id: 4,
      name: 'GrandWood Storage Bed',
      price: 'Rp.7.000.000',
      image: 'assets/images/bed.png',
      description: 'GrandWood Storage Bed hadir menghadirkan perpaduan sempurna antara gaya klasik dengan fungsi penyimpanan modern yang praktis. Terbuat dari kayu solid berkualitas tinggi dengan finishing natural yang elegan, tempat tidur ini dilengkapi dengan laci penyimpanan luas dan dalam untuk menata tempat tidur hingga pakaian atau barang berharga. Desainnya yang simple namun megah membuat tempat tidur ini menjadi sempurna untuk kamar tidur Anda.',
      specifications: [
        'Material: Kayu Solid (Kayu Jati)',
        'Dimensi Tempat Tidur: 200 x 180 cm',
        'Ukuran Kasur: 160 x 200 cm (Queen Size)',
        'Tinggi: 45 cm (bawah ke atas tempat tidur)',
        'Finishing: Natural Wood/Soft Brown',
        'Storage: 2 laci besar di bagian bawah tempat tidur',
      ],
      material: [
        'Rangka kokoh dan tahan lama solid',
        'Desain minimalis modern',
        'Penyimpanan ekstra untuk ruang produk',
        'Tahan lama dan mudah dirawat',
        'Finishing berkualitas tinggi',
      ],
    ),
  ];

  static Product getProductById(int id) {
    return products.firstWhere((product) => product.id == id);
  }

  static List<Product> getAllProducts() {
    return products;
  }
}