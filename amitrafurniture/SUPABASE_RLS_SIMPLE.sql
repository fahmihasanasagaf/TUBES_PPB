-- =====================================================
-- SIMPLE RLS POLICY - DISABLE RLS UNTUK TESTING
-- =====================================================
-- Gunakan ini jika masih ada error dengan type casting

-- 1. DISABLE RLS untuk testing
ALTER TABLE orders DISABLE ROW LEVEL SECURITY;
ALTER TABLE order_items DISABLE ROW LEVEL SECURITY;

-- Dengan ini, SEMUA USER bisa:
-- - Membuat order baru
-- - Melihat semua order
-- - Insert order items
-- - Melihat order items

-- =====================================================
-- CATATAN PENTING
-- =====================================================
-- Ini untuk TESTING ONLY!
-- Setelah yakin order bisa masuk, enable kembali RLS
-- dan gunakan policy yang benar

-- Untuk enable RLS kembali:
-- ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
