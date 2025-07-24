document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById('contactForm');
  const formMessage = document.getElementById('formMessage');

  form.addEventListener('submit', e => {
    e.preventDefault();

    // Simuliamo l'invio (in un sito reale, si farebbe fetch a un backend)
    formMessage.style.color = 'green';
    formMessage.textContent = 'Invio in corso...';

    setTimeout(() => {
      formMessage.textContent = 'Grazie per averci contattato! Ti risponderemo al più presto.';
      form.reset();
    }, 2000);
  });
});
