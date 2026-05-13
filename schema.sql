-- ============================================================
-- PC Store Schema + Seed Data (PostgreSQL)
-- ============================================================

-- Crear DB manualmente:
-- CREATE DATABASE pcstore;

-- Conectarse a pcstore antes de ejecutar este archivo

DROP TABLE IF EXISTS builds CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

-- ── Categories ───────────────────────────────────────────────

CREATE TABLE categories (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  slug      VARCHAR(50) UNIQUE NOT NULL,
  name      VARCHAR(100) NOT NULL,
  icon      VARCHAR(50) NOT NULL
);

INSERT INTO categories (slug, name, icon) VALUES
  ('cpu',         'Procesadores',     'CPU'),
  ('gpu',         'Tarjetas de Video','GPU'),
  ('ram',         'Memoria RAM',      'RAM'),
  ('storage',     'Almacenamiento',   'SSD'),
  ('motherboard', 'Placas Madre',     'MB'),
  ('psu',         'Fuentes de Poder', 'PSU'),
  ('case',        'Gabinetes',        'CASE'),
  ('cooling',     'Refrigeración',    'COOL'),
  ('laptop',      'Laptops',          'LAP');

-- ── Products ─────────────────────────────────────────────────

CREATE TABLE products (
  id           SERIAL PRIMARY KEY,
  category_id  INT NOT NULL,
  name         VARCHAR(200) NOT NULL,
  brand        VARCHAR(100) NOT NULL,
  price        NUMERIC(10,2) NOT NULL,
  stock        INT NOT NULL DEFAULT 0,
  specs        JSON,
  image_url    TEXT,
  featured     BOOLEAN DEFAULT FALSE,
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_category
    FOREIGN KEY (category_id)
    REFERENCES categories(id)
    ON DELETE CASCADE
);

-- ── Builds ───────────────────────────────────────────────────

