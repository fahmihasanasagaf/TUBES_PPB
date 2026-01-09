-- SQL untuk membuat tabel-tabel di Supabase
-- Jalankan script ini di Supabase SQL Editor: https://app.supabase.com/project/_/sql

-- 1. Tabel Products
CREATE TABLE products (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  description TEXT,
  category VARCHAR(100),
  image_url TEXT,
  stock INTEGER DEFAULT 0,
  specifications JSONB,
  materials JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- 2. Tabel Users (extends auth.users)
CREATE TABLE users (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email VARCHAR(255), -- Duplicate from auth.users for easier queries
  name VARCHAR(255),
  phone VARCHAR(20),
  address TEXT,
  avatar_url TEXT,
  is_admin BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- 3. Tabel Orders
CREATE TABLE orders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  order_number VARCHAR(50) UNIQUE NOT NULL,
  status VARCHAR(50) DEFAULT 'pending',
  total_amount DECIMAL(10, 2) NOT NULL,
  shipping_address TEXT NOT NULL,
  phone VARCHAR(20) NOT NULL,
  notes TEXT,
  payment_method VARCHAR(50),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- 4. Tabel Order Items
CREATE TABLE order_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  quantity INTEGER NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- 5. Tabel Carts
CREATE TABLE carts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  quantity INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  UNIQUE(user_id, product_id)
);

-- 6. Tabel Favorites
CREATE TABLE favorites (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  UNIQUE(user_id, product_id)
);

-- 7. Enable Row Level Security (RLS)
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE carts ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;

-- 8. Policies untuk Products (semua bisa read, admin bisa write)
CREATE POLICY "Products are viewable by everyone" ON products FOR SELECT USING (true);
CREATE POLICY "Admins can insert products" ON products FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM users WHERE users.id = auth.uid() AND users.is_admin = true)
);
CREATE POLICY "Admins can update products" ON products FOR UPDATE USING (
  EXISTS (SELECT 1 FROM users WHERE users.id = auth.uid() AND users.is_admin = true)
);
CREATE POLICY "Admins can delete products" ON products FOR DELETE USING (
  EXISTS (SELECT 1 FROM users WHERE users.id = auth.uid() AND users.is_admin = true)
);

-- 9. Policies untuk Users (user bisa lihat dan update data sendiri)
CREATE POLICY "Users can view own data" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own data" ON users FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Admins can view all users" ON users FOR SELECT USING (
  EXISTS (SELECT 1 FROM users WHERE users.id = auth.uid() AND users.is_admin = true)
);

-- 10. Policies untuk Orders
CREATE POLICY "Users can view own orders" ON orders FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can create own orders" ON orders FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Admins can view all orders" ON orders FOR SELECT USING (
  EXISTS (SELECT 1 FROM users WHERE users.id = auth.uid() AND users.is_admin = true)
);
CREATE POLICY "Admins can update orders" ON orders FOR UPDATE USING (
  EXISTS (SELECT 1 FROM users WHERE users.id = auth.uid() AND users.is_admin = true)
);

-- 11. Policies untuk Order Items
CREATE POLICY "Users can view own order items" ON order_items FOR SELECT USING (
  EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid())
);
CREATE POLICY "Users can create order items" ON order_items FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid())
);
CREATE POLICY "Admins can view all order items" ON order_items FOR SELECT USING (
  EXISTS (SELECT 1 FROM users WHERE users.id = auth.uid() AND users.is_admin = true)
);

-- 12. Policies untuk Carts
CREATE POLICY "Users can view own cart" ON carts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own cart" ON carts FOR ALL USING (auth.uid() = user_id);

-- 13. Policies untuk Favorites
CREATE POLICY "Users can view own favorites" ON favorites FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own favorites" ON favorites FOR ALL USING (auth.uid() = user_id);

-- 14. Create function untuk auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 15. Create triggers untuk auto-update updated_at
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_carts_updated_at BEFORE UPDATE ON carts
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 16. Function untuk auto-generate order number
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TRIGGER AS $$
BEGIN
  NEW.order_number = 'ORD-' || TO_CHAR(NOW(), 'YYYY') || '-' || LPAD(NEXTVAL('order_number_seq')::TEXT, 6, '0');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE SEQUENCE order_number_seq START 1;

CREATE TRIGGER set_order_number BEFORE INSERT ON orders
FOR EACH ROW EXECUTE FUNCTION generate_order_number();


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

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 18. Insert sample data (semua produk)

INSERT INTO products (name, price, description, category, image_url, stock, specifications, materials) VALUES
-- KURSI (2 produk)
(
  'Kursi Goyang',
  1450000,
  'Kursi goyang klasik dengan desain timeless yang cocok untuk ruang santai. Terbuat dari kayu jati solid dengan mekanisme goyang yang halus dan nyaman.',
  'Kursi',
  'assets/images/dan1.jpg',
  10,
  '["Bahan: Kayu Jati Solid Premium", "Dimensi: 68cm x 92cm x 108cm", "Kapasitas: Hingga 140kg", "Finishing: Natural Wood Stain"]'::jsonb,
  '["Kayu jati pilihan grade A", "Busa high density premium", "Mekanisme goyang yang smooth", "Kaki kayu solid dengan reinforcement"]'::jsonb
),
(
  'Kursi Santai',
  750000,
  'Kursi santai ergonomis dengan desain modern dan material yang nyaman. Perfect untuk corner reading, ruang tamu, atau area relaksasi di rumah.',
  'Kursi',
  'assets/images/dan2.jpg',
  15,
  '["Bahan: Fabric Premium + Rangka Kayu", "Dimensi: 72cm x 78cm x 88cm", "Kapasitas: 110kg", "Warna: Dark Grey/Beige"]'::jsonb,
  '["Fabric premium anti-stain", "Busa memory foam medium firm", "Rangka kayu maple reinforced", "Kaki kayu dengan rubber feet"]'::jsonb
),

