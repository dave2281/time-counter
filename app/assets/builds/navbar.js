// app/javascript/navbar.js
function initializeNavbar() {
  const mobileMenuBtn = document.getElementById("mobile-menu-button");
  const mobileMenu = document.getElementById("mobile-menu");
  if (mobileMenuBtn && mobileMenuBtn._navbarInitialized) {
    return;
  }
  if (mobileMenuBtn && mobileMenu) {
    mobileMenuBtn._navbarInitialized = true;
    mobileMenuBtn.addEventListener("click", function(e) {
      e.preventDefault();
      e.stopPropagation();
      const isActive = mobileMenu.classList.contains("active");
      if (isActive) {
        mobileMenu.classList.remove("active");
        mobileMenuBtn.setAttribute("aria-expanded", "false");
      } else {
        mobileMenu.classList.add("active");
        mobileMenuBtn.setAttribute("aria-expanded", "true");
      }
      const icon = mobileMenuBtn.querySelector("svg");
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
  if (mobileMenu) {
    const mobileLinks = mobileMenu.querySelectorAll("a");
    mobileLinks.forEach((link) => {
      link.addEventListener("click", function() {
        mobileMenu.classList.remove("active");
        if (mobileMenuBtn) {
          mobileMenuBtn.setAttribute("aria-expanded", "false");
          const icon = mobileMenuBtn.querySelector("svg");
          icon.innerHTML = `
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
          `;
        }
      });
    });
  }
  function handleOutsideClick(event) {
    if (mobileMenu && mobileMenuBtn) {
      if (!mobileMenuBtn.contains(event.target) && !mobileMenu.contains(event.target)) {
        mobileMenu.classList.remove("active");
        mobileMenuBtn.setAttribute("aria-expanded", "false");
        const icon = mobileMenuBtn.querySelector("svg");
        if (icon) {
          icon.innerHTML = `
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
          `;
        }
      }
    }
  }
  if (document._navbarOutsideClickHandler) {
    document.removeEventListener("click", document._navbarOutsideClickHandler);
  }
  document._navbarOutsideClickHandler = handleOutsideClick;
  document.addEventListener("click", handleOutsideClick);
  const navbar = document.querySelector(".navbar-minimal");
  if (navbar && !navbar._scrollInitialized) {
    let handleScroll2 = function() {
      const currentScrollY = window.scrollY;
      if (currentScrollY > 20) {
        navbar.style.background = "rgba(3, 7, 18, 1)";
        navbar.style.borderBottomColor = "rgba(255, 255, 255, 0.1)";
      } else {
        navbar.style.background = "rgba(3, 7, 18, 0.98)";
        navbar.style.borderBottomColor = "rgba(255, 255, 255, 0.06)";
      }
    };
    var handleScroll = handleScroll2;
    navbar._scrollInitialized = true;
    window.addEventListener("scroll", handleScroll2);
  }
}
document.addEventListener("DOMContentLoaded", initializeNavbar);
document.addEventListener("turbo:load", initializeNavbar);
document.addEventListener("turbo:before-visit", function() {
  const mobileMenu = document.getElementById("mobile-menu");
  const mobileMenuBtn = document.getElementById("mobile-menu-button");
  if (mobileMenu && mobileMenu.classList.contains("active")) {
    mobileMenu.classList.remove("active");
    if (mobileMenuBtn) {
      mobileMenuBtn.setAttribute("aria-expanded", "false");
      const icon = mobileMenuBtn.querySelector("svg");
      if (icon) {
        icon.innerHTML = `
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
        `;
      }
    }
  }
});
//# sourceMappingURL=/assets/navbar.js.map
