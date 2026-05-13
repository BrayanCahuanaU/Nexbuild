const express   = require('express');
const router    = express.Router();
const Anthropic = require('@anthropic-ai/sdk');
const db        = require('../db');

const client = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

// GET /api/categories
router.get('/categories', async (req, res) => {
  try {
    const [categories] = await db.query('SELECT * FROM categories ORDER BY id');
    res.json(categories);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener categorías' });
  }
});

// POST /api/ai/build
// body: { useCase, budget, currency: "PEN", wantsLaptop: false }
router.post('/build', async (req, res) => {
  const { useCase, budget, wantsLaptop = false } = req.body;

  if (!useCase || !budget) {
    return res.status(400).json({ error: 'Se requiere caso de uso y presupuesto' });
  }

  try {
    // Fetch all products grouped by category
    const [products] = await db.query(`
      SELECT p.id, p.name, p.brand, p.price, p.stock, p.specs,
             c.slug AS category, c.name AS category_name
      FROM products p
      JOIN categories c ON p.category_id = c.id
      WHERE p.stock > 0
      ORDER BY c.id, p.price ASC
    `);

    // Group by category for clarity in prompt
    const catalog = {};
    for (const p of products) {
      if (!catalog[p.category]) catalog[p.category] = [];
      catalog[p.category].push({
        id: p.id,
        name: p.name,
        brand: p.brand,
        price: parseFloat(p.price),
        specs: p.specs
      });
    }

    const scope = wantsLaptop
      ? 'laptop'
      : 'desktop PC (cpu, motherboard, ram, gpu si aplica, storage, psu, case, cooling)';

    const prompt = `Eres un experto en hardware de computadoras con amplio conocimiento de compatibilidades y relación precio-rendimiento.

SOLICITUD DEL CLIENTE:
- Necesidad / uso principal: ${useCase}
- Presupuesto máximo: S/. ${budget} (soles peruanos)
- Tipo de equipo: ${scope}

CATÁLOGO DISPONIBLE EN TIENDA (solo estos productos, con precios en soles):
${JSON.stringify(catalog, null, 2)}

INSTRUCCIONES:
1. Crea UNA build principal recomendada (mejor rendimiento dentro del presupuesto para la necesidad).
2. Crea 2 alternativas ordenadas de MEJOR a MENOR conveniencia.
3. Para PC de escritorio: selecciona componentes compatibles entre sí (socket CPU↔Motherboard, tipo RAM↔Motherboard, potencia PSU adecuada).
4. Verifica que el total NO supere el presupuesto de S/. ${budget}.
5. Usa SOLO product_id de productos que existen en el catálogo anterior.
6. Para laptops: selecciona 1 laptop adecuada por build.

Responde ÚNICAMENTE con JSON válido, sin texto adicional, sin markdown, sin backticks. Formato exacto:
{
  "recommended": {
    "name": "Nombre descriptivo de la build",
    "description": "Explicación breve de por qué esta build es la mejor opción para el cliente (2-3 oraciones)",
    "items": [
      {"product_id": 1, "quantity": 1}
    ],
    "total": 0,
    "pros": ["ventaja 1", "ventaja 2", "ventaja 3"],
    "cons": ["limitación 1"]
  },
  "alternatives": [
    {
      "name": "Nombre de alternativa",
      "description": "Por qué considerar esta alternativa",
      "items": [{"product_id": 1, "quantity": 1}],
      "total": 0,
      "pros": ["pro 1"],
      "cons": ["con 1"]
    }
  ]
}`;

    const message = await client.messages.create({
      model:      'claude-opus-4-5',
      max_tokens: 3000,
      messages:   [{ role: 'user', content: prompt }]
    });

    const rawText = message.content[0].text.trim();

    let buildResult;
    try {
      buildResult = JSON.parse(rawText);
    } catch {
      // Strip any accidental markdown fences
      const clean = rawText.replace(/```json|```/g, '').trim();
      buildResult = JSON.parse(clean);
    }

    // Enrich with full product data
    const productMap = {};
    for (const p of products) productMap[p.id] = p;

    const enrichItems = (items) =>
      items.map(item => ({
        ...item,
        product: productMap[item.product_id] || null
      }));

    buildResult.recommended.items   = enrichItems(buildResult.recommended.items);
    buildResult.alternatives        = buildResult.alternatives.map(alt => ({
      ...alt,
      items: enrichItems(alt.items)
    }));

    // Persist to DB
    await db.query(
      'INSERT INTO builds (use_case, budget, result_json) VALUES (?, ?, ?)',
      [useCase, budget, JSON.stringify(buildResult)]
    );

    res.json(buildResult);
  } catch (err) {
    console.error('AI build error:', err);
    res.status(500).json({ error: 'Error al generar la build. Verifica tu ANTHROPIC_API_KEY.' });
  }
});

// GET /api/ai/builds - history
router.get('/builds', async (req, res) => {
  try {
    const [builds] = await db.query(
      'SELECT id, use_case, budget, created_at FROM builds ORDER BY created_at DESC LIMIT 20'
    );
    res.json(builds);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener historial' });
  }
});

module.exports = router;
