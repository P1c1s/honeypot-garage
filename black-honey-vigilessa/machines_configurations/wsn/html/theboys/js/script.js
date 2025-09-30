document.addEventListener('DOMContentLoaded', () => {
  // Testimonial slider
  const testimonials = document.querySelectorAll('.testimonial-slider .testimonial');
  const prevBtn = document.querySelector('.testimonial-slider .prev');
  const nextBtn = document.querySelector('.testimonial-slider .next');
  let current = 0;

  function showTestimonial(index) {
    testimonials.forEach((t, i) => {
      t.classList.toggle('active', i === index);
    });
  }

  prevBtn.addEventListener('click', () => {
    current = (current - 1 + testimonials.length) % testimonials.length;
    showTestimonial(current);
  });

  nextBtn.addEventListener('click', () => {
    current = (current + 1) % testimonials.length;
    showTestimonial(current);
  });

  // FAQ toggle
  const faqQuestions = document.querySelectorAll('.faq-question');

  faqQuestions.forEach((btn) => {
    btn.addEventListener('click', () => {
      const expanded = btn.getAttribute('aria-expanded') === 'true';
      btn.setAttribute('aria-expanded', !expanded);
      const answer = btn.nextElementSibling;
      if (answer) {
        if (expanded) {
          answer.hidden = true;
        } else {
          answer.hidden = false;
        }
      }
    });
  });
});
