# Fix: Registration Failed - Supabase Connection Error

## Error Message
```
ClientException: Failed to fetch, uri=https://wkhigrtqgwinocceqheau.supabase.co/auth/v1/signup?
```

## Penyebab
1. Project Supabase belum dibuat/disetup
2. URL atau API Key salah
3. Email confirmation masih enabled di Supabase

---

## ✅ SOLUSI: Setup Supabase Project

### Step 1: Buat Project Supabase Baru

1. Buka [Supabase Dashboard](https://supabase.com/dashboard)
2. Klik **"New Project"**
3. Isi form:
   - **Name**: `amitra-furniture` (atau nama lain)
   - **Database Password**: Buat password yang kuat (simpan baik-baik!)
   - **Region**: Pilih **Southeast Asia (Singapore)** - paling dekat dengan Indonesia
4. Klik **"Create new project"**
5. Tunggu ~2 menit sampai project selesai dibuat

### Step 2: Dapatkan API Credentials

Setelah project dibuat:

1. Di Dashboard, klik project Anda
2. Klik ikon **Settings (gear)** di sidebar kiri
3. Klik **"API"** di menu Settings
4. Copy 2 hal ini:
   - **URL** (Project URL) - contoh: `https://xxxyyyzz.supabase.co`
   - **anon public** key (API Key) - string panjang yang dimulai dengan `eyJ...`

### Step 3: Update Credentials di Flutter

1. Buka file: **`lib/config/supabase_config.dart`**
2. Replace dengan credentials yang baru:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://xxxyyyzz.supabase.co'; // <-- PASTE URL ANDA
  static const String supabaseAnonKey = 'eyJhbGciOiJ...'; // <-- PASTE ANON KEY ANDA
  
  // Jangan ubah yang di bawah ini
  static const String productsTable = 'products';
  static const String ordersTable = 'orders';
  static const String orderItemsTable = 'order_items';
  static const String usersTable = 'users';
  static const String cartsTable = 'carts';
  static const String favoritesTable = 'favorites';
}
```

### Step 4: Disable Email Confirmation (PENTING!)

Secara default, Supabase mengharuskan email confirmation. Untuk development, disable dulu:

1. Di Supabase Dashboard → **Authentication** (sidebar kiri)
2. Klik **"Providers"** tab
3. Scroll ke **"Email"** provider
4. Klik untuk expand
5. **MATIKAN** toggle **"Enable email confirmations"**
6. Klik **"Save"**

### Step 5: Setup Database

1. Di Supabase Dashboard → **SQL Editor** (sidebar kiri)
2. Klik **"New query"**
3. Buka file `supabase_setup.sql` di project Anda
4. Copy **SELURUH** isi file
5. Paste di SQL Editor
6. Klik **"Run"** atau tekan **Ctrl+Enter**
7. Tunggu sampai selesai (muncul "Success")

**Verify:**
- Klik **"Table Editor"** di sidebar
- Harus ada 6 tables: `products`, `users`, `orders`, `order_items`, `carts`, `favorites`
- Klik table `products` - harus ada 8 rows (8 furniture)

### Step 6: Test Registrasi

1. **Stop** aplikasi yang sedang running (tekan Stop di Android Studio/VS Code)
2. **Hot Restart** TIDAK cukup - harus full restart!
3. Run ulang aplikasi:
   ```bash
   flutter run
   ```
4. Buka halaman Register
5. Isi form:
   - Nama: `Faishal`
   - Email: `faishalarif73@gmail.com`
   - Password: (minimal 6 karakter)
   - Konfirmasi Password: (sama dengan password)
6. Check ✅ "Setuju dengan syarat & ketentuan"
7. Klik **"Daftar"**

**Expected Result:**
- Loading indicator muncul
- Setelah selesai: "Registrasi berhasil! Silakan login" (SnackBar hijau)
- Redirect ke Login screen

### Step 7: Set User Jadi Admin

Setelah registrasi berhasil:

1. Buka **Supabase Dashboard → SQL Editor**
2. Run query ini:
```sql
UPDATE public.users 
SET is_admin = true 
WHERE email = 'faishalarif73@gmail.com';
```
3. Klik **"Run"**
4. Should return: **"UPDATE 1"** ✅

**Verify admin:**
```sql
SELECT email, name, is_admin 
FROM public.users 
WHERE email = 'faishalarif73@gmail.com';
```
Should show: `is_admin = true`

---

## 🧪 Testing Login

### Test Customer Login:
1. Login screen → Masukkan email & password
2. Should navigate ke Home Page
3. Products harus load dari Supabase (8 products)

### Test Admin Login:
1. Navigate ke `/login-admin` (atau dari menu admin)
2. Masukkan email & password admin
3. Should navigate ke Admin Dashboard

---

## ❌ Troubleshooting

### Error: "Invalid API Key"
**Fix:** Double-check API key di `supabase_config.dart`. Pastikan tidak ada spasi/newline extra.

### Error: "Email not confirmed"
**Fix:** Disable email confirmation (lihat Step 4)

### Error: "User already registered"
**Option 1:** Login dengan email yang sudah didaftarkan
**Option 2:** Gunakan email berbeda untuk registrasi

### Error: "Network Error" atau "Failed to fetch"
**Check:**
1. Internet connection stable?
2. URL Supabase benar? (tidak ada typo)
3. Project Supabase sudah selesai dibuat? (tidak masih "Setting up...")

### Products tidak muncul setelah login
**Fix:**
1. Pastikan SQL setup sudah di-run
2. Check di Supabase → Table Editor → products → harus ada 8 rows
3. Jika kosong, run ulang SQL setup

---

## 📝 Checklist Setup

- [ ] Create Supabase project
- [ ] Copy URL dan anon key
- [ ] Update `supabase_config.dart` dengan credentials baru
- [ ] Disable email confirmation
- [ ] Run `supabase_setup.sql` di SQL Editor
- [ ] Verify 6 tables created
- [ ] Verify 8 products inserted
- [ ] Full restart aplikasi (bukan hot restart)
- [ ] Test register user baru
- [ ] Set user jadi admin via SQL
- [ ] Test login customer
- [ ] Test login admin

---

## 🎉 Selesai!

Setelah semua checklist ✅, aplikasi Anda siap digunakan dengan Supabase backend!

**Next Steps:**
- Test cart functionality
- Test checkout process
- Test admin CRUD operations
