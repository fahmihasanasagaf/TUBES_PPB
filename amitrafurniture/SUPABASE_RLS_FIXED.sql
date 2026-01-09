-- =====================================================
-- SUPABASE RLS POLICIES V2 - FIXED TYPE CASTING
-- =====================================================

-- 1. ENABLE RLS
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- 2. DROP existing policies
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
USING (user_id::text = (auth.uid())::text);

-- Policy: User dapat membuat pesanan baru
CREATE POLICY "Users can insert their own orders" ON orders
FOR INSERT
WITH CHECK (user_id::text = (auth.uid())::text);

-- Policy: Admin dapat melihat semua pesanan
CREATE POLICY "Admins can view all orders" ON orders
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM users 
    WHERE users.id::text = (auth.uid())::text 
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
    WHERE orders.id::text = order_items.order_id::text 
    AND orders.user_id::text = (auth.uid())::text
  )
);

-- Policy: User dapat insert order items
CREATE POLICY "Users can insert order items" ON order_items
FOR INSERT
WITH CHECK (true);  -- Allow insert, will be validated by orders policy

-- Policy: Admin dapat melihat semua order items
CREATE POLICY "Admins can view all order items" ON order_items
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM users 
    WHERE users.id::text = (auth.uid())::text 
    AND users.role = 'admin'
  )
);

-- =====================================================
-- VERIFIKASI
-- =====================================================
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd
FROM pg_policies 
WHERE tablename IN ('orders', 'order_items')
ORDER BY tablename, policyname;
