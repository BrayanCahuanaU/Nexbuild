require('dotenv').config();
const express = require('express');
const cors    = require('cors');
const path    = require('path');

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Routes
app.use('/api/products',  require('./routes/products'));
app.use('/api/ai',        require('./routes/ai'));

// Categories alias (convenience)
app.get('/api/categories', async (req, res) => {
  try {
    const db = require('./db');
    const [rows] = await db.query('SELECT * FROM categories ORDER BY id');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener categorías' });
  }
});

// SPA fallback
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`PC Store → http://localhost:${PORT}`));
