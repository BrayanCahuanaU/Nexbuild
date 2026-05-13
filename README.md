# NEXBUILD — Tienda de Componentes PC con IA

Tienda web de componentes de PC y laptops con generador de builds por IA.

## Stack
- **Frontend**: HTML + CSS + Vanilla JS (SPA)
- **Backend**: Node.js + Express
- **Base de datos**: MySQL
- **IA**: Claude claude-opus-4-5 (Anthropic API)

## Requisitos
- Node.js ≥ 18
- MySQL ≥ 8
- Cuenta Anthropic (API key)

## Instalación

### 1. Base de datos
```bash
mysql -u root -p < schema.sql
```

### 2. Dependencias
```bash
npm install
```

### 3. Variables de entorno
```bash
cp .env.example .env
# Editar .env con tus credenciales
```

```env
PORT=3000
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=tu_password
DB_NAME=pcstore
ANTHROPIC_API_KEY=sk-ant-...
```

### 4. Ejecutar
```bash
# Desarrollo
npm run dev

# Producción
npm start
```

Abre http://localhost:3000

## Funcionalidades

### Catálogo
- Filtro por categoría (CPU, GPU, RAM, Storage, Motherboard, PSU, Case, Refrigeración, Laptops)
- Búsqueda en tiempo real
- Paginación
- Modal de detalle con especificaciones

### Generador de Builds con IA
- Ingresa tu caso de uso y presupuesto
- La IA consulta el catálogo disponible y selecciona componentes compatibles
- Muestra 1 build recomendada + 2 alternativas de mejor a menor conveniencia
- Cada build incluye: componentes, precio total, ventajas y limitaciones
- Ejemplos rápidos para casos de uso comunes

## Estructura
```
pc-store/
├── server.js           # Entry point Express
├── db.js               # Pool MySQL
├── routes/
│   ├── products.js     # CRUD productos y categorías
│   └── ai.js           # Generador de builds con Claude
├── public/
│   ├── index.html      # SPA shell
│   ├── css/style.css   # Diseño minimalista dark
│   └── js/app.js       # Lógica frontend
├── schema.sql          # Schema + datos iniciales
├── .env.example
└── package.json
```
