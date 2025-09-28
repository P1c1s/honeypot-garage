const listContainer = document.getElementById("recipe-list");
const detailsContainer = document.getElementById("recipe-details");
const overlay = document.getElementById("overlay");

async function loadRecipes() {
  try {
    const response = await fetch("data.json");
    if (!response.ok) throw new Error("Impossibile caricare le ricette.");
    const data = await response.json();
    renderRecipeList(data);
  } catch (error) {
    listContainer.innerHTML = `<p>⚠️ ${error.message}</p>`;
  }
}

function renderRecipeList(recipes) {
  listContainer.innerHTML = "";

  recipes.forEach(recipe => {
    const card = document.createElement("div");
    card.className = "recipe-summary";
    card.innerHTML = `
      <h3>${recipe.nome}</h3>
      <p>${recipe.descrizione}</p>
    `;
    card.addEventListener("click", () => showRecipeOverlay(recipe));
    listContainer.appendChild(card);
  });
}

function showRecipeOverlay(recipe) {
  detailsContainer.innerHTML = `
    <button class="close-btn" onclick="closeOverlay()">×</button>
    <h2>${recipe.nome}</h2>
    <p>${recipe.descrizione}</p>
    <h3>🧾 Ingredienti</h3>
    <ul>${recipe.ingredienti.map(i => `<li>${i}</li>`).join("")}</ul>
    <h3>👨‍🍳 Istruzioni</h3>
    <ol>${recipe.istruzioni.map(s => `<li>${s}</li>`).join("")}</ol>
  `;
  overlay.classList.remove("hidden");
}

function closeOverlay() {
  overlay.classList.add("hidden");
  detailsContainer.innerHTML = "";
}

loadRecipes();
