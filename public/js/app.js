/* =========================================================
   NEXBUILD — Frontend App
   ========================================================= */

const API = '';  // same origin

// ── State ─────────────────────────────────────────────────
const state = {
  categories:   [],
  currentCat:   '',
  currentPage:  1,
  searchQuery:  '',
  wantsLaptop:  false,
  buildResult:  null,
  activeTab:    'recommended',
};

// ── DOM helpers ───────────────────────────────────────────
const $  = (sel, ctx = document) => ctx.querySelector(sel);
const $$ = (sel, ctx = document) => [...ctx.querySelectorAll(sel)];
const fmt = (n) => `S/. ${parseFloat(n).toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;

// ── Router ────────────────────────────────────────────────
function navigateTo(page) {
  $$('.page').forEach(p => p.classList.remove('active'));
  const el = $(`#page-${page}`);
  if (el) el.classList.add('active');
  $$('.nav-link').forEach(l => l.classList.remove('active'));
  $$(`[data-nav="${page}"]`).forEach(l => l.classList.add('active'));
  window.scrollTo({ top: 0, behavior: 'smooth' });

  if (page === 'catalog') loadCatalog();
  if (page === 'home') loadHome();
}

// ── API calls ─────────────────────────────────────────────
async function apiFetch(path, opts = {}) {
  const res = await fetch(API + path, opts);
  if (!res.ok) throw new Error((await res.json()).error || res.statusText);
  return res.json();
}

// ── Home page ─────────────────────────────────────────────
async function loadHome() {
  await loadCategories();
  renderCatGrid();
  loadFeatured();
}

async function loadCategories() {
  if (state.categories.length) return;
  state.categories = await apiFetch('/api/categories');
}

function renderCatGrid() {
  const grid = $('#catGrid');
  if (!grid) return;
  grid.innerHTML = state.categories.map(c => `
    <div class="cat-card" data-cat="${c.slug}">
      <div class="cat-icon">${c.icon}</div>
      <div class="cat-name">${c.name}</div>
    </div>
  `).join('');

  $$('.cat-card').forEach(card => {
    card.addEventListener('click', () => {
      state.currentCat = card.dataset.cat;
      state.currentPage = 1;
      navigateTo('catalog');
    });
  });
}

async function loadFeatured() {
  const grid = $('#featuredGrid');
  if (!grid) return;
  try {
    const { products } = await apiFetch('/api/products?featured=true&limit=8');
    grid.innerHTML = products.map(productCard).join('');
    attachCardListeners(grid);
  } catch {
    grid.innerHTML = '<p style="color:var(--text-muted);padding:20px">Error al cargar productos</p>';
  }
}

// ── Product card HTML ─────────────────────────────────────
function productCard(p) {
  return `
    <div class="product-card" data-id="${p.id}">
      ${p.featured ? '<span class="featured-badge">TOP</span>' : ''}
      <div class="pc-cat">${p.category_icon || ''} ${p.category_name || ''}</div>
      <div class="pc-name">${p.name}</div>
      <div class="pc-brand">${p.brand}</div>
      <div class="pc-price">${fmt(p.price)}</div>
      <div class="pc-stock">Stock: ${p.stock}</div>
    </div>
  `;
}

function attachCardListeners(ctx) {
  $$('.product-card', ctx).forEach(card => {
    card.addEventListener('click', () => openProductModal(card.dataset.id));
  });
}

// ── Product modal ─────────────────────────────────────────
async function openProductModal(id) {
  try {
    const p = await apiFetch(`/api/products/${id}`);
    const specs = p.specs || {};
    const specsHtml = Object.entries(specs).map(([k, v]) => `
      <div class="spec-row">
        <span class="spec-key">${k.replace(/_/g, ' ')}</span>
        <span class="spec-val">${v}</span>
      </div>
    `).join('');

    $('#modalContent').innerHTML = `
      <div class="modal-cat">${p.category_icon || ''} ${p.category_name}</div>
      <div class="modal-name">${p.name}</div>
      <div class="modal-brand">${p.brand}</div>
      <div class="modal-price">${fmt(p.price)}</div>
      ${specsHtml ? `<div class="specs-grid">${specsHtml}</div>` : ''}
      <div class="modal-stock">✓ ${p.stock} unidades en stock</div>
    `;

    $('#modalOverlay').classList.remove('hidden');
  } catch (err) {
    console.error(err);
  }
}

// ── Catalog ───────────────────────────────────────────────
async function loadCatalog() {
  await loadCategories();
  renderSidebar();
  loadProducts();
}

