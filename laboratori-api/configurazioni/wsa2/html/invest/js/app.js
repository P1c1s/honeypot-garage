document.addEventListener("DOMContentLoaded", () => {
  const container = document.getElementById("prezziContainer");
  const filtro = document.getElementById("categoria");
  let tuttiPrezzi = [];

  async function caricaPrezzi() {
    try {
      const res = await fetch("data/prezzi.json");
      if (!res.ok) throw new Error("Errore nel caricamento dati");
      tuttiPrezzi = await res.json();
      renderPrezzi("tutte");
    } catch (err) {
      container.innerHTML = `<p class="errore">⚠️ ${err.message}</p>`;
    }
  }

  function renderPrezzi(categoria) {
    container.innerHTML = "";
    const filtrati = tuttiPrezzi.filter(p => categoria === "tutte" || p.categoria === categoria);

    if (filtrati.length === 0) {
      container.innerHTML = "<p>Nessun dato disponibile.</p>";
      return;
    }

    filtrati.forEach(p => {
      const card = document.createElement("div");
      card.className = "prezzo-card";
      card.innerHTML = `<h2>${p.nome}</h2><p>${p.prezzo}</p>`;
      container.appendChild(card);
    });
  }

  filtro.addEventListener("change", () => renderPrezzi(filtro.value));
  caricaPrezzi();
});