CREATE TABLE builds (
  id          SERIAL PRIMARY KEY,
  use_case    TEXT NOT NULL,
  budget      NUMERIC(10,2) NOT NULL,
  result_json JSON NOT NULL,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- SEED DATA (precios en soles peruanos)
-- ============================================================

-- CPUs
INSERT INTO products (category_id, name, brand, price, stock, specs, image_url, featured) VALUES
(1, 'Intel Core i3-12100F', 'Intel', 380.00, 15, '{"cores":4,"threads":8,"base_ghz":3.3,"boost_ghz":4.3,"tdp":58,"socket":"LGA1700","gen":"12va Gen"}', 'https://c1.neweggimages.com/productimage/nb1280/19-118-357-03.jpg', FALSE),
(1, 'Intel Core i5-12400F', 'Intel', 650.00, 20, '{"cores":6,"threads":12,"base_ghz":2.5,"boost_ghz":4.4,"tdp":65,"socket":"LGA1700","gen":"12va Gen"}', 'https://www.bhphotovideo.com/images/images500x500/intel_bx8071512400f_core_i5_12400f_desktop_processor_1641301554_1675542.jpg', TRUE),
(1, 'Intel Core i5-13600K', 'Intel', 950.00, 12, '{"cores":14,"threads":20,"base_ghz":3.5,"boost_ghz":5.1,"tdp":125,"socket":"LGA1700","gen":"13va Gen"}', 'https://www.bhphotovideo.com/images/images500x500/intel_bx8071513600k_core_i5_13600k_3_5_ghz_1664553928_1721752.jpg', TRUE),
(1, 'Intel Core i7-13700K', 'Intel', 1450.00, 8, '{"cores":16,"threads":24,"base_ghz":3.4,"boost_ghz":5.4,"tdp":125,"socket":"LGA1700","gen":"13va Gen"}', 'https://m.media-amazon.com/images/I/61S3yB-fXDL.jpg', FALSE),
(1, 'Intel Core i9-13900K', 'Intel', 2200.00, 5, '{"cores":24,"threads":32,"base_ghz":3.0,"boost_ghz":5.8,"tdp":125,"socket":"LGA1700","gen":"13va Gen"}', 'https://m.media-amazon.com/images/I/61fIq0GqfFL.jpg', FALSE),
(1, 'AMD Ryzen 5 5600', 'AMD', 580.00, 18, '{"cores":6,"threads":12,"base_ghz":3.5,"boost_ghz":4.4,"tdp":65,"socket":"AM4","gen":"Zen 3"}', 'https://c1.neweggimages.com/productimage/nb640/A25VD2308170HWGSB01.jpg', TRUE),
(1, 'AMD Ryzen 5 7600X', 'AMD', 890.00, 14, '{"cores":6,"threads":12,"base_ghz":4.7,"boost_ghz":5.3,"tdp":105,"socket":"AM5","gen":"Zen 4"}', 'https://c1.neweggimages.com/productimage/nb640/19-113-770-02.jpg', TRUE),
(1, 'AMD Ryzen 7 7700X', 'AMD', 1350.00, 9, '{"cores":8,"threads":16,"base_ghz":4.5,"boost_ghz":5.4,"tdp":105,"socket":"AM5","gen":"Zen 4"}', 'https://m.media-amazon.com/images/I/51AAt5v+54L.jpg', FALSE),
(1, 'AMD Ryzen 9 7900X', 'AMD', 1980.00, 5, '{"cores":12,"threads":24,"base_ghz":4.7,"boost_ghz":5.6,"tdp":170,"socket":"AM5","gen":"Zen 4"}', 'https://m.media-amazon.com/images/I/51idX-E6v0L.jpg', FALSE),
(1, 'Intel Core i3-13100F', 'Intel', 220.00, 25, '{"cores":4,"threads":8,"base_ghz":3.4,"boost_ghz":4.5,"tdp":54,"socket":"LGA1700","gen":"13va Gen"}', 'https://c1.neweggimages.com/productimage/nb640/19-118-424-03.jpg', FALSE),
(1, 'Intel Core i5-13400F', 'Intel', 420.00, 20, '{"cores":10,"threads":16,"base_ghz":2.5,"boost_ghz":4.6,"tdp":65,"socket":"LGA1700","gen":"13va Gen"}', 'https://c1.neweggimages.com/productimage/nb640/19-118-422-03.jpg', TRUE),
(1, 'Intel Core i7-13700F', 'Intel', 890.00, 12, '{"cores":16,"threads":24,"base_ghz":2.1,"boost_ghz":5.2,"tdp":65,"socket":"LGA1700","gen":"13va Gen"}', 'https://c1.neweggimages.com/productimage/nb640/19-118-428-04.jpg', FALSE),
(1, 'AMD Ryzen 5 7500F', 'AMD', 280.00, 18, '{"cores":6,"threads":12,"base_ghz":3.7,"boost_ghz":5.0,"tdp":65,"socket":"AM5","gen":"Zen 4"}', 'https://c1.neweggimages.com/productimage/nb640/ASGMS2408280722CT08.jpg', TRUE),
(1, 'AMD Ryzen 7 7800X3D', 'AMD', 620.00, 10, '{"cores":8,"threads":16,"base_ghz":4.2,"boost_ghz":5.0,"tdp":120,"socket":"AM5","gen":"Zen 4"}', 'https://c1.neweggimages.com/productimage/nb640/19-113-793-03.jpg', TRUE),
(1, 'AMD Ryzen 9 7950X3D', 'AMD', 980.00, 6,  '{"cores":16,"threads":32,"base_ghz":4.2,"boost_ghz":5.7,"tdp":120,"socket":"AM5","gen":"Zen 4"}', 'https://c1.neweggimages.com/productimage/nb640/A25VD2305090NOXCW72.jpg', FALSE);
-- GPUs
INSERT INTO products (category_id, name, brand, price, stock, specs, image_url, featured) VALUES
(2, 'AMD RX 6600 XT 8GB', 'AMD', 950.00, 12, '{"vram_gb":8,"type":"GDDR6","bus":128,"tdp":160,"connectors":1}', 'https://www.bhphotovideo.com/images/images500x500/xfx_rx_66xt8lbdq_radeon_rx_6600_xt_1628678125_1657927.jpg', FALSE),
(2, 'NVIDIA RTX 3060 12GB', 'NVIDIA', 1100.00, 15, '{"vram_gb":12,"type":"GDDR6","bus":192,"tdp":170,"connectors":1}', 'https://m.media-amazon.com/images/I/71Yf9S0+p-L.jpg', TRUE),
(2, 'AMD RX 6700 XT 12GB', 'AMD', 1280.00, 10, '{"vram_gb":12,"type":"GDDR6","bus":192,"tdp":230,"connectors":1}', 'https://c1.neweggimages.com/productimage/nb640/14-137-641-01.jpg', FALSE),
(2, 'NVIDIA RTX 3060 Ti 8GB', 'NVIDIA', 1350.00, 10, '{"vram_gb":8,"type":"GDDR6","bus":256,"tdp":200,"connectors":1}', 'https://c1.neweggimages.com/productimage/nb640/ADFRD2203300ZKVMP32.jpg', FALSE),
(2, 'NVIDIA RTX 4060 8GB', 'NVIDIA', 1450.00, 18, '{"vram_gb":8,"type":"GDDR6X","bus":128,"tdp":115,"connectors":1}', 'https://m.media-amazon.com/images/I/71m6qD-h0NL.jpg', TRUE),
(2, 'AMD RX 7700 XT 12GB', 'AMD', 1650.00, 8,  '{"vram_gb":12,"type":"GDDR6","bus":192,"tdp":245,"connectors":1}', 'https://c1.neweggimages.com/productimage/nb640/14-930-109-09.jpg', FALSE),
(2, 'NVIDIA RTX 4070 12GB', 'NVIDIA', 2100.00, 10, '{"vram_gb":12,"type":"GDDR6X","bus":192,"tdp":200,"connectors":1}', 'https://c1.neweggimages.com/productimage/nb640/BG5RS230428101XA302.jpg', TRUE),
(2, 'NVIDIA RTX 4070 Ti Super 16GB','NVIDIA',3200.00, 6, '{"vram_gb":16,"type":"GDDR6X","bus":256,"tdp":285,"connectors":1}', 'https://c1.neweggimages.com/productimage/nb640/AHEBS2412020SBCHZ6D.jpg', FALSE),
(2, 'NVIDIA RTX 4080 16GB', 'NVIDIA', 4500.00, 4,  '{"vram_gb":16,"type":"GDDR6X","bus":256,"tdp":320,"connectors":1}', 'https://m.media-amazon.com/images/I/81xU2p6vXKL.jpg', FALSE),
(2, 'NVIDIA RTX 4060 Ti 8GB', 'NVIDIA', 750.00, 20, '{"vram_gb":8,"type":"GDDR6X","bus":128,"tdp":115,"connectors":1}', 'https://m.media-amazon.com/images/I/71uV+q+yXPL.jpg', TRUE),
(2, 'AMD RX 7600 XT 8GB', 'AMD', 480.00, 18, '{"vram_gb":8,"type":"GDDR6","bus":128,"tdp":160,"connectors":1}', 'https://c1.neweggimages.com/productimage/nb640/14-131-861-11.png', FALSE),
(2, 'NVIDIA RTX 4070 Ti 12GB', 'NVIDIA', 1050.00, 15, '{"vram_gb":12,"type":"GDDR6X","bus":192,"tdp":200,"connectors":1}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg', TRUE),
(2, 'AMD RX 7900 XTX 24GB', 'AMD', 1450.00, 10, '{"vram_gb":24,"type":"GDDR6","bus":384,"tdp":355,"connectors":1}', 'https://m.media-amazon.com/images/I/81xU2p6vXKL.jpg', FALSE),
(2, 'NVIDIA RTX 4090 24GB', 'NVIDIA', 2850.00, 5,  '{"vram_gb":24,"type":"GDDR6X","bus":384,"tdp":450,"connectors":1}', 'https://m.media-amazon.com/images/I/71uV+q+yXPL.jpg', FALSE),
(2, 'AMD RX 7700 XT 12GB', 'AMD', 620.00, 12, '{"vram_gb":12,"type":"GDDR6","bus":192,"tdp":245,"connectors":1}', 'https://c1.neweggimages.com/productimage/nb640/14-930-109-09.jpg', TRUE);
-- RAM
INSERT INTO products (category_id, name, brand, price, stock, specs, image_url, featured) VALUES
(3, 'Kingston Fury 8GB DDR4 3200MHz', 'Kingston', 120.00, 30, '{"gb":8,"type":"DDR4","mhz":3200,"modules":1,"cl":16}', 'https://media.kingston.com/kingston/product/FURY_Beast_Black_DDR4_1R_1-tn.png', FALSE),
(3, 'Corsair Vengeance 16GB DDR4 3200MHz', 'Corsair',  220.00, 25, '{"gb":16,"type":"DDR4","mhz":3200,"modules":2,"cl":16}', 'https://m.media-amazon.com/images/I/71W2bB1y9-L.jpg', TRUE),
(3, 'G.Skill Ripjaws 32GB DDR4 3600MHz', 'G.Skill',  380.00, 15, '{"gb":32,"type":"DDR4","mhz":3600,"modules":2,"cl":18}', 'https://c1.neweggimages.com/productimage/nb640/20-232-731-Z01.jpg', TRUE),
(3, 'Kingston Fury 16GB DDR5 4800MHz', 'Kingston', 320.00, 20, '{"gb":16,"type":"DDR5","mhz":4800,"modules":2,"cl":40}', 'https://c1.neweggimages.com/productimage/nb640/20-242-651-S01.jpg', FALSE),
(3, 'Corsair Dominator 32GB DDR5 5200MHz', 'Corsair',  520.00, 10, '{"gb":32,"type":"DDR5","mhz":5200,"modules":2,"cl":40}', 'https://c1.neweggimages.com/productimage/nb640/20-236-840-07.jpg', FALSE),
(3, 'G.Skill Trident Z5 64GB DDR5 6000MHz', 'G.Skill',  980.00, 5,  '{"gb":64,"type":"DDR5","mhz":6000,"modules":2,"cl":36}', 'https://c1.neweggimages.com/productimage/nb640/20-374-445-11.jpg', FALSE),
(3, 'Corsair Vengeance 8GB DDR4 2666MHz',  'Corsair',  90.00,  35, '{"gb":8,"type":"DDR4","mhz":2666,"modules":1,"cl":16}', 'https://m.media-amazon.com/images/I/61m9x6266UL.jpg', FALSE),
(3, 'Kingston Beast 16GB DDR4 3600MHz', 'Kingston', 160.00, 30, '{"gb":16,"type":"DDR4","mhz":3600,"modules":2,"cl":18}', 'https://m.media-amazon.com/images/I/71R2o5-E56L.jpg', TRUE),
(3, 'G.Skill Ripjaws V 32GB DDR4 3200MHz', 'G.Skill',  280.00, 20, '{"gb":32,"type":"DDR4","mhz":3200,"modules":2,"cl":16}', 'https://c1.neweggimages.com/productimage/nb640/20-232-091-08.jpg', TRUE),
(3, 'Corsair Vengeance 32GB DDR5 5600MHz', 'Corsair',  420.00, 18, '{"gb":32,"type":"DDR5","mhz":5600,"modules":2,"cl":36}', 'https://m.media-amazon.com/images/I/61RbeuY+uQL.jpg', FALSE),
(3, 'Kingston Fury Beast 64GB DDR5 5200MHz','Kingston', 680.00, 12, '{"gb":64,"type":"DDR5","mhz":5200,"modules":2,"cl":40}', 'https://m.media-amazon.com/images/I/71Z16K+Z+CL.jpg', FALSE),
(3, 'G.Skill Trident Z5 RGB 16GB DDR5 7200MHz','G.Skill',320.00,15, '{"gb":16,"type":"DDR5","mhz":7200,"modules":2,"cl":34}', 'https://c1.neweggimages.com/productimage/nb640/20-374-473-01.jpg', TRUE),
(3, 'Corsair Dominator Platinum 32GB DDR5 6000MHz','Corsair',550.00,10, '{"gb":32,"type":"DDR5","mhz":6000,"modules":2,"cl":38}', 'https://m.media-amazon.com/images/I/61k1qV1HnWL.jpg', FALSE),
(3, 'TeamGroup T-Force Delta RGB 16GB DDR4 3600MHz','TeamGroup',140.00,25, '{"gb":16,"type":"DDR4","mhz":3600,"modules":2,"cl":18}', 'https://m.media-amazon.com/images/I/71m6qD-h0NL.jpg', TRUE),
(3, 'Kingston Fury Renegade 32GB DDR5 6400MHz','Kingston',720.00,8,  '{"gb":32,"type":"DDR5","mhz":6400,"modules":2,"cl":40}', 'https://m.media-amazon.com/images/I/61Mv44v2r9L.jpg', FALSE);
-- Storage
INSERT INTO products (category_id, name, brand, price, stock, specs, image_url, featured) VALUES
(4, 'Kingston A400 500GB SATA SSD', 'Kingston', 180.00, 25, '{"gb":500,"type":"SSD","interface":"SATA","read_mbs":500,"write_mbs":450}', 'https://shop.kingston.com/cdn/shop/products/A400-main_small.jpg?v=1665784648', FALSE),
(4, 'WD Blue 1TB NVMe PCIe 3.0', 'WD', 280.00, 20, '{"gb":1000,"type":"NVMe","interface":"PCIe 3.0","read_mbs":3500,"write_mbs":3000}', 'https://m.media-amazon.com/images/I/61p-LqV2uGL.jpg', TRUE),
(4, 'Samsung 980 Pro 1TB NVMe PCIe 4.0','Samsung', 420.00, 15, '{"gb":1000,"type":"NVMe","interface":"PCIe 4.0","read_mbs":7000,"write_mbs":5000}', 'https://c1.neweggimages.com/productimage/nb640/20-147-790-V01.jpg', TRUE),
(4, 'WD Black 2TB NVMe PCIe 4.0', 'WD', 680.00, 10, '{"gb":2000,"type":"NVMe","interface":"PCIe 4.0","read_mbs":7300,"write_mbs":6600}', 'https://m.media-amazon.com/images/I/61f7K3vX5qL.jpg', FALSE),
(4, 'Seagate Barracuda 1TB HDD', 'Seagate',  120.00, 30, '{"gb":1000,"type":"HDD","rpm":7200,"interface":"SATA"}', 'https://m.media-amazon.com/images/I/7163-kQpQSL.jpg', FALSE),
(4, 'Seagate Barracuda 2TB HDD', 'Seagate',  180.00, 25, '{"gb":2000,"type":"HDD","rpm":7200,"interface":"SATA"}', 'https://m.media-amazon.com/images/I/71S9UeR2JvL.jpg', FALSE),
(4, 'Samsung 870 EVO 500GB SATA SSD', 'Samsung',  95.00,  40, '{"gb":500,"type":"SSD","interface":"SATA","read_mbs":560,"write_mbs":530}', 'https://m.media-amazon.com/images/I/911ujeChgoL.jpg', FALSE),
(4, 'WD Black SN850X 1TB NVMe', 'WD', 140.00, 25, '{"gb":1000,"type":"NVMe","interface":"PCIe 4.0","read_mbs":7300,"write_mbs":6600}', 'https://m.media-amazon.com/images/I/61f7K3vX5qL.jpg', TRUE),
(4, 'Seagate FireCuda 530 2TB NVMe', 'Seagate',  280.00, 15, '{"gb":2000,"type":"NVMe","interface":"PCIe 4.0","read_mbs":7300,"write_mbs":6900}', 'https://m.media-amazon.com/images/I/61Y-54m8KSL.jpg', FALSE),
(4, 'Corsair MP600 Pro 4TB NVMe', 'Corsair',  680.00, 8,  '{"gb":4000,"type":"NVMe","interface":"PCIe 4.0","read_mbs":7100,"write_mbs":6800}', 'https://m.media-amazon.com/images/I/71F7X2tK2YL.jpg', FALSE),
(4, 'Kingston NV2 500GB NVMe', 'Kingston', 65.00,  45, '{"gb":500,"type":"NVMe","interface":"PCIe 4.0","read_mbs":3500,"write_mbs":2100}', 'https://m.media-amazon.com/images/I/61LpS6mKx6L.jpg', TRUE),
(4, 'Samsung 990 Pro 2TB NVMe', 'Samsung',  320.00, 12, '{"gb":2000,"type":"NVMe","interface":"PCIe 4.0","read_mbs":7450,"write_mbs":6900}', 'https://m.media-amazon.com/images/I/71f7K3vX5qL.jpg', TRUE),
(4, 'WD Blue 4TB HDD', 'WD', 120.00, 30, '{"gb":4000,"type":"HDD","rpm":5400,"interface":"SATA"}', 'https://m.media-amazon.com/images/I/81I-F+oI6YL.jpg', FALSE),
(4, 'Seagate Barracuda 4TB HDD', 'Seagate',  130.00, 28, '{"gb":4000,"type":"HDD","rpm":5900,"interface":"SATA"}', 'https://m.media-amazon.com/images/I/7163-kQpQSL.jpg', FALSE),
(4, 'Kingston Canvas React Plus 256GB microSD','Kingston',45.00,50, '{"gb":0.25,"type":"microSD","class":"U3","speed":170}', 'https://m.media-amazon.com/images/I/71L+P7VvEQL.jpg', TRUE),
(4, 'Samsung Portable SSD T7 1TB', 'Samsung',  180.00, 20, '{"gb":1000,"type":"SSD","interface":"USB-C","read_mbs":1050,"write_mbs":1000}', 'https://m.media-amazon.com/images/I/61S-7G8H2CL.jpg', FALSE);
-- Motherboards
INSERT INTO products (category_id, name, brand, price, stock, specs, image_url, featured) VALUES
(5, 'Gigabyte B660M DS3H DDR4', 'Gigabyte', 380.00, 12, '{"socket":"LGA1700","chipset":"B660","form":"Micro-ATX","ram_type":"DDR4","max_ram_gb":128,"pcie_slots":1,"m2_slots":2}', 'https://www.bhphotovideo.com/images/images500x500/gigabyte_b660m_ds3h_ddr4_motherboard_1643239214_1681732.jpg', FALSE),
(5, 'MSI PRO B760M-A DDR5', 'MSI', 520.00, 10, '{"socket":"LGA1700","chipset":"B760","form":"Micro-ATX","ram_type":"DDR5","max_ram_gb":192,"pcie_slots":1,"m2_slots":3}', 'https://m.media-amazon.com/images/I/81xU-7+G-YL.jpg', TRUE),
(5, 'ASUS ROG Strix Z790-E DDR5', 'ASUS', 850.00, 6,  '{"socket":"LGA1700","chipset":"Z790","form":"ATX","ram_type":"DDR5","max_ram_gb":192,"pcie_slots":2,"m2_slots":5}', 'https://m.media-amazon.com/images/I/81uK0uP6vEL.jpg', FALSE),
(5, 'MSI B550 Tomahawk', 'MSI', 340.00, 15, '{"socket":"AM4","chipset":"B550","form":"ATX","ram_type":"DDR4","max_ram_gb":128,"pcie_slots":2,"m2_slots":2}', 'https://m.media-amazon.com/images/I/81x-9M0v2nL.jpg', TRUE),
(5, 'ASUS TUF Gaming X570-Plus', 'ASUS', 580.00, 8,  '{"socket":"AM4","chipset":"X570","form":"ATX","ram_type":"DDR4","max_ram_gb":128,"pcie_slots":2,"m2_slots":2}', 'https://m.media-amazon.com/images/I/91r6-6L3v9L.jpg', FALSE),
(5, 'MSI MEG X670E ACE', 'MSI', 1150.00, 4, '{"socket":"AM5","chipset":"X670E","form":"ATX","ram_type":"DDR5","max_ram_gb":192,"pcie_slots":2,"m2_slots":5}', 'https://m.media-amazon.com/images/I/81Xz6+fHqKL.jpg', FALSE),
(5, 'Gigabyte B650 AORUS Elite AX', 'Gigabyte', 620.00, 8,  '{"socket":"AM5","chipset":"B650","form":"ATX","ram_type":"DDR5","max_ram_gb":192,"pcie_slots":2,"m2_slots":4}', 'https://m.media-amazon.com/images/I/81W2Z2vIuFL.jpg', TRUE),
(5, 'ASUS TUF Gaming B650M-PLUS', 'ASUS', 220.00, 20, '{"socket":"AM5","chipset":"B650","form":"Micro-ATX","ram_type":"DDR5","max_ram_gb":128,"pcie_slots":1,"m2_slots":2}', 'https://m.media-amazon.com/images/I/81U-6P2ySCL.jpg', TRUE),
(5, 'MSI MAG B650 Tomahawk WiFi', 'MSI', 280.00, 18, '{"socket":"AM5","chipset":"B650","form":"ATX","ram_type":"DDR5","max_ram_gb":192,"pcie_slots":2,"m2_slots":2}', 'https://m.media-amazon.com/images/I/81E6M1XvGXL.jpg', FALSE),
(5, 'Gigabyte B760M DS3H DDR4', 'Gigabyte', 190.00, 25, '{"socket":"LGA1700","chipset":"B760","form":"Micro-ATX","ram_type":"DDR4","max_ram_gb":128,"pcie_slots":1,"m2_slots":2}', 'https://m.media-amazon.com/images/I/81p-7+fG-YL.jpg', TRUE),
(5, 'ASUS ROG Strix B760-G Gaming', 'ASUS', 260.00, 15, '{"socket":"LGA1700","chipset":"B760","form":"ATX","ram_type":"DDR4","max_ram_gb":128,"pcie_slots":2,"m2_slots":2}', 'https://m.media-amazon.com/images/I/81uK0uP6vEL.jpg', FALSE),
(5, 'MSI PRO Z790-A WiFi', 'MSI', 380.00, 12, '{"socket":"LGA1700","chipset":"Z790","form":"ATX","ram_type":"DDR5","max_ram_gb":192,"pcie_slots":2,"m2_slots":3}', 'https://m.media-amazon.com/images/I/81p-7+fG-YL.jpg', TRUE),
(5, 'ASUS ProArt X670E-Creator WiFi','ASUS', 680.00, 8,  '{"socket":"AM5","chipset":"X670E","form":"ATX","ram_type":"DDR5","max_ram_gb":192,"pcie_slots":2,"m2_slots":4}', 'https://m.media-amazon.com/images/I/81uK0uP6vEL.jpg', FALSE),
(5, 'Gigabyte X670 AORUS Pro', 'Gigabyte', 420.00, 10, '{"socket":"AM5","chipset":"X670","form":"ATX","ram_type":"DDR5","max_ram_gb":192,"pcie_slots":3,"m2_slots":2}', 'https://m.media-amazon.com/images/I/81W2Z2vIuFL.jpg', TRUE),
(5, 'MSI MEG Z790 ACE MAX', 'MSI', 850.00, 6,  '{"socket":"LGA1700","chipset":"Z790","form":"E-ATX","ram_type":"DDR5","max_ram_gb":256,"pcie_slots":4,"m2_slots":5}', 'https://m.media-amazon.com/images/I/81Xz6+fHqKL.jpg', FALSE),
(5, 'ASUS ROG Crosshair X670E Hero', 'ASUS', 780.00, 5,  '{"socket":"AM5","chipset":"X670E","form":"ATX","ram_type":"DDR5","max_ram_gb":192,"pcie_slots":3,"m2_slots":4}', 'https://m.media-amazon.com/images/I/81uK0uP6vEL.jpg', TRUE);
-- PSU
INSERT INTO products (category_id, name, brand, price, stock, specs, image_url, featured) VALUES
(6, 'Corsair CV550 550W 80+ Bronze', 'Corsair', 220.00, 20, '{"watts":550,"cert":"80+ Bronze","modular":false}', 'https://m.media-amazon.com/images/I/61r5hG6MvWL.jpg', FALSE),
(6, 'EVGA 650W 80+ Bronze', 'EVGA', 280.00, 18, '{"watts":650,"cert":"80+ Bronze","modular":false}', 'https://m.media-amazon.com/images/I/71hU767n9DL.jpg', FALSE),
(6, 'Seasonic Focus GX 750W Gold', 'Seasonic', 380.00, 15, '{"watts":750,"cert":"80+ Gold","modular":true}', 'https://m.media-amazon.com/images/I/71v4uU6o6EL.jpg', TRUE),
(6, 'Corsair RM850x 850W Gold', 'Corsair', 480.00, 10, '{"watts":850,"cert":"80+ Gold","modular":true}', 'https://m.media-amazon.com/images/I/71r5hG6MvWL.jpg', TRUE),
(6, 'be quiet! Straight Power 1000W Platinum','be quiet!',650.00,6,'{"watts":1000,"cert":"80+ Platinum","modular":true}', 'https://m.media-amazon.com/images/I/71R2o5-E56L.jpg', FALSE),
(6, 'Corsair CX450 450W 80+ Bronze', 'Corsair',  85.00,  30, '{"watts":450,"cert":"80+ Bronze","modular":false}', 'https://m.media-amazon.com/images/I/61r5hG6MvWL.jpg', FALSE),
(6, 'EVGA 500W 80+ White', 'EVGA',  65.00,  35, '{"watts":500,"cert":"80+ White","modular":false}', 'https://m.media-amazon.com/images/I/71hU767n9DL.jpg', FALSE),
(6, 'Seasonic S12III 650W 80+ Bronze', 'Seasonic', 95.00,  25, '{"watts":650,"cert":"80+ Bronze","modular":false}', 'https://m.media-amazon.com/images/I/71v4uU6o6EL.jpg', FALSE),
(6, 'Corsair RM750x 750W 80+ Gold', 'Corsair', 140.00, 18, '{"watts":750,"cert":"80+ Gold","modular":true}', 'https://m.media-amazon.com/images/I/71r5hG6MvWL.jpg', TRUE),
(6, 'be quiet! Pure Power 11 800W 80+ Gold','be quiet!',130.00,15, '{"watts":800,"cert":"80+ Gold","modular":true}', 'https://m.media-amazon.com/images/I/71R2o5-E56L.jpg', FALSE),
(6, 'EVGA SuperNOVA 850 G5 850W 80+ Gold','EVGA',  180.00,12, '{"watts":850,"cert":"80+ Gold","modular":true}', 'https://m.media-amazon.com/images/I/71hU767n9DL.jpg', TRUE),
(6, 'Seasonic Focus GX-650 650W 80+ Gold','Seasonic',110.00,20, '{"watts":650,"cert":"80+ Gold","modular":true}', 'https://m.media-amazon.com/images/I/71v4uU6o6EL.jpg', FALSE),
(6, 'Corsair HF850 850W 80+ Gold', 'Corsair', 220.00,10, '{"watts":850,"cert":"80+ Gold","modular":true}', 'https://m.media-amazon.com/images/I/71r5hG6MvWL.jpg', FALSE),
(6, 'EVGA SuperNOVA 1000 G5 1000W 80+ Gold','EVGA', 250.00, 8, '{"watts":1000,"cert":"80+ Gold","modular":true}', 'https://m.media-amazon.com/images/I/71hU767n9DL.jpg', FALSE),
(6, 'be quiet! Dark Power Pro 12 1200W 80+ Gold','be quiet!',320.00,6, '{"watts":1200,"cert":"80+ Gold","modular":true}', 'https://m.media-amazon.com/images/I/71R2o5-E56L.jpg', TRUE),
(6, 'Corsair AX1600i 1600W 80+ Titanium','Corsair',480.00,5,  '{"watts":1600,"cert":"80+ Titanium","modular":true}', 'https://m.media-amazon.com/images/I/61r5hG6MvWL.jpg', FALSE);
-- Cases
INSERT INTO products (category_id, name, brand, price, stock, specs, image_url, featured) VALUES
(7, 'Thermaltake S100 TG Micro-ATX', 'Thermaltake', 150.00, 15, '{"form":"Micro-ATX","fans_included":1,"glass_panel":true,"max_gpu_mm":320}', 'https://m.media-amazon.com/images/I/71R2o5-E56L.jpg', FALSE),
(7, 'NZXT H5 Flow Mid Tower', 'NZXT', 280.00, 12, '{"form":"ATX","fans_included":2,"glass_panel":true,"max_gpu_mm":365}', 'https://c1.neweggimages.com/productimage/nb640/11-146-365-04.png', TRUE),
(7, 'Corsair 4000D Airflow', 'Corsair', 320.00, 10, '{"form":"ATX","fans_included":2,"glass_panel":true,"max_gpu_mm":360}', 'https://m.media-amazon.com/images/I/71m6a+F9P0L.jpg', TRUE),
(7, 'Lian Li PC-O11 Dynamic', 'Lian Li', 450.00, 8,  '{"form":"ATX","fans_included":0,"glass_panel":true,"max_gpu_mm":420}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg', FALSE),
(7, 'Fractal Design North', 'Fractal', 580.00, 6,  '{"form":"ATX","fans_included":2,"glass_panel":true,"max_gpu_mm":355}', 'https://m.media-amazon.com/images/I/71f7K3vX5qL.jpg', FALSE),
(7, 'NZXT H510 Elite Mid Tower', 'NZXT', 160.00, 15, '{"form":"ATX","fans_included":2,"glass_panel":true,"max_gpu_mm":380}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg', TRUE),
(7, 'Corsair 4000D RGB Airflow', 'Corsair', 380.00, 12, '{"form":"ATX","fans_included":3,"glass_panel":true,"max_gpu_mm":360}', 'https://m.media-amazon.com/images/I/71m6a+F9P0L.jpg', FALSE),
(7, 'Lian Li Lancool 216 Mesh', 'Lian Li', 140.00, 20, '{"form":"Mid Tower","fans_included":3,"glass_panel":true,"max_gpu_mm":380}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg', TRUE),
(7, 'Thermaltake Tower 900', 'Thermaltake', 420.00, 8,  '{"form":"Full Tower","fans_included":3,"glass_panel":true,"max_gpu_mm":450}', 'https://m.media-amazon.com/images/I/71R2o5-E56L.jpg', FALSE),
(7, 'Phanteks Eclipse P600S', 'Phanteks', 220.00, 15, '{"form":"Mid Tower","fans_included":2,"glass_panel":true,"max_gpu_mm":410}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg', TRUE),
(7, 'Corsair iCUE 4000X RGB', 'Corsair', 320.00, 10, '{"form":"Mid Tower","fans_included":3,"glass_panel":true,"max_gpu_mm":380}', 'https://m.media-amazon.com/images/I/71m6a+F9P0L.jpg', FALSE),
(7, 'Lian Li O11D EVO XL', 'Lian Li', 380.00, 8,  '{"form":"Full Tower","fans_included":0,"glass_panel":true,"max_gpu_mm":450}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg', TRUE),
(7, 'NZXT H7 Flow Mid Tower', 'NZXT', 200.00, 12, '{"form":"ATX","fans_included":2,"glass_panel":true,"max_gpu_mm":410}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg', FALSE),
(7, 'Thermaltake Versa H26 Window', 'Thermaltake', 90.00,  25, '{"form":"Micro-ATX","fans_included":2,"glass_panel":true,"max_gpu_mm":320}', 'https://m.media-amazon.com/images/I/71R2o5-E56L.jpg', TRUE),
(7, 'Corsair 7000D Airflow', 'Corsair', 420.00, 8,  '{"form":"Full Tower","fans_included":3,"glass_panel":true,"max_gpu_mm":450}', 'https://m.media-amazon.com/images/I/71m6a+F9P0L.jpg', FALSE),
(7, 'Lian Li PC-O11D EVO RGB', 'Lian Li', 480.00, 6,  '{"form":"ATX","fans_included":0,"glass_panel":true,"max_gpu_mm":420}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg', TRUE);
-- Cooling
INSERT INTO products (category_id, name, brand, price, stock, specs, image_url, featured) VALUES
(8, 'Hyper 212 Black Edition (Aire)', 'Cooler Master', 80.00,  25, '{"type":"air","tdp_w":150,"fan_mm":120,"height_mm":158}', 'https://m.media-amazon.com/images/I/71R2o5-E56L.jpg', FALSE),
(8, 'DeepCool AK400 (Aire)', 'DeepCool', 180.00, 18, '{"type":"air","tdp_w":220,"fan_mm":120,"height_mm":155}', 'https://c1.neweggimages.com/productimage/nb640/35-856-203-V01.jpg', TRUE),
(8, 'Noctua NH-D15 (Aire Premium)', 'Noctua', 350.00, 8,  '{"type":"air","tdp_w":250,"fan_mm":150,"height_mm":165}', 'https://c1.neweggimages.com/productimage/nb640/35-608-045-V02.jpg', FALSE),
(8, 'Corsair H100i 240mm AIO', 'Corsair', 380.00, 12, '{"type":"liquid","tdp_w":250,"radiator_mm":240,"fans":2}', 'https://c1.neweggimages.com/productimage/nb640/35-181-141-V01.jpg', TRUE),
(8, 'Lian Li Galahad 360mm AIO', 'Lian Li', 520.00, 8,  '{"type":"liquid","tdp_w":300,"radiator_mm":360,"fans":3}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg', FALSE),
(8, 'NZXT Kraken Elite 360mm AIO', 'NZXT', 680.00, 5,  '{"type":"liquid","tdp_w":300,"radiator_mm":360,"fans":3}', 'https://c1.neweggimages.com/productimage/nb640/35-146-164-01.jpg', FALSE),
(8, 'Cooler Master Hyper 212 RGB Black Edition','Cooler Master',95.00, 20, '{"type":"air","tdp_w":150,"fan_mm":120,"height_mm":158}', 'https://m.media-amazon.com/images/I/71R2o5-E56L.jpg', FALSE),
(8, 'DeepCool LS520 SE 240mm AIO', 'DeepCool', 220.00, 15, '{"type":"liquid","tdp_w":250,"radiator_mm":240,"fans":2}', 'https://c1.neweggimages.com/productimage/nb640/35-856-203-V01.jpg', TRUE),
(8, 'Noctua NH-U12S redux (Aire)', 'Noctua', 70.00,  25, '{"type":"air","tdp_w":130,"fan_mm":120,"height_mm":158}', 'https://c1.neweggimages.com/productimage/nb640/35-608-045-V02.jpg', FALSE),
(8, 'Corsair iCUE H150i Elite Capellix 360mm AIO','Corsair',220.00,12, '{"type":"liquid","tdp_w":300,"radiator_mm":360,"fans":3}', 'https://c1.neweggimages.com/productimage/nb640/35-181-141-V01.jpg', TRUE),
(8, 'be quiet! Silent Wings 4 120mm PWM','be quiet!', 25.00,  50, '{"type":"fan","size_mm":120,"rpm_max":1800,"cfm":75.5}', 'https://m.media-amazon.com/images/I/71R2o5-E56L.jpg', FALSE),
(8, 'Noctua NF-A12x25 PWM (2-pack)', 'Noctua', 45.00,  30, '{"type":"fan","size_mm":120,"rpm_max":2000,"cfm":92.5}', 'https://c1.neweggimages.com/productimage/nb640/35-608-045-V02.jpg', TRUE),
(8, 'DeepCool AG400 (Aire)', 'DeepCool', 110.00, 20, '{"type":"air","tdp_w":180,"fan_mm":120,"height_mm":155}', 'https://c1.neweggimages.com/productimage/nb640/35-856-203-V01.jpg', FALSE),
(8, 'Corsair H150i Elite Capellix 360mm AIO (White)','Corsair',230.00,10, '{"type":"liquid","tdp_w":300,"radiator_mm":360,"fans":3}', 'https://c1.neweggimages.com/productimage/nb640/35-181-141-V01.jpg', FALSE),
(8, 'Arctic Liquid Freezer III 360mm AIO','Arctic', 180.00, 15, '{"type":"liquid","tdp_w":300,"radiator_mm":360,"fans":3}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg', TRUE),
(8, 'Cooler Master MasterFan MF120R ARGB','Cooler Master',22.00, 40, '{"type":"fan","size_mm":120,"rgb":true,"rpm_max":1500,"cfm":65.3}', 'https://m.media-amazon.com/images/I/71R2o5-E56L.jpg', FALSE);
-- Laptops
INSERT INTO products (category_id, name, brand, price, stock, specs, image_url, featured) VALUES
(9, 'Lenovo IdeaPad 3 15', 'Lenovo', 1800.00, 10, '{"cpu":"Ryzen 5 5500U","gpu":"Radeon Vega","ram_gb":8,"storage_gb":512,"display_in":15.6,"res":"1920x1080","battery_wh":45,"weight_kg":1.7,"use":"oficina"}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg',  TRUE),
(9, 'ASUS VivoBook 15 X1502', 'ASUS', 1950.00, 12, '{"cpu":"Intel i5-1235U","gpu":"Intel Iris Xe","ram_gb":8,"storage_gb":512,"display_in":15.6,"res":"1920x1080","battery_wh":50,"weight_kg":1.7,"use":"oficina"}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg', FALSE),
(9, 'HP Pavilion Gaming 15', 'HP', 2800.00, 8,  '{"cpu":"Intel i5-12500H","gpu":"RTX 3050 4GB","ram_gb":8,"storage_gb":512,"display_in":15.6,"res":"1920x1080","hz":144,"battery_wh":52,"weight_kg":2.2,"use":"gaming"}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg',  TRUE),
(9, 'ASUS TUF Gaming A15', 'ASUS', 3200.00, 8,  '{"cpu":"Ryzen 7 7435HS","gpu":"RTX 4060 8GB","ram_gb":16,"storage_gb":512,"display_in":15.6,"res":"1920x1080","hz":144,"battery_wh":90,"weight_kg":2.3,"use":"gaming"}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg', FALSE),
(9, 'Lenovo Legion 5 Pro', 'Lenovo', 4500.00, 6,  '{"cpu":"Ryzen 7 7745HX","gpu":"RTX 4060 8GB","ram_gb":16,"storage_gb":1000,"display_in":16,"res":"2560x1600","hz":165,"battery_wh":80,"weight_kg":2.4,"use":"gaming"}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg',  TRUE),
(9, 'ASUS ROG Strix G16', 'ASUS', 6800.00, 4,  '{"cpu":"Intel i9-13980HX","gpu":"RTX 4070 8GB","ram_gb":16,"storage_gb":1000,"display_in":16,"res":"2560x1600","hz":240,"battery_wh":90,"weight_kg":2.5,"use":"gaming_premium"}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg', FALSE),
(9, 'Dell XPS 15 9530', 'Dell', 5800.00, 5,  '{"cpu":"Intel i7-13700H","gpu":"RTX 4060 8GB","ram_gb":16,"storage_gb":512,"display_in":15.6,"res":"3456x2160","hz":60,"battery_wh":86,"weight_kg":1.8,"use":"profesional"}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg', FALSE),
(9, 'Apple MacBook Air M2', 'Apple', 5500.00, 6,  '{"cpu":"Apple M2","gpu":"Apple M2 10-core GPU","ram_gb":8,"storage_gb":256,"display_in":13.6,"res":"2560x1664","battery_wh":52,"weight_kg":1.2,"use":"profesional"}', 'https://m.media-amazon.com/images/I/71f5Eu5lJSL.jpg',  TRUE),
(9, 'Lenovo IdeaPad Slim 3 15AMN7', 'Lenovo', 950.00, 12, '{"cpu":"AMD Athlon Silver 3050U","gpu":"AMD Radeon Graphics","ram_gb":4,"storage_gb":128,"display_in":15.6,"res":"1366x768","battery_wh":45,"weight_kg":1.6,"use":"basico"}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg', FALSE),
(9, 'HP 15s-fq2000ns', 'HP', 1100.00, 10, '{"cpu":"Intel Core i3-1115G4","gpu":"Intel UHD Graphics","ram_gb":8,"storage_gb":256,"display_in":15.6,"res":"1920x1080","battery_wh":41,"weight_kg":1.7,"use":"oficina"}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg',  TRUE),
(9, 'ASUS VivoBook Flip 14 TP470', 'ASUS', 1250.00, 8,  '{"cpu":"Intel Core i5-1135G7","gpu":"Intel Iris Xe Graphics","ram_gb":8,"storage_gb":512,"display_in":14,"res":"1920x1080","battery_wh":48,"weight_kg":1.5,"use":"convertible"}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg', FALSE),
(9, 'Dell Inspiron 15 3520', 'Dell', 1350.00, 12, '{"cpu":"Intel Core i5-1235U","gpu":"Intel Iris Xe Graphics","ram_gb":8,"storage_gb":512,"display_in":15.6,"res":"1920x1080","battery_wh":41,"weight_kg":1.8,"use":"oficina"}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg',  TRUE),
(9, 'Lenovo Legion Slim 5 15ACH6H', 'Lenovo', 1850.00, 8,  '{"cpu":"AMD Ryzen 7 5800H","gpu":"NVIDIA RTX 3050 4GB","ram_gb":16,"storage_gb":512,"display_in":15.6,"res":"1920x1080","hz":144,"battery_wh":80,"weight_kg":2.1,"use":"gaming"}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg', FALSE),
(9, 'ASUS TUF Dash F15 FX517ZE', 'ASUS', 1650.00, 10, '{"cpu":"Intel Core i7-12650H","gpu":"NVIDIA RTX 3060 6GB","ram_gb":16,"storage_gb":512,"display_in":15.6,"res":"1920x1080","hz":144,"battery_wh":76,"weight_kg":2.0,"use":"gaming"}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg',  TRUE),
(9, 'MacBook Pro 14" M3 Pro', 'Apple', 3200.00, 6,  '{"cpu":"Apple M3 Pro","gpu":"Apple M3 Pro 18-core GPU","ram_gb":18,"storage_gb":512,"display_in":14.2,"res":"3024x1964","battery_wh":70,"weight_kg":1.6,"use":"profesional"}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg', FALSE),
(9, 'Lenovo Yoga Slim 7 14ITL5', 'Lenovo', 1400.00, 8,  '{"cpu":"Intel Core i7-1165G7","gpu":"Intel Iris Xe Graphics","ram_gb":16,"storage_gb":512,"display_in":14,"res":"2256x1504","battery_wh":63,"weight_kg":1.4,"use":"ultrabook"}', 'https://m.media-amazon.com/images/I/71S-7G8H2CL.jpg',  TRUE);