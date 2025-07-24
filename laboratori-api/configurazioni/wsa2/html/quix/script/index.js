fetch('data/domande.json')
    .then(res => res.json())
    .then(data => {
        const container = document.getElementById('cards-container');
        let rowDiv = null;

        data.forEach((raccolta, i) => {
            if (i % 4 === 0) {
                rowDiv = document.createElement('div');
                rowDiv.classList.add('row');
                container.appendChild(rowDiv);
            }

            const card = document.createElement('a');
            card.classList.add('card');
            card.href = `quiz.html?raccolta=${encodeURIComponent(raccolta.raccolta)}`;
            card.setAttribute('aria-label', `Gioca alla raccolta ${raccolta.raccolta}`);

            card.innerHTML = `
            <div class="badge-count">${raccolta.domande.length}</div>
            <div class="card-title">${raccolta.raccolta}</div>
            <span class="category-tag">${raccolta.categoria}</span>
            <div class="card-desc">${raccolta.descrizione}</div>
          `;

            rowDiv.appendChild(card);
        });
    })
    .catch(err => {
        const container = document.getElementById('cards-container');
        container.textContent = 'Errore nel caricamento delle raccolte. Riprova più tardi.';
        container.style.color = '#e74c3c';
        console.error(err);
    });