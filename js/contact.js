document.addEventListener('DOMContentLoaded', () => {
  const contactForm = document.getElementById('contact-form');
  
  if (contactForm) {
    contactForm.addEventListener('submit', (e) => {
      e.preventDefault();
      
      // In a real app, you would send this to a backend or rely on form endpoints like Formspree
      // For this static site, we'll simulate a success message
      const submitBtn = contactForm.querySelector('button[type="submit"]');
      const originalText = submitBtn.innerHTML;
      
      submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';
      submitBtn.disabled = true;
      
      setTimeout(() => {
        // Success simulation
        contactForm.innerHTML = `
          <div class="success-message" style="text-align: center; padding: 2rem;">
            <i class="fas fa-check-circle" style="font-size: 3rem; color: var(--primary); margin-bottom: 1rem;"></i>
            <h3>Message Sent Successfully!</h3>
            <p>Thank you for reaching out. Our team will get back to you shortly.</p>
          </div>
        `;
      }, 1500);
    });
  }

  // Pre-fill service inquiry if passed via URL
  const urlParams = new URLSearchParams(window.location.search);
  const service = urlParams.get('service');
  
  if (service) {
    const serviceSelect = document.getElementById('service-select');
    if (serviceSelect) {
      // Logic to auto-select the dropdown option matching the service
      for (let i = 0; i < serviceSelect.options.length; i++) {
        if (serviceSelect.options[i].value.toLowerCase().includes(service.toLowerCase())) {
          serviceSelect.selectedIndex = i;
          break;
        }
      }
    }
  }
});
