// Deed show page functionality
let timerUpdateInterval = null;
let startTime = null;

// Global click handler for description toggle - simple and reliable
document.addEventListener('click', function(e) {
  const toggleBtn = e.target.closest('.toggle-description-btn');
  if (toggleBtn) {
    e.preventDefault();
    e.stopPropagation();
    console.log('🔘 Toggle button clicked!');
    
    const content = document.getElementById('description-content');
    const arrow = document.getElementById('description-arrow');
    
    if (!content || !arrow) {
      console.error('❌ Description elements not found!');
      return;
    }
    
    // Toggle based on current DOM state
    const isHidden = content.classList.contains('description-hidden');
    console.log('Current state - Hidden:', isHidden);
    
    if (isHidden) {
      // Open
      content.classList.remove('description-hidden');
      content.style.height = 'auto';
      arrow.style.transform = 'rotate(180deg)';
      console.log('✅ Description OPENED');
    } else {
      // Close
      content.classList.add('description-hidden');
      content.style.height = '0';
      arrow.style.transform = 'rotate(0deg)';
      console.log('✅ Description CLOSED');
    }
  }
});

function initDeedShowPage() {
  console.log('🚀 Initializing deed show page...');

  // Initialize toggle status indicator
  const checkbox = document.querySelector('input[type="checkbox"][id*="finished"]');
  if (checkbox) {
    checkbox.addEventListener('change', function() {
      toggleStatusIndicator(this);
    });
  }

  // Auto-show description on page load
  setTimeout(() => {
    const descContent = document.getElementById('description-content');
    const arrow = document.getElementById('description-arrow');
    
    if (descContent && descContent.classList.contains('description-hidden')) {
      console.log('🚀 Auto-opening description on page load');
      descContent.classList.remove('description-hidden');
      descContent.style.height = 'auto';
      if (arrow) arrow.style.transform = 'rotate(180deg)';
    }
  }, 100);

  // Initialize timer functionality
  initTimer();
  
  console.log('✅ Deed show page initialized');
}

function toggleStatusIndicator(checkbox) {
  const text = document.getElementById('status-text');
  const submitBtn = checkbox.form.querySelector('input[type="submit"]');
  
  if (checkbox.checked) {
    text.textContent = 'Done';
    submitBtn.textContent = 'Complete';
    submitBtn.className = 'px-4 py-1.5 bg-green-600 hover:bg-green-700 text-white font-medium rounded-md transition-colors text-xs hover-lift';
  } else {
    text.textContent = 'Mark Done';
    submitBtn.textContent = 'Update';
    submitBtn.className = 'px-4 py-1.5 bg-green-600 hover:bg-green-700 text-white font-medium rounded-md transition-colors text-xs hover-lift';
  }
}

function toggleDescription() {
  console.log('toggleDescription called, current state:', isDescriptionOpen);
  
  const content = document.getElementById('description-content');
  const arrow = document.getElementById('description-arrow');
  
  if (!content || !arrow) {
    console.error('Description elements not found');
    return;
  }
  
  // Check actual state from DOM
  const isActuallyHidden = content.classList.contains('description-hidden');
  console.log('DOM state - isHidden:', isActuallyHidden);
  
  if (isActuallyHidden) {
    // Open
    content.classList.remove('description-hidden');
    content.style.height = 'auto';
    arrow.style.transform = 'rotate(180deg)';
    isDescriptionOpen = true;
    console.log('Description opened');
  } else {
    // Close
    content.classList.add('description-hidden');
    content.style.height = '0';
    arrow.style.transform = 'rotate(0deg)';
    isDescriptionOpen = false;
    console.log('Description closed');
  }
}

function initTimer() {
  const startBtn = document.getElementById('start-timer');
  const stopBtn = document.getElementById('stop-timer');
  const display = document.getElementById('timer-display');
  const indicator = document.getElementById('timer-indicator');

  if (startBtn) {
    startBtn.addEventListener('click', function() {
      const deedId = this.dataset.deedId;
      startTimer(deedId);
    });
  }

  if (stopBtn) {
    stopBtn.addEventListener('click', function() {
      const deedId = this.dataset.deedId;
      stopTimer(deedId);
    });
  }

  checkTimerStatus();
}

