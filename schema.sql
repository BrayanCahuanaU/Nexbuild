-- ============================================================
-- PC Store Schema + Seed Data
-- ============================================================

CREATE DATABASE IF NOT EXISTS pcstore CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE pcstore;

-- ── Categories ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS categories (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  slug      VARCHAR(50) NOT NULL UNIQUE,
  name      VARCHAR(100) NOT NULL,
  icon      VARCHAR(50) NOT NULL
);

INSERT INTO categories (slug, name, icon) VALUES
  ('cpu',         'Procesadores',     '⚙️'),
  ('gpu',         'Tarjetas de Video','🎮'),
  ('ram',         'Memoria RAM',      '💾'),
  ('storage',     'Almacenamiento',   '💿'),
  ('motherboard', 'Placas Madre',     '🔲'),
  ('psu',         'Fuentes de Poder', '⚡'),
  ('case',        'Gabinetes',        '🖥️'),
  ('cooling',     'Refrigeración',    '❄️'),
  ('laptop',      'Laptops',          '💻');

-- ── Products ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS products (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  category_id  INT NOT NULL,
  name         VARCHAR(200) NOT NULL,
  brand        VARCHAR(100) NOT NULL,
  price        DECIMAL(10,2) NOT NULL,
  stock        INT NOT NULL DEFAULT 0,
  specs        JSON,
  image_url    VARCHAR(500),
  featured     BOOLEAN DEFAULT FALSE,
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- ── Builds ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS builds (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  use_case    TEXT NOT NULL,
  budget      DECIMAL(10,2) NOT NULL,
  result_json JSON NOT NULL,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- SEED DATA (precios en soles peruanos)
-- ============================================================

-- CPUs
INSERT INTO products (category_id, name, brand, price, stock, specs, featured) VALUES
(1, 'Intel Core i3-12100F', 'Intel', 380.00, 15, '{"cores":4,"threads":8,"base_ghz":3.3,"boost_ghz":4.3,"tdp":58,"socket":"LGA1700","gen":"12va Gen"}', FALSE),
(1, 'Intel Core i5-12400F', 'Intel', 650.00, 20, '{"cores":6,"threads":12,"base_ghz":2.5,"boost_ghz":4.4,"tdp":65,"socket":"LGA1700","gen":"12va Gen"}', TRUE),
(1, 'Intel Core i5-13600K', 'Intel', 950.00, 12, '{"cores":14,"threads":20,"base_ghz":3.5,"boost_ghz":5.1,"tdp":125,"socket":"LGA1700","gen":"13va Gen"}', TRUE),
(1, 'Intel Core i7-13700K', 'Intel', 1450.00, 8, '{"cores":16,"threads":24,"base_ghz":3.4,"boost_ghz":5.4,"tdp":125,"socket":"LGA1700","gen":"13va Gen"}', FALSE),
(1, 'Intel Core i9-13900K', 'Intel', 2200.00, 5, '{"cores":24,"threads":32,"base_ghz":3.0,"boost_ghz":5.8,"tdp":125,"socket":"LGA1700","gen":"13va Gen"}', FALSE),
(1, 'AMD Ryzen 5 5600',     'AMD',   580.00, 18, '{"cores":6,"threads":12,"base_ghz":3.5,"boost_ghz":4.4,"tdp":65,"socket":"AM4","gen":"Zen 3"}', TRUE),
(1, 'AMD Ryzen 5 7600X',    'AMD',   890.00, 14, '{"cores":6,"threads":12,"base_ghz":4.7,"boost_ghz":5.3,"tdp":105,"socket":"AM5","gen":"Zen 4"}', TRUE),
(1, 'AMD Ryzen 7 7700X',    'AMD',   1350.00, 9, '{"cores":8,"threads":16,"base_ghz":4.5,"boost_ghz":5.4,"tdp":105,"socket":"AM5","gen":"Zen 4"}', FALSE),
(1, 'AMD Ryzen 9 7900X',    'AMD',   1980.00, 5, '{"cores":12,"threads":24,"base_ghz":4.7,"boost_ghz":5.6,"tdp":170,"socket":"AM5","gen":"Zen 4"}', FALSE);

-- GPUs
INSERT INTO products (category_id, name, brand, price, stock, specs, featured) VALUES
(2, 'AMD RX 6600 XT 8GB',         'AMD',    950.00,  12, '{"vram_gb":8,"type":"GDDR6","bus":128,"tdp":160,"connectors":1}', FALSE),
(2, 'NVIDIA RTX 3060 12GB',       'NVIDIA', 1100.00, 15, '{"vram_gb":12,"type":"GDDR6","bus":192,"tdp":170,"connectors":1}', TRUE),
(2, 'AMD RX 6700 XT 12GB',        'AMD',    1280.00, 10, '{"vram_gb":12,"type":"GDDR6","bus":192,"tdp":230,"connectors":1}', FALSE),
(2, 'NVIDIA RTX 3060 Ti 8GB',     'NVIDIA', 1350.00, 10, '{"vram_gb":8,"type":"GDDR6","bus":256,"tdp":200,"connectors":1}', FALSE),
(2, 'NVIDIA RTX 4060 8GB',        'NVIDIA', 1450.00, 18, '{"vram_gb":8,"type":"GDDR6X","bus":128,"tdp":115,"connectors":1}', TRUE),
(2, 'AMD RX 7700 XT 12GB',        'AMD',    1650.00, 8,  '{"vram_gb":12,"type":"GDDR6","bus":192,"tdp":245,"connectors":1}', FALSE),
(2, 'NVIDIA RTX 4070 12GB',       'NVIDIA', 2100.00, 10, '{"vram_gb":12,"type":"GDDR6X","bus":192,"tdp":200,"connectors":1}', TRUE),
(2, 'NVIDIA RTX 4070 Ti Super 16GB','NVIDIA',3200.00, 6, '{"vram_gb":16,"type":"GDDR6X","bus":256,"tdp":285,"connectors":1}', FALSE),
(2, 'NVIDIA RTX 4080 16GB',       'NVIDIA', 4500.00, 4,  '{"vram_gb":16,"type":"GDDR6X","bus":256,"tdp":320,"connectors":1}', FALSE);

-- RAM
INSERT INTO products (category_id, name, brand, price, stock, specs, featured) VALUES
(3, 'Kingston Fury 8GB DDR4 3200MHz',       'Kingston', 120.00, 30, '{"gb":8,"type":"DDR4","mhz":3200,"modules":1,"cl":16}', FALSE),
(3, 'Corsair Vengeance 16GB DDR4 3200MHz',  'Corsair',  220.00, 25, '{"gb":16,"type":"DDR4","mhz":3200,"modules":2,"cl":16}', TRUE),
(3, 'G.Skill Ripjaws 32GB DDR4 3600MHz',    'G.Skill',  380.00, 15, '{"gb":32,"type":"DDR4","mhz":3600,"modules":2,"cl":18}', TRUE),
(3, 'Kingston Fury 16GB DDR5 4800MHz',      'Kingston', 320.00, 20, '{"gb":16,"type":"DDR5","mhz":4800,"modules":2,"cl":40}', FALSE),
(3, 'Corsair Dominator 32GB DDR5 5200MHz',  'Corsair',  520.00, 10, '{"gb":32,"type":"DDR5","mhz":5200,"modules":2,"cl":40}', FALSE),
(3, 'G.Skill Trident Z5 64GB DDR5 6000MHz', 'G.Skill',  980.00, 5,  '{"gb":64,"type":"DDR5","mhz":6000,"modules":2,"cl":36}', FALSE);

-- Storage
INSERT INTO products (category_id, name, brand, price, stock, specs, featured) VALUES
(4, 'Kingston A400 500GB SATA SSD',    'Kingston', 180.00, 25, '{"gb":500,"type":"SSD","interface":"SATA","read_mbs":500,"write_mbs":450}', FALSE),
(4, 'WD Blue 1TB NVMe PCIe 3.0',      'WD',       280.00, 20, '{"gb":1000,"type":"NVMe","interface":"PCIe 3.0","read_mbs":3500,"write_mbs":3000}', TRUE),
(4, 'Samsung 980 Pro 1TB NVMe PCIe 4.0','Samsung', 420.00, 15, '{"gb":1000,"type":"NVMe","interface":"PCIe 4.0","read_mbs":7000,"write_mbs":5000}', TRUE),
(4, 'WD Black 2TB NVMe PCIe 4.0',     'WD',       680.00, 10, '{"gb":2000,"type":"NVMe","interface":"PCIe 4.0","read_mbs":7300,"write_mbs":6600}', FALSE),
(4, 'Seagate Barracuda 1TB HDD',      'Seagate',  120.00, 30, '{"gb":1000,"type":"HDD","rpm":7200,"interface":"SATA"}', FALSE),
(4, 'Seagate Barracuda 2TB HDD',      'Seagate',  180.00, 25, '{"gb":2000,"type":"HDD","rpm":7200,"interface":"SATA"}', FALSE);

-- Motherboards
INSERT INTO products (category_id, name, brand, price, stock, specs, featured) VALUES
(5, 'Gigabyte B660M DS3H DDR4',      'Gigabyte', 380.00, 12, '{"socket":"LGA1700","chipset":"B660","form":"Micro-ATX","ram_type":"DDR4","max_ram_gb":128,"pcie_slots":1,"m2_slots":2}', FALSE),
(5, 'MSI PRO B760M-A DDR5',          'MSI',      520.00, 10, '{"socket":"LGA1700","chipset":"B760","form":"Micro-ATX","ram_type":"DDR5","max_ram_gb":192,"pcie_slots":1,"m2_slots":3}', TRUE),
(5, 'ASUS ROG Strix Z790-E DDR5',    'ASUS',     850.00, 6,  '{"socket":"LGA1700","chipset":"Z790","form":"ATX","ram_type":"DDR5","max_ram_gb":192,"pcie_slots":2,"m2_slots":5}', FALSE),
(5, 'MSI B550 Tomahawk',             'MSI',      340.00, 15, '{"socket":"AM4","chipset":"B550","form":"ATX","ram_type":"DDR4","max_ram_gb":128,"pcie_slots":2,"m2_slots":2}', TRUE),
(5, 'ASUS TUF Gaming X570-Plus',     'ASUS',     580.00, 8,  '{"socket":"AM4","chipset":"X570","form":"ATX","ram_type":"DDR4","max_ram_gb":128,"pcie_slots":2,"m2_slots":2}', FALSE),
(5, 'MSI MEG X670E ACE',             'MSI',      1150.00, 4, '{"socket":"AM5","chipset":"X670E","form":"ATX","ram_type":"DDR5","max_ram_gb":192,"pcie_slots":2,"m2_slots":5}', FALSE),
(5, 'Gigabyte B650 AORUS Elite AX',  'Gigabyte', 620.00, 8,  '{"socket":"AM5","chipset":"B650","form":"ATX","ram_type":"DDR5","max_ram_gb":192,"pcie_slots":2,"m2_slots":4}', TRUE);

-- PSU
INSERT INTO products (category_id, name, brand, price, stock, specs, featured) VALUES
(6, 'Corsair CV550 550W 80+ Bronze', 'Corsair', 220.00, 20, '{"watts":550,"cert":"80+ Bronze","modular":false}', FALSE),
(6, 'EVGA 650W 80+ Bronze',         'EVGA',    280.00, 18, '{"watts":650,"cert":"80+ Bronze","modular":false}', FALSE),
(6, 'Seasonic Focus GX 750W Gold',  'Seasonic', 380.00, 15, '{"watts":750,"cert":"80+ Gold","modular":true}', TRUE),
(6, 'Corsair RM850x 850W Gold',     'Corsair', 480.00, 10, '{"watts":850,"cert":"80+ Gold","modular":true}', TRUE),
(6, 'be quiet! Straight Power 1000W Platinum','be quiet!',650.00,6,'{"watts":1000,"cert":"80+ Platinum","modular":true}', FALSE);

-- Cases
INSERT INTO products (category_id, name, brand, price, stock, specs, featured) VALUES
(7, 'Thermaltake S100 TG Micro-ATX', 'Thermaltake', 150.00, 15, '{"form":"Micro-ATX","fans_included":1,"glass_panel":true,"max_gpu_mm":320}', FALSE),
(7, 'NZXT H5 Flow Mid Tower',        'NZXT',        280.00, 12, '{"form":"ATX","fans_included":2,"glass_panel":true,"max_gpu_mm":365}', TRUE),
(7, 'Corsair 4000D Airflow',         'Corsair',     320.00, 10, '{"form":"ATX","fans_included":2,"glass_panel":true,"max_gpu_mm":360}', TRUE),
(7, 'Lian Li PC-O11 Dynamic',        'Lian Li',     450.00, 8,  '{"form":"ATX","fans_included":0,"glass_panel":true,"max_gpu_mm":420}', FALSE),
(7, 'Fractal Design North',          'Fractal',     580.00, 6,  '{"form":"ATX","fans_included":2,"glass_panel":true,"max_gpu_mm":355}', FALSE);

-- Cooling
INSERT INTO products (category_id, name, brand, price, stock, specs, featured) VALUES
(8, 'Hyper 212 Black Edition (Aire)', 'Cooler Master', 80.00,  25, '{"type":"air","tdp_w":150,"fan_mm":120,"height_mm":158}', FALSE),
(8, 'DeepCool AK400 (Aire)',          'DeepCool',      180.00, 18, '{"type":"air","tdp_w":220,"fan_mm":120,"height_mm":155}', TRUE),
(8, 'Noctua NH-D15 (Aire Premium)',   'Noctua',        350.00, 8,  '{"type":"air","tdp_w":250,"fan_mm":150,"height_mm":165}', FALSE),
(8, 'Corsair H100i 240mm AIO',        'Corsair',       380.00, 12, '{"type":"liquid","tdp_w":250,"radiator_mm":240,"fans":2}', TRUE),
(8, 'Lian Li Galahad 360mm AIO',      'Lian Li',       520.00, 8,  '{"type":"liquid","tdp_w":300,"radiator_mm":360,"fans":3}', FALSE),
(8, 'NZXT Kraken Elite 360mm AIO',    'NZXT',          680.00, 5,  '{"type":"liquid","tdp_w":300,"radiator_mm":360,"fans":3}', FALSE);

-- Laptops
INSERT INTO products (category_id, name, brand, price, stock, specs, featured) VALUES
(9, 'Lenovo IdeaPad 3 15',           'Lenovo', 1800.00, 10, '{"cpu":"Ryzen 5 5500U","gpu":"Radeon Vega","ram_gb":8,"storage_gb":512,"display_in":15.6,"res":"1920x1080","battery_wh":45,"weight_kg":1.7,"use":"oficina"}', TRUE),
(9, 'ASUS VivoBook 15 X1502',        'ASUS',   1950.00, 12, '{"cpu":"Intel i5-1235U","gpu":"Intel Iris Xe","ram_gb":8,"storage_gb":512,"display_in":15.6,"res":"1920x1080","battery_wh":50,"weight_kg":1.7,"use":"oficina"}', FALSE),
(9, 'HP Pavilion Gaming 15',         'HP',     2800.00, 8,  '{"cpu":"Intel i5-12500H","gpu":"RTX 3050 4GB","ram_gb":8,"storage_gb":512,"display_in":15.6,"res":"1920x1080","hz":144,"battery_wh":52,"weight_kg":2.2,"use":"gaming"}', TRUE),
(9, 'ASUS TUF Gaming A15',           'ASUS',   3200.00, 8,  '{"cpu":"Ryzen 7 7435HS","gpu":"RTX 4060 8GB","ram_gb":16,"storage_gb":512,"display_in":15.6,"res":"1920x1080","hz":144,"battery_wh":90,"weight_kg":2.3,"use":"gaming"}', FALSE),
(9, 'Lenovo Legion 5 Pro',           'Lenovo', 4500.00, 6,  '{"cpu":"Ryzen 7 7745HX","gpu":"RTX 4060 8GB","ram_gb":16,"storage_gb":1000,"display_in":16,"res":"2560x1600","hz":165,"battery_wh":80,"weight_kg":2.4,"use":"gaming"}', TRUE),
(9, 'ASUS ROG Strix G16',            'ASUS',   6800.00, 4,  '{"cpu":"Intel i9-13980HX","gpu":"RTX 4070 8GB","ram_gb":16,"storage_gb":1000,"display_in":16,"res":"2560x1600","hz":240,"battery_wh":90,"weight_kg":2.5,"use":"gaming_premium"}', FALSE),
(9, 'Dell XPS 15 9530',              'Dell',   5800.00, 5,  '{"cpu":"Intel i7-13700H","gpu":"RTX 4060 8GB","ram_gb":16,"storage_gb":512,"display_in":15.6,"res":"3456x2160","hz":60,"battery_wh":86,"weight_kg":1.8,"use":"profesional"}', FALSE),
(9, 'Apple MacBook Air M2',          'Apple',  5500.00, 6,  '{"cpu":"Apple M2","gpu":"Apple M2 10-core GPU","ram_gb":8,"storage_gb":256,"display_in":13.6,"res":"2560x1664","battery_wh":52,"weight_kg":1.2,"use":"profesional"}', TRUE);
