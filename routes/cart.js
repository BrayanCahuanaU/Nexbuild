const express = require('express');
const router = express.Router();
const db = require('../db');

router.post('/checkout', async (req, res) => {
  const { items } = req.body; // [{ id, quantity }, ...]

  if (!items || !items.length) return res.status(400).json({ error: 'Carrito vacío' });

  try {
    // Usamos una transacción para asegurar que todo el stock se actualice o nada
    await db.query('START TRANSACTION');

    for (const item of items) {
      const [result] = await db.query(
        'UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?',
        [item.quantity, item.id, item.quantity]
      );

      if (result.affectedRows === 0) {
        await db.query('ROLLBACK');
        return res.status(400).json({ error: `Stock insuficiente para el producto ID: ${item.id}` });
      }
    }

    await db.query('COMMIT');
    res.json({ success: true, message: 'Compra realizada con éxito' });
  } catch (err) {
    await db.query('ROLLBACK');
    res.status(500).json({ error: 'Error al procesar la compra' });
  }
});

module.exports = router;