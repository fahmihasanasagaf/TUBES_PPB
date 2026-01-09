# Setup Backend Supabase untuk AMitra Furniture

## Langkah 1: Buat Project Supabase

1. Kunjungi [https://app.supabase.com](https://app.supabase.com)
2. Sign up / Login
3. Klik "New Project"
4. Isi detail project:
   - Name: `amitra-furniture`
   - Database Password: (buat password yang kuat)
   - Region: Pilih yang terdekat (e.g., Southeast Asia)
5. Klik "Create new project"

## Langkah 2: Setup Database

1. Setelah project dibuat, buka **SQL Editor** dari sidebar
2. Copy seluruh isi file `supabase_setup.sql`
3. Paste di SQL Editor
4. Klik **Run** untuk menjalankan script
5. Database tables dan policies akan otomatis terbuat

## Langkah 3: Dapatkan API Keys

1. Buka **Project Settings** → **API**
2. Copy nilai berikut:
   - **Project URL** (contoh: https://xxxxx.supabase.co)
   - **Anon/Public Key** (key yang panjang)

## Langkah 4: Update Konfigurasi Flutter

1. Buka file `lib/config/supabase_config.dart`
2. Ganti nilai berikut dengan API keys Anda:
   ```dart
   static const String supabaseUrl = 'https://xxxxx.supabase.co';
   static const String supabaseAnonKey = 'eyJhbGc...'; // Anon key Anda
   ```

## Langkah 5: Install Dependencies

Jalankan command berikut di terminal:

```bash
flutter pub get
```

## Langkah 6: Setup Authentication (Optional untuk Email Verification)

1. Buka **Authentication** → **Settings** di Supabase dashboard
2. Disable "Email Confirmations" jika ingin user langsung bisa login tanpa verify email
3. Atau setup Email Template jika ingin menggunakan email verification

## Langkah 7: Upload Sample Data (Optional)

Jika ingin mengisi database dengan data sample:

1. Uncomment bagian "Insert sample data" di `supabase_setup.sql`
2. Jalankan query tersebut di SQL Editor

Atau insert manual via **Table Editor** di Supabase dashboard.

## Struktur Database

### 1. **products** - Menyimpan produk furniture
- id (UUID)
- name (string)
- price (decimal)
- description (text)
- category (string)
- image_url (string)
- stock (integer)
- specifications (JSON)
- materials (JSON)

### 2. **users** - Profile user (extends auth.users)
- id (UUID - reference ke auth.users)
- name (string)
- phone (string)
- address (text)
- avatar_url (string)
- is_admin (boolean)

### 3. **orders** - Pesanan
- id (UUID)
- user_id (UUID)
- order_number (string - auto-generated)
- status (string: pending, processing, shipped, delivered, cancelled)
- total_amount (decimal)
- shipping_address (text)
- phone (string)
- payment_method (string)

### 4. **order_items** - Item dalam pesanan
- id (UUID)
- order_id (UUID)
- product_id (UUID)
- quantity (integer)
- price (decimal)

### 5. **carts** - Keranjang belanja
- id (UUID)
- user_id (UUID)
- product_id (UUID)
- quantity (integer)

### 6. **favorites** - Produk favorit
- id (UUID)
- user_id (UUID)
- product_id (UUID)

## Testing Backend

Setelah setup selesai, test dengan:

1. **Register User Baru**: Coba register di aplikasi
2. **Login**: Test login dengan user yang baru dibuat
3. **View Products**: Pastikan produk bisa ditampilkan
4. **Add to Cart**: Test tambah produk ke keranjang
5. **Create Order**: Test proses checkout

## Create Admin User

Untuk membuat user sebagai admin:

1. Buka **Table Editor** → **users**
2. Find user yang ingin dijadikan admin
3. Edit row, ubah `is_admin` menjadi `true`
4. Save

## Row Level Security (RLS)

Security policies sudah di-setup otomatis:
- ✅ Products: Semua bisa read, hanya admin bisa write
- ✅ Users: User hanya bisa lihat/edit data sendiri
- ✅ Orders: User hanya bisa lihat order sendiri, admin bisa lihat semua
- ✅ Carts & Favorites: User hanya bisa akses data sendiri

## Troubleshooting

### Error: "Invalid API Key"
- Pastikan `supabaseUrl` dan `supabaseAnonKey` sudah benar
- Check tidak ada spasi atau karakter tambahan

### Error: "Permission denied"
- Check RLS policies sudah ter-setup dengan benar
- Pastikan user sudah login (jika perlu auth)

### Error: "Table doesn't exist"
- Pastikan SQL setup script sudah dijalankan dengan sukses
- Check di **Table Editor** apakah tables sudah ada

## Dokumentasi Supabase Service

### Auth Methods
```dart
// Register
await SupabaseService().signUp(email, password, name);

// Login
await SupabaseService().signIn(email, password);

// Logout
await SupabaseService().signOut();

// Check login status
bool isLoggedIn = SupabaseService().isLoggedIn;
```

### Product Methods
```dart
// Get all products
List<Map<String, dynamic>> products = await SupabaseService().getProducts();

// Get product by ID
Map<String, dynamic> product = await SupabaseService().getProductById(id);

// Get products by category
List products = await SupabaseService().getProductsByCategory('Kursi');

// Add product (admin only)
await SupabaseService().addProduct(productData);

// Update product (admin only)
await SupabaseService().updateProduct(id, productData);

// Delete product (admin only)
await SupabaseService().deleteProduct(id);
```

### Order Methods
```dart
// Get user orders
List orders = await SupabaseService().getOrdersByUser(userId);

// Create order
await SupabaseService().createOrder(orderData);

// Update order status (admin only)
await SupabaseService().updateOrderStatus(orderId, 'shipped');
```

### Cart Methods
```dart
// Get cart items
List cart = await SupabaseService().getCartItems(userId);

// Add to cart
await SupabaseService().addToCart(userId, productId, quantity);

// Update quantity
await SupabaseService().updateCartQuantity(cartId, newQuantity);

// Remove from cart
await SupabaseService().removeFromCart(cartId);

// Clear cart
await SupabaseService().clearCart(userId);
```

### Favorite Methods
```dart
// Get favorites
List favorites = await SupabaseService().getFavorites(userId);

// Add to favorites
await SupabaseService().addToFavorites(userId, productId);

// Remove from favorites
await SupabaseService().removeFromFavorites(userId, productId);

// Check if favorite
bool isFav = await SupabaseService().isFavorite(userId, productId);
```

## Next Steps

Setelah backend setup:
1. Integrate authentication di login/register screens
2. Load products dari Supabase (bukan dari hardcoded data)
3. Implement cart functionality dengan Supabase
4. Implement order creation dan tracking
5. Add image upload untuk produk (gunakan Supabase Storage)

## Support

Untuk dokumentasi lengkap Supabase:
- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)