function startTimer(deedId) {  
  fetch(`/daily_logs/start_timer`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
    },
    body: JSON.stringify({ deed_id: deedId })
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      startTime = new Date(data.start_time);
      
      updateTimerUI(true);
      updateTimerDisplay();
      startTimerUpdates();
    } else {
      alert('Failed to start timer: ' + (data.error || 'Unknown error'));
    }
  })
  .catch(error => {
    alert('Error starting timer. Please try again.');
  });
}

function stopTimer(deedId) {
  
  fetch(`/daily_logs/stop_timer`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
    },
    body: JSON.stringify({ deed_id: deedId })
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      clearInterval(timerUpdateInterval);
      timerUpdateInterval = null;
      startTime = null;
      
      updateTimerUI(false);
      
      if (data.total_time) {
        const totalTimeEl = document.getElementById('total-time');
        if (totalTimeEl) totalTimeEl.textContent = data.total_time;
      }
      if (data.today_time) {
        const todayTimeEl = document.getElementById('today-time');
        if (todayTimeEl) todayTimeEl.textContent = data.today_time;
      }
      
      const display = document.getElementById('timer-display');
      if (display) display.textContent = '00:00:00';
      
      console.log('Timer stopped successfully');
    } else {
      console.error('Failed to stop timer:', data.error);
      alert('Failed to stop timer: ' + (data.error || 'Unknown error'));
    }
  })
  .catch(error => {
    console.error('Error stopping timer:', error);
    alert('Error stopping timer. Please try again.');
  });
}

function checkTimerStatus() {
  const deedId = document.getElementById('start-timer')?.dataset.deedId;
  if (!deedId) return;

  fetch(`/daily_logs/timer_status?deed_id=${deedId}`)
  .then(response => response.json())
  .then(data => {
    if (data.running) {
      startTime = new Date(data.start_time);
      updateTimerDisplay();
      startTimerUpdates();
      updateTimerUI(true);
    }
  });
}

function startTimerUpdates() {
  timerUpdateInterval = setInterval(updateTimerDisplay, 1000);
}

function updateTimerDisplay() {
  if (!startTime) return;
  
  const now = new Date();
  const elapsed = Math.floor((now - startTime) / 1000);
  
  const hours = Math.floor(elapsed / 3600);
  const minutes = Math.floor((elapsed % 3600) / 60);
  const seconds = elapsed % 60;
  
  const display = document.getElementById('timer-display');
  if (display) {
    display.textContent = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
  }
}

function updateTimerUI(isRunning) {
  console.log('Updating timer UI, isRunning:', isRunning);
  
  const startBtn = document.getElementById('start-timer');
  const stopBtn = document.getElementById('stop-timer');
  const indicator = document.getElementById('timer-indicator');
  
  if (isRunning) {
    if (startBtn) {
      startBtn.style.display = 'none';
      startBtn.disabled = true;
    }
    if (stopBtn) {
      stopBtn.style.display = 'inline-block';
      stopBtn.disabled = false;
    }
    if (indicator) {
      indicator.className = 'w-2 h-2 rounded-full bg-green-500 animate-pulse';
    }
    console.log('Timer UI updated to RUNNING state');
  } else {
    if (startBtn) {
      startBtn.style.display = 'inline-block';
      startBtn.disabled = false;
    }
    if (stopBtn) {
      stopBtn.style.display = 'none';
      stopBtn.disabled = true;
    }
    if (indicator) {
      indicator.className = 'w-2 h-2 rounded-full bg-red-500';
    }
    console.log('Timer UI updated to STOPPED state');
  }
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', initDeedShowPage);
document.addEventListener('turbo:load', initDeedShowPage);

// Cleanup on page leave
document.addEventListener('turbo:before-visit', function() {
  if (timerUpdateInterval) {
    clearInterval(timerUpdateInterval);
    timerUpdateInterval = null;
  }
});

// Make functions globally available if needed
window.toggleDescription = toggleDescription;
window.toggleStatusIndicator = toggleStatusIndicator;