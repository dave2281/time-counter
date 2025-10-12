// Ultra Minimal Navbar JavaScript with Turbo support
function initializeNavbar() {
  // Get common elements
  const mobileMenuBtn = document.getElementById('mobile-menu-button');
  const mobileMenu = document.getElementById('mobile-menu');
  
  // Remove existing event listeners by cloning elements (clean approach)
  if (mobileMenuBtn && mobileMenuBtn._navbarInitialized) {
    return; // Already initialized
  }
  
  // Mobile menu toggle functionality
  if (mobileMenuBtn && mobileMenu) {
    // Mark as initialized to prevent duplicate listeners
    mobileMenuBtn._navbarInitialized = true;
    
    mobileMenuBtn.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      
      const isActive = mobileMenu.classList.contains('active');
      
      if (isActive) {
        mobileMenu.classList.remove('active');
        mobileMenuBtn.setAttribute('aria-expanded', 'false');
      } else {
        mobileMenu.classList.add('active');
        mobileMenuBtn.setAttribute('aria-expanded', 'true');
      }
      
      // Update icon
      const icon = mobileMenuBtn.querySelector('svg');
      if (!isActive) {
        icon.innerHTML = `
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
        `;
      } else {
        icon.innerHTML = `
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
        `;
      }
    });
  }
  
  // Close mobile menu when clicking on links
  if (mobileMenu) {
    const mobileLinks = mobileMenu.querySelectorAll('a');
    mobileLinks.forEach(link => {
      link.addEventListener('click', function() {
        mobileMenu.classList.remove('active');
        if (mobileMenuBtn) {
          mobileMenuBtn.setAttribute('aria-expanded', 'false');
          const icon = mobileMenuBtn.querySelector('svg');
          icon.innerHTML = `
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
          `;
        }
      });
    });
  }
  
  // Close mobile menu when clicking outside
  function handleOutsideClick(event) {
    if (mobileMenu && mobileMenuBtn) {
      if (!mobileMenuBtn.contains(event.target) && !mobileMenu.contains(event.target)) {
        mobileMenu.classList.remove('active');
        mobileMenuBtn.setAttribute('aria-expanded', 'false');
        
        const icon = mobileMenuBtn.querySelector('svg');
        if (icon) {
          icon.innerHTML = `
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
          `;
        }
      }
    }
  }
  
  // Remove existing listener if it exists
  if (document._navbarOutsideClickHandler) {
    document.removeEventListener('click', document._navbarOutsideClickHandler);
  }
  
  // Add new listener and store reference
  document._navbarOutsideClickHandler = handleOutsideClick;
  document.addEventListener('click', handleOutsideClick);
  
  // Navbar scroll effect (subtle)
  const navbar = document.querySelector('.navbar-minimal');
  if (navbar && !navbar._scrollInitialized) {
    navbar._scrollInitialized = true;
    
    function handleScroll() {
      const currentScrollY = window.scrollY;
      
      if (currentScrollY > 20) {
        navbar.style.background = 'rgba(3, 7, 18, 1)';
        navbar.style.borderBottomColor = 'rgba(255, 255, 255, 0.1)';
      } else {
        navbar.style.background = 'rgba(3, 7, 18, 0.98)';
        navbar.style.borderBottomColor = 'rgba(255, 255, 255, 0.06)';
      }
    }
    
    window.addEventListener('scroll', handleScroll);
  }
}

// Initialize on DOM ready
document.addEventListener('DOMContentLoaded', initializeNavbar);

// Reinitialize after Turbo navigation
document.addEventListener('turbo:load', initializeNavbar);

// Clean up mobile menu state before navigation
document.addEventListener('turbo:before-visit', function() {
  const mobileMenu = document.getElementById('mobile-menu');
  const mobileMenuBtn = document.getElementById('mobile-menu-button');
  
  if (mobileMenu && mobileMenu.classList.contains('active')) {
    mobileMenu.classList.remove('active');
    if (mobileMenuBtn) {
      mobileMenuBtn.setAttribute('aria-expanded', 'false');
      const icon = mobileMenuBtn.querySelector('svg');
      if (icon) {
        icon.innerHTML = `
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
        `;
      }
    }
  }
});

// Body fade-in effect
function initBodyFadeIn() {
  // Enhanced minimal functionality
  document.body.classList.add('opacity-0');
  setTimeout(() => {
    document.body.classList.remove('opacity-0');
    document.body.classList.add('transition-opacity', 'duration-300', 'opacity-100');
  }, 50);
}

// Initialize body fade-in on load
document.addEventListener('DOMContentLoaded', initBodyFadeIn);
document.addEventListener('turbo:load', initBodyFadeIn);