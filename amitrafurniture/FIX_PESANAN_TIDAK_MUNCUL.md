# Panduan Memperbaiki Masalah Pesanan Tidak Muncul

## Masalah
Ketika checkout produk, pesanan tidak masuk ke halaman "Pesanan Saya".

## Penyebab
Masalahnya ada di **Row Level Security (RLS)** Supabase yang membatasi akses user ke tabel `orders` dan `order_items`.

## Solusi

### OPTION 1: Solusi Cepat (Testing) - RECOMMENDED FIRST

**File**: `SUPABASE_RLS_SIMPLE.sql`

1. Buka Supabase SQL Editor
2. Copy-paste isi file `SUPABASE_RLS_SIMPLE.sql`
3. Run

Script ini akan **DISABLE RLS sementara** agar order bisa masuk. Setelah yakin berfungsi, baru enable RLS dengan policy yang benar.

### OPTION 2: Solusi Lengkap dengan RLS Policy

**File**: `SUPABASE_RLS_FIXED.sql`

1. Buka Supabase SQL Editor
2. Copy-paste isi file `SUPABASE_RLS_FIXED.sql`
3. Run

Script ini sudah diperbaiki dengan **type casting yang benar** untuk menghindari error `text = uuid`.

### Langkah Detail:
1. Login ke https://supabase.com
2. Pilih project: `wkhigfqgwinoccqqheau`
3. Klik "SQL Editor" di sidebar kiri

### Langkah 2: Jalankan SQL Script
1. Copy semua isi file `SUPABASE_RLS_POLICY.sql`
2. Paste di SQL Editor
3. Klik "Run" untuk eksekusi

### Langkah 3: Verifikasi RLS Policies
Jalankan query ini untuk memastikan policies sudah terbuat:

```sql
SELECT * FROM pg_policies 
WHERE tablename IN ('orders', 'order_items');
```

Anda harus melihat 6 policies:
- ✅ Users can view their own orders
- ✅ Users can insert their own orders
- ✅ Admins can view all orders
- ✅ Users can view their own order items
- ✅ Users can insert order items
- ✅ Admins can view all order items

### Langkah 4: Testing (Optional - Untuk Debugging)
Jika masih tidak berhasil, **TEMPORARY DISABLE RLS** untuk testing:

```sql
ALTER TABLE orders DISABLE ROW LEVEL SECURITY;
ALTER TABLE order_items DISABLE ROW LEVEL SECURITY;
```

⚠️ **PERINGATAN**: Jangan lupa enable kembali setelah testing!

```sql
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
```

### Langkah 5: Coba Checkout Lagi
1. Hot reload aplikasi Flutter
2. Login sebagai customer
3. Tambah produk ke cart
4. Checkout
5. Cek halaman "Pesanan Saya"

## Debugging Console
Perhatikan console/terminal untuk melihat log:
- `✅ Order created successfully: [order_id]`
- `✅ Verified X items saved for order [order_id]`
- `OrderProvider: Received X orders from service`

Jika ada error, akan muncul:
- `❌ Error creating order: [error message]`
- `❌ Error creating order items: [error message]`

## Alternative: Check Database Directly
1. Buka "Table Editor" di Supabase
2. Cek tabel `orders` - apakah ada order baru?
3. Cek tabel `order_items` - apakah ada items?
4. Jika ada di database tapi tidak muncul di app = masalah RLS SELECT
5. Jika tidak ada di database = masalah RLS INSERT

## Kemungkinan Error Lain

### Error: "new row violates row-level security policy"
**Solusi**: User tidak punya permission INSERT. Jalankan policy SQL di atas.

### Error: "null value in column 'user_id'"
**Solusi**: User belum login atau auth.uid() null. Pastikan user sudah login.

### Order ada di database tapi tidak muncul
**Solusi**: RLS SELECT policy belum benar. Cek policy "Users can view their own orders".

### Order Items tidak tersimpan
**Solusi**: 
1. Cek foreign key constraint
2. Cek RLS INSERT policy untuk order_items
3. Pastikan product_id valid (ada di tabel products)

## Kontak Support
Jika masih bermasalah, screenshot:
1. Console log saat checkout
2. Table `orders` di Supabase
3. Table `order_items` di Supabase
4. Output query: `SELECT * FROM pg_policies WHERE tablename IN ('orders', 'order_items');`
