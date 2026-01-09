-- =====================================================
-- SUPABASE RLS POLICIES UNTUK ORDERS DAN ORDER_ITEMS
-- =====================================================
-- Jalankan script ini di Supabase SQL Editor
-- untuk mengaktifkan Row Level Security

-- 1. ENABLE RLS untuk tabel orders
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- 2. ENABLE RLS untuk tabel order_items  
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- 3. DROP existing policies jika ada (optional, jalankan jika ada error)
DROP POLICY IF EXISTS "Users can view their own orders" ON orders;
DROP POLICY IF EXISTS "Users can insert their own orders" ON orders;
DROP POLICY IF EXISTS "Admins can view all orders" ON orders;
DROP POLICY IF EXISTS "Users can view their own order items" ON order_items;
DROP POLICY IF EXISTS "Users can insert order items" ON order_items;
DROP POLICY IF EXISTS "Admins can view all order items" ON order_items;

-- =====================================================
-- POLICIES UNTUK TABEL ORDERS
-- =====================================================

-- Policy: User dapat melihat pesanan mereka sendiri
CREATE POLICY "Users can view their own orders" ON orders
FOR SELECT
USING (user_id = auth.uid()::text);

-- Policy: User dapat membuat pesanan baru
CREATE POLICY "Users can insert their own orders" ON orders
FOR INSERT
WITH CHECK (user_id = auth.uid()::text);

-- Policy: Admin dapat melihat semua pesanan
CREATE POLICY "Admins can view all orders" ON orders
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM users 
    WHERE users.id = auth.uid()::text 
    AND users.role = 'admin'
  )
);

-- =====================================================
-- POLICIES UNTUK TABEL ORDER_ITEMS
-- =====================================================

-- Policy: User dapat melihat order items dari pesanan mereka
CREATE POLICY "Users can view their own order items" ON order_items
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM orders 
    WHERE orders.id = order_items.order_id 
    AND orders.user_id = auth.uid()::text
  )
);

-- Policy: User dapat insert order items
CREATE POLICY "Users can insert order items" ON order_items
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM orders 
    WHERE orders.id = order_items.order_id 
    AND orders.user_id = auth.uid()::text
  )
);

-- Policy: Admin dapat melihat semua order items
CREATE POLICY "Admins can view all order items" ON order_items
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM users 
    WHERE users.id = auth.uid()::text 
    AND users.role = 'admin'
  )
);

-- =====================================================
-- OPTIONAL: Jika ingin DISABLE RLS (untuk testing)
-- =====================================================
-- ALTER TABLE orders DISABLE ROW LEVEL SECURITY;
-- ALTER TABLE order_items DISABLE ROW LEVEL SECURITY;

-- =====================================================
-- VERIFIKASI POLICIES
-- =====================================================
-- SELECT * FROM pg_policies WHERE tablename IN ('orders', 'order_items');
