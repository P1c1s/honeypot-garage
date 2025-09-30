// ELEMENTI
const loginContainer = document.getElementById('login-container');
const dashboard = document.getElementById('dashboard');
const loginBtn = document.getElementById('login-btn');
const usernameInput = document.getElementById('username');
const passwordInput = document.getElementById('password');
const loginError = document.getElementById('login-error');

// DASHBOARD ELEMENTI
const buttons = document.querySelectorAll('#selettore-container .btn-tab');
const contenuto = document.getElementById('contenuto');
const canvas = document.getElementById('grafico');
const searchContainer = document.getElementById('search-container');
const searchInput = document.getElementById('search');
const pagination = document.getElementById('pagination');

let chart = null;
let currentData = [];
let filteredData = [];
const rowsPerPage = 30;
let currentPage = 1;
let sortColumn = null;
let sortDirection = 1;

// LOGIN
loginBtn.addEventListener('click', () => {
  const username = usernameInput.value.trim();
  const password = passwordInput.value.trim();

  if (username === 'admin' && password === 'admin') {
    loginError.style.display = 'none';
    loginContainer.style.display = 'none';
    dashboard.style.display = 'flex';
    avviaDashboard();
  } else {
    loginError.style.display = 'block';
  }
});

// Login con Invio
passwordInput.addEventListener('keydown', e => {
  if (e.key === 'Enter') loginBtn.click();
});

// AVVIO DASHBOARD
function avviaDashboard() {
  buttons.forEach(button => {
    button.addEventListener('click', () => {
      if (button.classList.contains('active')) return;

      buttons.forEach(btn => {
        btn.classList.remove('active');
        btn.setAttribute('aria-selected', 'false');
        btn.setAttribute('tabindex', '-1');
      });

      button.classList.add('active');
      button.setAttribute('aria-selected', 'true');
      button.setAttribute('tabindex', '0');
      button.focus();

      searchInput.value = '';
      currentPage = 1;
      sortColumn = null;
      sortDirection = 1;
      caricaTabella(button.dataset.endpoint);
    });
  });

  caricaTabella(buttons[0].dataset.endpoint);

  searchInput.addEventListener('input', () => {
    filtraTabella();
  });
}

// CARICAMENTO TABELLA
async function caricaTabella(endpoint) {
  contenuto.setAttribute('aria-busy', 'true');
  contenuto.innerHTML = 'Caricamento dati...';
  pagination.style.display = 'none';
  canvas.style.display = 'none';
  searchContainer.style.display = 'none';

  try {
    const res = await fetch(endpoint);
    if (!res.ok) throw new Error(`Errore caricamento dati da ${endpoint}`);

    const dati = await res.json();
    currentData = dati;
    filteredData = dati;

    if (endpoint === 'bilanci_mensili.php' || endpoint === 'bilanci_annuali.php') {
      renderizzaGrafico(dati, endpoint);
      contenuto.innerHTML = '';
      pagination.style.display = 'none';
      searchContainer.style.display = 'none';
    } else {
      canvas.style.display = 'none';
      searchContainer.style.display = 'block';
      renderizzaTabella();
      pagination.style.display = 'flex';
    }
  } catch (e) {
    contenuto.innerHTML = `<p>Errore: ${e.message}</p>`;
    pagination.style.display = 'none';
  }
  contenuto.setAttribute('aria-busy', 'false');
}