function renderSidebar() {
  const list = $('#catFilter');
  if (!list) return;
  list.innerHTML = `<li class="cat-item ${!state.currentCat ? 'active' : ''}" data-cat="">Todos</li>` +
    state.categories.map(c =>
      `<li class="cat-item ${state.currentCat === c.slug ? 'active' : ''}" data-cat="${c.slug}">
        ${c.icon} ${c.name}
      </li>`
    ).join('');

  $$('.cat-item', list).forEach(item => {
    item.addEventListener('click', () => {
      state.currentCat  = item.dataset.cat;
      state.currentPage = 1;
      $$('.cat-item').forEach(i => i.classList.remove('active'));
      item.classList.add('active');
      loadProducts();
    });
  });
}

async function loadProducts() {
  const grid   = $('#catalogGrid');
  const meta   = $('#catalogMeta');
  const pagDiv = $('#pagination');
  if (!grid) return;

  grid.innerHTML = [1,2,3,4].map(() => '<div class="skeleton-card"></div>').join('');

  const params = new URLSearchParams({
    page: state.currentPage,
    limit: 16,
    ...(state.currentCat && { category: state.currentCat }),
    ...(state.searchQuery && { search: state.searchQuery }),
  });

  try {
    const { products, total, page, limit } = await apiFetch(`/api/products?${params}`);
    meta.textContent = `${total} producto${total !== 1 ? 's' : ''} encontrado${total !== 1 ? 's' : ''}`;

    if (!products.length) {
      grid.innerHTML = '<p style="color:var(--text-muted);padding:24px;grid-column:1/-1">Sin resultados</p>';
      pagDiv.innerHTML = '';
      return;
    }

    grid.innerHTML = products.map(productCard).join('');
    attachCardListeners(grid);

    // Pagination
    const totalPages = Math.ceil(total / limit);
    pagDiv.innerHTML = Array.from({ length: totalPages }, (_, i) => i + 1).map(n =>
      `<button class="page-btn ${n === page ? 'active' : ''}" data-page="${n}">${n}</button>`
    ).join('');

    $$('.page-btn', pagDiv).forEach(btn => {
      btn.addEventListener('click', () => {
        state.currentPage = parseInt(btn.dataset.page);
        loadProducts();
        window.scrollTo({ top: 0, behavior: 'smooth' });
      });
    });
  } catch (err) {
    grid.innerHTML = `<div class="error-box" style="grid-column:1/-1">${err.message}</div>`;
  }
}

// ── AI Builder ────────────────────────────────────────────
function initBuilder() {
  const desktopBtn = $('#desktopBtn');
  const laptopBtn  = $('#laptopBtn');
  const generateBtn = $('#generateBtn');

  desktopBtn.addEventListener('click', () => {
    state.wantsLaptop = false;
    desktopBtn.classList.add('active');
    laptopBtn.classList.remove('active');
  });

  laptopBtn.addEventListener('click', () => {
    state.wantsLaptop = true;
    laptopBtn.classList.add('active');
    desktopBtn.classList.remove('active');
  });

  $$('.example-pill').forEach(pill => {
    pill.addEventListener('click', () => {
      $('#useCaseInput').value = pill.dataset.use;
      $('#budgetInput').value  = pill.dataset.budget;
    });
  });

  generateBtn.addEventListener('click', generateBuild);
}

async function generateBuild() {
  const useCase = $('#useCaseInput').value.trim();
  const budget  = parseFloat($('#budgetInput').value);

  if (!useCase) {
    alert('Por favor describe para qué usarás el equipo.');
    return;
  }
  if (!budget || budget < 300) {
    alert('Ingresa un presupuesto válido (mínimo S/. 300).');
    return;
  }

  const btn     = $('#generateBtn');
  const results = $('#builderResults');
  const content = $('#resultsContent');

  btn.disabled = true;
  $('#generateBtnText').textContent = 'Analizando componentes...';
  results.classList.remove('hidden');
  content.innerHTML = `
    <div class="generating-wrap">
      <div class="spinner"></div>
      <div class="generating-label">GENERANDO BUILD CON IA...</div>
    </div>
  `;

  try {
    const data = await apiFetch('/api/ai/build', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ useCase, budget, wantsLaptop: state.wantsLaptop }),
    });

    state.buildResult = data;
    state.activeTab   = 'recommended';

    renderBuildTabs();
    renderBuildCard(state.activeTab);
    results.scrollIntoView({ behavior: 'smooth', block: 'start' });
  } catch (err) {
    content.innerHTML = `<div class="error-box">⚠ ${err.message}</div>`;
  } finally {
    btn.disabled = false;
    $('#generateBtnText').textContent = 'Generar build con IA';
  }
}

