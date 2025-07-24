let raccolte = [];
let raccoltaSelezionataIndex = 0; // indice raccolta scelta
let domande = [];
let domandaCorrente = 0;
let interruzioneCountdown = false;
let countdown = null;
let punteggioTotale = 0;

// Funzione per leggere parametri GET
function getQueryParam(param) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(param);
}

// Carica le raccolte dal JSON
fetch('data/domande.json')
    .then(response => response.json())
    .then(data => {
        raccolte = data;

        const nomeRaccolta = getQueryParam('raccolta');

        if (nomeRaccolta) {
            // Cerca la raccolta corrispondente per nome
            raccoltaSelezionataIndex = raccolte.findIndex(r => r.raccolta === nomeRaccolta);

            if (raccoltaSelezionataIndex === -1) {
                alert('Raccolta non trovata, ne sarà scelta una casuale.');
                raccoltaSelezionataIndex = Math.floor(Math.random() * raccolte.length);
            }
        } else {
            // Nessuna raccolta specificata, scegli una casuale
            raccoltaSelezionataIndex = Math.floor(Math.random() * raccolte.length);
        }

        domande = raccolte[raccoltaSelezionataIndex].domande;

        // Aggiorna la categoria in pagina
        document.getElementById('quiz-collection').textContent = raccolte[raccoltaSelezionataIndex].raccolta;
        document.getElementById('category').textContent = raccolte[raccoltaSelezionataIndex].categoria;

        mostraDomanda(domandaCorrente);
        avviaCountdown();
    })
    .catch(err => console.error('Errore nel caricamento delle domande:', err));

function mostraDomanda(index) {
    const quiz = domande[index];
    if (!quiz) return;

    // Mostra la domanda
    document.querySelector('.question-box').textContent = quiz.quesito;

    const bottoni = document.querySelectorAll('.answer-button');
    let opzioni = [quiz.opzioneUno, quiz.opzioneDue, quiz.opzioneTre, quiz.opzioneQuattro];
    shuffle(opzioni);

    bottoni.forEach((btn, i) => {
        btn.textContent = opzioni[i];
        btn.value = opzioni[i];
    });

    document.getElementById("answer").value = quiz.opzioneUno;
    // document.getElementById("quiz-card").style.backgroundColor = "";
}

// Shuffle array utility
function shuffle(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
    return array;
}

document.addEventListener('click', function (e) {
    if (e.target.classList.contains("answer-button")) {
        const rispostaCorretta = document.getElementById("answer").value;
        interruzioneCountdown = true;
        let punteggio = 0;

        if (e.target.value === rispostaCorretta) {
            e.target.style.backgroundColor = "#38c859"; // verde
            punteggio = 10;
        } else {
            e.target.style.backgroundColor = "#f93f3f"; // rosso
        }

        punteggioTotale += punteggio;
        aggiornaPunteggio();

        setTimeout(() => {
            domandaCorrente++;
            if (domandaCorrente < domande.length) {
                mostraDomanda(domandaCorrente);
                interruzioneCountdown = false;
                avviaCountdown();
            } else {
                mostraRisultatoFinale();
            }
        }, 1000);
    }
});

function avviaCountdown() {
    clearInterval(countdown);
    const countdownElement = document.getElementById('countdown');
    let timeLeft = 30;
    const totalDuration = timeLeft * 1000;
    const intervalTime = 100;
    let elapsedTime = 0;

    countdownElement.style.width = "100%";

    countdown = setInterval(() => {
        if (!interruzioneCountdown) {
            elapsedTime += intervalTime;

            if (elapsedTime >= totalDuration) {
                clearInterval(countdown);
                document.getElementById("quiz-card").style.backgroundColor = "#f93f3f";
                setTimeout(() => {
                    domandaCorrente++;
                    aggiornaPunteggio();
                    if (domandaCorrente < domande.length) {
                        mostraDomanda(domandaCorrente);
                        interruzioneCountdown = false;
                        avviaCountdown();
                    } else {
                        mostraRisultatoFinale();
                    }
                }, 1000);
            } else {
                const newWidth = ((totalDuration - elapsedTime) / totalDuration) * 100 + "%";
                countdownElement.style.transition = "width 0.1s linear";
                countdownElement.style.width = newWidth;
                document.querySelectorAll(".answer-button").forEach(function (button) {
                    button.style.backgroundColor = "";
                })
            }
        }
    }, intervalTime);
}

function aggiornaPunteggio() {
    document.getElementById("score").textContent = `Punteggio: ${punteggioTotale}`;
}

function mostraRisultatoFinale() {
    document.getElementById("quiz-card").innerHTML = `
        <div class="text-center">
          <h2>Quiz completato!</h2>
          <p>Punteggio totale: ${punteggioTotale} / ${domande.length * 10}</p>
          <button class="btn btn-primary" onclick="location.reload()">Ricomincia</button>
        </div>
      `;
}