// Render tabella
function renderizzaTabella() {
  if (!filteredData.length) {
    contenuto.innerHTML = '<p>Nessun dato disponibile.</p>';
    pagination.style.display = 'none';
    return;
  }

  let datiOrdinati = [...filteredData];
  if (sortColumn !== null) {
    datiOrdinati.sort((a, b) => {
      let valA = a[sortColumn];
      let valB = b[sortColumn];

      if (!isNaN(parseFloat(valA)) && !isNaN(parseFloat(valB))) {
        valA = parseFloat(valA);
        valB = parseFloat(valB);
      } else {
        valA = valA.toString().toLowerCase();
        valB = valB.toString().toLowerCase();
      }

      if (valA > valB) return sortDirection;
      if (valA < valB) return -sortDirection;
      return 0;
    });
  }

  const totalePagine = Math.ceil(datiOrdinati.length / rowsPerPage);
  if (currentPage > totalePagine) currentPage = 1;
  const inizio = (currentPage - 1) * rowsPerPage;
  const fine = inizio + rowsPerPage;
  const paginaDati = datiOrdinati.slice(inizio, fine);

  const intestazioni = Object.keys(paginaDati[0]);
  let html = '<table><thead><tr>';

  intestazioni.forEach((key) => {
    html += `<th class="sortable" data-key="${key}" tabindex="0" role="button" aria-pressed="${sortColumn === key}">${key}`;
    if (sortColumn === key) {
      html += `<span class="sort-arrow">${sortDirection === 1 ? '▲' : '▼'}</span>`;
    }
    html += '</th>';
  });
  html += '</tr></thead><tbody>';

  paginaDati.forEach(row => {
    html += '<tr>';
    intestazioni.forEach(key => {
      let style = '';
      if (!isNaN(row[key])) {
        const val = parseFloat(row[key]);
        if (val > 0) style = 'color:green';
        else if (val < 0) style = 'color:red';
      }
      html += `<td style="${style}">${row[key]}</td>`;
    });
    html += '</tr>';
  });

  html += '</tbody></table>';
  contenuto.innerHTML = html;

  renderizzaPaginazione(totalePagine);

  const thElements = contenuto.querySelectorAll('th.sortable');
  thElements.forEach(th => {
    th.addEventListener('click', () => {
      const key = th.dataset.key;
      if (sortColumn === key) {
        sortDirection = -sortDirection;
      } else {
        sortColumn = key;
        sortDirection = 1;
      }
      renderizzaTabella();
    });
    th.addEventListener('keydown', (e) => {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        th.click();
      }
    });
  });
}

// Paginazione
function renderizzaPaginazione(totalePagine) {
  pagination.innerHTML = '';
  if (totalePagine <= 1) {
    pagination.style.display = 'none';
    return;
  }

  pagination.style.display = 'flex';

  const btnPrev = document.createElement('button');
  btnPrev.textContent = '‹';
  btnPrev.disabled = currentPage === 1;
  btnPrev.addEventListener('click', () => {
    if (currentPage > 1) {
      currentPage--;
      renderizzaTabella();
      contenuto.focus();
    }
  });
  pagination.appendChild(btnPrev);

  for (let i = 1; i <= totalePagine; i++) {
    const btn = document.createElement('button');
    btn.textContent = i;
    btn.className = (i === currentPage) ? 'active' : '';
    btn.disabled = (i === currentPage);
    btn.addEventListener('click', () => {
      currentPage = i;
      renderizzaTabella();
      contenuto.focus();
    });
    pagination.appendChild(btn);
  }

  const btnNext = document.createElement('button');
  btnNext.textContent = '›';
  btnNext.disabled = currentPage === totalePagine;
  btnNext.addEventListener('click', () => {
    if (currentPage < totalePagine) {
      currentPage++;
      renderizzaTabella();
      contenuto.focus();
    }
  });
  pagination.appendChild(btnNext);
}

// Filtro
function filtraTabella() {
  const term = searchInput.value.trim().toLowerCase();
  if (!term) {
    filteredData = currentData;
  } else {
    filteredData = currentData.filter(row => {
      return Object.values(row).some(value =>
        String(value).toLowerCase().includes(term)
      );
    });
  }
  currentPage = 1;
  renderizzaTabella();
}

// Grafico
function renderizzaGrafico(dati, endpoint) {
  canvas.style.display = 'block';

  if (chart) chart.destroy();

  let labels = [];
  let datasetEntrate = [];
  let datasetUscite = [];

  if (endpoint === 'bilanci_mensili.php') {
    labels = dati.map(d => d.mese);
    datasetEntrate = dati.map(d => Number(d.entrate));
    datasetUscite = dati.map(d => Number(d.uscite));
  } else if (endpoint === 'bilanci_annuali.php') {
    labels = dati.map(d => d.anno);
    datasetEntrate = dati.map(d => Number(d.entrate));
    datasetUscite = dati.map(d => Number(d.uscite));
  }

  chart = new Chart(canvas, {
    type: 'bar',
    data: {
      labels: labels,
      datasets: [
        {
          label: 'Entrate',
          data: datasetEntrate,
          backgroundColor: 'rgba(36, 148, 36, 0.6)',
          borderColor: 'rgba(36, 148, 36, 1)',
          borderWidth: 1
        },
        {
          label: 'Uscite',
          data: datasetUscite,
          backgroundColor: 'rgba(194, 64, 64, 0.6)',
          borderColor: 'rgba(194, 64, 64, 1)',
          borderWidth: 1
        }
      ]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { labels: { font: { size: 14 } } },
        tooltip: { mode: 'index', intersect: false }
      },
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            font: { size: 13 },
            color: '#555',
            callback: function(value) { return value.toLocaleString(); }
          }
        },
        x: {
          ticks: { font: { size: 13 }, color: '#555' }
        }
      }
    }
  });
}