function renderBuildTabs() {
  const data  = state.buildResult;
  const tabs  = $$('.result-tab');
  const alts  = data.alternatives || [];

  // Show/hide alt tabs
  tabs.forEach((tab, i) => {
    if (i === 0) {
      tab.style.display = '';
      tab.textContent   = '⭐ Recomendada';
    } else {
      const alt = alts[i - 1];
      if (alt) { tab.style.display = ''; tab.textContent = `Alt. ${i} — ${alt.name}`; }
      else tab.style.display = 'none';
    }
    tab.classList.toggle('active', tab.dataset.tab === 'recommended');
  });

  $$('.result-tab').forEach(tab => {
    tab.addEventListener('click', () => {
      $$('.result-tab').forEach(t => t.classList.remove('active'));
      tab.classList.add('active');
      state.activeTab = tab.dataset.tab;
      renderBuildCard(state.activeTab);
    });
  });
}

function renderBuildCard(tabKey) {
  const data  = state.buildResult;
  const build = tabKey === 'recommended'
    ? data.recommended
    : data.alternatives[parseInt(tabKey.replace('alt', '')) - 1];

  if (!build) return;

  const prosHtml = (build.pros || []).map(p => `<li>${p}</li>`).join('');
  const consHtml = (build.cons || []).map(c => `<li>${c}</li>`).join('');

  const itemsHtml = (build.items || []).map(item => {
    const p = item.product;
    if (!p) return '';
    return `
      <div class="component-item" data-id="${p.id}">
        <span class="comp-cat">${p.category_icon || ''} ${p.category || p.category_slug || ''}</span>
        <span class="comp-name">${p.name} <span style="color:var(--text-muted);font-size:12px">× ${item.quantity || 1}</span></span>
        <span class="comp-price">${fmt(p.price * (item.quantity || 1))}</span>
      </div>
    `;
  }).join('');

  $('#resultsContent').innerHTML = `
    <div class="build-card">
      <div class="build-card-header">
        <div class="build-name">${build.name}</div>
        <div class="build-total">${fmt(build.total)}</div>
      </div>
      <div class="build-desc">${build.description}</div>

      <div class="pros-cons">
        <div class="pros-cons-col pros">
          <h4>VENTAJAS</h4>
          <ul>${prosHtml}</ul>
        </div>
        <div class="pros-cons-col cons">
          <h4>LIMITACIONES</h4>
          <ul>${consHtml}</ul>
        </div>
      </div>

      <div class="components-title">COMPONENTES SELECCIONADOS</div>
      <div class="component-list">${itemsHtml}</div>
    </div>
  `;

  // Component click → modal
  $$('.component-item', $('#resultsContent')).forEach(item => {
    item.addEventListener('click', () => openProductModal(item.dataset.id));
  });
}

// ── Init ──────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  // Nav delegation
  document.addEventListener('click', e => {
    const nav = e.target.closest('[data-nav]');
    if (nav) { e.preventDefault(); navigateTo(nav.dataset.nav); }
  });

  // Search
  let searchTimer;
  $('#searchInput')?.addEventListener('input', e => {
    clearTimeout(searchTimer);
    searchTimer = setTimeout(() => {
      state.searchQuery = e.target.value.trim();
      state.currentPage = 1;
      loadProducts();
    }, 350);
  });

  // Modal close
  $('#modalClose')?.addEventListener('click', () => $('#modalOverlay').classList.add('hidden'));
  $('#modalOverlay')?.addEventListener('click', e => {
    if (e.target === $('#modalOverlay')) $('#modalOverlay').classList.add('hidden');
  });

  // Mobile menu
  $('#menuToggle')?.addEventListener('click', () => {
    const nav = $('.main-nav');
    nav.classList.toggle('open');
  });

  // Keyboard: Escape closes modal
  document.addEventListener('keydown', e => {
    if (e.key === 'Escape') $('#modalOverlay').classList.add('hidden');
  });

  // Build result tabs (for alt1/alt2 naming)
  // Map tab keys for alternatives
  $$('.result-tab').forEach((tab, i) => {
    if (i > 0) tab.dataset.tab = `alt${i}`;
  });

  initBuilder();
  navigateTo('home');
});
