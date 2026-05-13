const express = require('express');
const router  = express.Router();
const db      = require('../db');

// GET /api/products?category=gpu&search=rtx&page=1&limit=12
router.get('/', async (req, res) => {
  try {
    const { category, search, page = 1, limit = 20, featured } = req.query;
    const offset = (parseInt(page) - 1) * parseInt(limit);
    const params = [];
    const conditions = [];

    let sql = `
      SELECT p.*, c.slug AS category_slug, c.name AS category_name, c.icon AS category_icon
      FROM products p
      JOIN categories c ON p.category_id = c.id
    `;

    if (category) {
      conditions.push('c.slug = ?');
      params.push(category);
    }
    if (search) {
      conditions.push('(p.name LIKE ? OR p.brand LIKE ?)');
      params.push(`%${search}%`, `%${search}%`);
    }
    if (featured === 'true') {
      conditions.push('p.featured = TRUE');
    }

    if (conditions.length) sql += ' WHERE ' + conditions.join(' AND ');
    sql += ' ORDER BY p.featured DESC, p.id ASC LIMIT ? OFFSET ?';
    params.push(parseInt(limit), offset);

    const [rows] = await db.query(sql, params);

    // Count total
    let countSql = 'SELECT COUNT(*) AS total FROM products p JOIN categories c ON p.category_id = c.id';
    const countParams = params.slice(0, -2);
    if (conditions.length) countSql += ' WHERE ' + conditions.join(' AND ');
    const [[{ total }]] = await db.query(countSql, countParams);

    res.json({ products: rows, total, page: parseInt(page), limit: parseInt(limit) });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al obtener productos' });
  }
});

// GET /api/products/:id
router.get('/:id', async (req, res) => {
  try {
    const [[product]] = await db.query(`
      SELECT p.*, c.slug AS category_slug, c.name AS category_name, c.icon AS category_icon
      FROM products p JOIN categories c ON p.category_id = c.id
      WHERE p.id = ?`, [req.params.id]);

    if (!product) return res.status(404).json({ error: 'Producto no encontrado' });
    res.json(product);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener producto' });
  }
});

// GET /api/products/category/all
router.get('/category/all', async (req, res) => {
  try {
    const [categories] = await db.query('SELECT * FROM categories ORDER BY id');
    res.json(categories);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener categorías' });
  }
});

module.exports = router;
