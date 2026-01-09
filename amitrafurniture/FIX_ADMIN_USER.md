# Fix: Create Admin User

## Masalah
Error saat menjalankan query:
```
ERROR: column "email" does not exist
```

## Penyebab
Table `users` versi lama tidak memiliki kolom `email`. Sudah diperbaiki di `supabase_setup.sql` terbaru.

## Solusi

### Option 1: Re-run Setup SQL (Recommended)

**⚠️ WARNING:** Ini akan **menghapus semua data** di tables (users, products, orders, carts, favorites)

1. Di Supabase Dashboard → SQL Editor
2. Hapus tables yang ada:
```sql
-- Drop tables in reverse order (karena foreign keys)
DROP TABLE IF EXISTS favorites CASCADE;
DROP TABLE IF EXISTS carts CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS products CASCADE;

-- Drop triggers dan functions
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_user();
DROP FUNCTION IF EXISTS update_updated_at_column();
DROP FUNCTION IF EXISTS generate_order_number();
DROP SEQUENCE IF EXISTS order_number_seq;
```

3. Copy & run seluruh isi `supabase_setup.sql` yang sudah diperbaiki
4. Register user baru di app
5. Run query untuk jadikan admin:
```sql
UPDATE public.users 
SET is_admin = true 
WHERE email = 'faishalarif73@gmail.com';
```

### Option 2: Alter Table (Jika ingin keep existing data)

**Jika Anda sudah punya data penting yang tidak ingin hilang:**

1. Add kolom email ke table users:
```sql
ALTER TABLE public.users 
ADD COLUMN email VARCHAR(255);
```

2. Sync email dari auth.users:
```sql
UPDATE public.users u
SET email = au.email
FROM auth.users au
WHERE u.id = au.id;
```

3. Update trigger function:
```sql
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, name, created_at)
  VALUES (
    NEW.id, 
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'name', NEW.raw_user_meta_data->>'full_name', 'User'),
    NOW()
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

4. Sekarang bisa run query admin:
```sql
UPDATE public.users 
SET is_admin = true 
WHERE email = 'faishalarif73@gmail.com';
```

## Verify

Setelah menjalankan salah satu option di atas, verify dengan:

```sql
-- Check user dan status admin
SELECT 
  id,
  email,
  name,
  is_admin,
  created_at
FROM public.users
WHERE email = 'faishalarif73@gmail.com';
```

Seharusnya menampilkan:
- `email`: faishalarif73@gmail.com
- `is_admin`: **true** ✅

## Test Login Admin

1. Buka app → Navigate ke `/login-admin`
2. Login dengan:
   - Email: `faishalarif73@gmail.com`
   - Password: (password yang Anda buat saat register)
3. Should navigate ke Admin Dashboard ✅

## Troubleshooting

### "User tidak ada di public.users"

Jika setelah register, user tidak muncul di `public.users`:

```sql
-- Manual sync dari auth.users ke public.users
INSERT INTO public.users (id, email, name, created_at)
SELECT 
  id,
  email,
  COALESCE(raw_user_meta_data->>'name', raw_user_meta_data->>'full_name', 'User'),
  created_at
FROM auth.users
WHERE email = 'faishalarif73@gmail.com';

-- Lalu set admin
UPDATE public.users 
SET is_admin = true 
WHERE email = 'faishalarif73@gmail.com';
```

### "Access denied - Hanya admin yang dapat login"

Pastikan `is_admin = true`:
```sql
-- Check current status
SELECT is_admin FROM public.users WHERE email = 'faishalarif73@gmail.com';

-- If false, update to true
UPDATE public.users SET is_admin = true WHERE email = 'faishalarif73@gmail.com';
```

---

**Done!** 🎉 Sekarang Anda bisa login sebagai admin.