-- RANJANG (2 produk)
(
  'Ranjang Susun Tingkat',
  2850000,
  'Ranjang susun tingkat praktis dengan desain modern yang hemat space. Cocok untuk kamar anak, guest room, atau apartemen dengan space terbatas.',
  'Ranjang',
  'assets/images/dan3.jpg',
  5,
  '["Bahan: Kayu Solid + Metal", "Dimensi: 100cm x 200cm x 160cm", "Kapasitas: 2 tempat tidur", "Include: Tangga dan safety rail"]'::jsonb,
  '["Kayu solid dengan metal reinforcement", "Safety rail pada bagian atas", "Tangga yang kokoh dan aman", "Slat system untuk mattress support"]'::jsonb
),
(
  'Ranjang Modern',
  3950000,
  'Ranjang modern minimalis dengan headboard yang elegant dan desain low-profile. Cocok untuk kamar tidur utama dengan gaya kontemporer.',
  'Ranjang',
  'assets/images/dan4.jpg',
  7,
  '["Bahan: Fabric Headboard + Kayu Solid", "Dimensi: 160cm x 200cm", "Ukuran: Queen Size", "Style: Modern Minimalist"]'::jsonb,
  '["Headboard fabric premium dengan padding", "Rangka kayu oak solid", "Low-profile design", "Center support reinforcement"]'::jsonb
),

-- LACI (2 produk)
(
  'Laci Modern Retro',
  1350000,
  'Laci dengan gaya modern retro yang unique dan artistic. Kombinasi warna yang bold dengan handle karakter yang menjadi focal point.',
  'Laci',
  'assets/images/dan5.jpg',
  12,
  '["Bahan: MDF + Kayu Solid", "Dimensi: 85cm x 45cm x 90cm", "Jumlah Laci: 5 drawers", "Style: Modern Retro Vintage"]'::jsonb,
  '["MDF premium dengan finishing khusus", "Drawer slides soft-close", "Handle karakter retro", "Kaki kayu dengan metal accent"]'::jsonb
),
(
  'Buffet Jati Laci',
  2650000,
  'Buffet serbaguna dari kayu jati asli dengan kombinasi laci dan pintu. Cocok untuk dining room, living room, atau sebagai storage cabinet.',
  'Laci',
  'assets/images/dan6.jpg',
  8,
  '["Bahan: Kayu Jati Solid", "Dimensi: 120cm x 45cm x 85cm", "Kombinasi: 3 laci + 2 pintu", "Finishing: Dark Teak"]'::jsonb,
  '["Kayu jati solid 100%", "Engsel dan slide premium", "Finishing natural oil protection", "Adjustable shelves"]'::jsonb
),

-- SOFA (2 produk)
(
  'Sofa Metal Feet',
  2950000,
  'Sofa modern dengan metal feet yang elegant dan desain clean lines. Kombinasi antara kekuatan metal dan kenyamanan fabric premium.',
  'Sofa',
  'assets/images/dan7.jpg',
  6,
  '["Bahan: Linen Fabric + Metal Frame", "Dimensi: 185cm x 88cm x 78cm", "Kapasitas: 3 seater", "Kaki: Chrome Metal Feet"]'::jsonb,
  '["Linen fabric premium anti-stain", "Metal feet chrome finishing", "High resilience foam", "Solid wood frame internal"]'::jsonb
),
(
  'Lorenz Seater Sofa',
  4250000,
  'Sofa premium "Lorenz" dengan desain luxurious dan kenyamanan maksimal. Perfect untuk ruang tamu utama yang mengutamakan style dan comfort.',
  'Sofa',
  'assets/images/dan8.jpg',
  4,
  '["Bahan: Premium Chenille Fabric", "Dimensi: 210cm x 95cm x 82cm", "Kapasitas: 3-4 seater", "Include: 6 throw pillows"]'::jsonb,
  '["Chenille fabric luxury grade", "Pocket spring + foam hybrid system", "Solid hardwood frame", "Premium feather filled pillows"]'::jsonb
);

-- ============================================
-- HELPER QUERIES (Run setelah setup selesai)
-- ============================================

-- Query untuk membuat user menjadi admin
-- Ganti 'email@example.com' dengan email user yang ingin dijadikan admin

UPDATE public.users 
SET is_admin = true 
WHERE email = 'faishalarif73@gmail.com';




SELECT 
  u.id,
  u.email,
  u.name,
  u.is_admin,
  u.created_at
FROM public.users u
ORDER BY u.created_at DESC;




SELECT 
  id,
  email,
  created_at,
  last_sign_in_at,
  email_confirmed_at
FROM auth.users
ORDER BY created_at DESC;




INSERT INTO public.users (id, email, name, created_at)
SELECT 
  au.id,
  au.email,
  COALESCE(au.raw_user_meta_data->>'name', au.raw_user_meta_data->>'full_name', 'User'),
  au.created_at
FROM auth.users au
WHERE NOT EXISTS (
  SELECT 1 FROM public.users pu WHERE pu.id = au.id
);

