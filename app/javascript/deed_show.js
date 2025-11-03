// Deed show page functionality
let timerUpdateInterval = null;
let startTime = null;

function initDeedShowPage() {
  // Initialize toggle status indicator
  const checkbox = document.querySelector('input[type="checkbox"][id*="finished"]');
  if (checkbox) {
    checkbox.addEventListener('change', function() {
      toggleStatusIndicator(this);
    });
  }

  // Initialize timer functionality
  initTimer();  
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
      
      // Set display to 00:00:00 immediately, then start updating
      const display = document.getElementById('timer-display');
      if (display) display.textContent = '00:00:00';
      
      updateTimerUI(true);
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
      
    } else {
      alert('Failed to stop timer: ' + (data.error || 'Unknown error'));
    }
  })
  .catch(error => {
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