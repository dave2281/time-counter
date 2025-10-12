// app/javascript/deed_show.js
var isDescriptionOpen = false;
var timerUpdateInterval = null;
var startTime = null;
function initDeedShowPage() {
  const toggleBtns = document.querySelectorAll(".toggle-description-btn");
  toggleBtns.forEach((btn) => {
    btn.addEventListener("click", function(e) {
      e.preventDefault();
      toggleDescription();
    });
  });
  const checkbox = document.querySelector('input[type="checkbox"][id*="finished"]');
  if (checkbox) {
    checkbox.addEventListener("change", function() {
      toggleStatusIndicator(this);
    });
  }
  setTimeout(() => {
    if (document.getElementById("description-content")) {
      toggleDescription();
    }
  }, 100);
  initTimer();
}
function toggleStatusIndicator(checkbox) {
  const text = document.getElementById("status-text");
  const submitBtn = checkbox.form.querySelector('input[type="submit"]');
  if (checkbox.checked) {
    text.textContent = "Done";
    submitBtn.textContent = "Complete";
    submitBtn.className = "px-4 py-1.5 bg-green-600 hover:bg-green-700 text-white font-medium rounded-md transition-colors text-xs hover-lift";
  } else {
    text.textContent = "Mark Done";
    submitBtn.textContent = "Update";
    submitBtn.className = "px-4 py-1.5 bg-green-600 hover:bg-green-700 text-white font-medium rounded-md transition-colors text-xs hover-lift";
  }
}
function toggleDescription() {
  const content = document.getElementById("description-content");
  const arrow = document.getElementById("description-arrow");
  if (!isDescriptionOpen) {
    content.classList.remove("description-hidden");
    content.style.height = "auto";
    arrow.style.transform = "rotate(180deg)";
    isDescriptionOpen = true;
  } else {
    content.classList.add("description-hidden");
    content.style.height = "0";
    arrow.style.transform = "rotate(0deg)";
    isDescriptionOpen = false;
  }
}
function initTimer() {
  const startBtn = document.getElementById("start-timer");
  const stopBtn = document.getElementById("stop-timer");
  const display = document.getElementById("timer-display");
  const indicator = document.getElementById("timer-indicator");
  if (startBtn) {
    startBtn.addEventListener("click", function() {
      const deedId = this.dataset.deedId;
      startTimer(deedId);
    });
  }
  if (stopBtn) {
    stopBtn.addEventListener("click", function() {
      const deedId = this.dataset.deedId;
      stopTimer(deedId);
    });
  }
  checkTimerStatus();
}
function startTimer(deedId) {
  fetch(`/daily_logs/start_timer`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content
    },
    body: JSON.stringify({ deed_id: deedId })
  }).then((response) => response.json()).then((data) => {
    if (data.success) {
      startTime = new Date(data.start_time);
      updateTimerDisplay();
      startTimerUpdates();
      updateTimerUI(true);
    }
  });
}
function stopTimer(deedId) {
  fetch(`/daily_logs/stop_timer`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content
    },
    body: JSON.stringify({ deed_id: deedId })
  }).then((response) => response.json()).then((data) => {
    if (data.success) {
      clearInterval(timerUpdateInterval);
      updateTimerUI(false);
      window.location.reload();
    }
  });
}
function checkTimerStatus() {
  const deedId = document.getElementById("start-timer")?.dataset.deedId;
  if (!deedId) return;
  fetch(`/daily_logs/timer_status?deed_id=${deedId}`).then((response) => response.json()).then((data) => {
    if (data.running) {
      startTime = new Date(data.start_time);
      updateTimerDisplay();
      startTimerUpdates();
      updateTimerUI(true);
    }
  });
}
function startTimerUpdates() {
  timerUpdateInterval = setInterval(updateTimerDisplay, 1e3);
}
function updateTimerDisplay() {
  if (!startTime) return;
  const now = /* @__PURE__ */ new Date();
  const elapsed = Math.floor((now - startTime) / 1e3);
  const hours = Math.floor(elapsed / 3600);
  const minutes = Math.floor(elapsed % 3600 / 60);
  const seconds = elapsed % 60;
  const display = document.getElementById("timer-display");
  if (display) {
    display.textContent = `${hours.toString().padStart(2, "0")}:${minutes.toString().padStart(2, "0")}:${seconds.toString().padStart(2, "0")}`;
  }
}
function updateTimerUI(isRunning) {
  const startBtn = document.getElementById("start-timer");
  const stopBtn = document.getElementById("stop-timer");
  const indicator = document.getElementById("timer-indicator");
  if (isRunning) {
    if (startBtn) startBtn.style.display = "none";
    if (stopBtn) stopBtn.style.display = "inline-block";
    if (indicator) {
      indicator.className = "w-2 h-2 rounded-full bg-green-500";
    }
  } else {
    if (startBtn) startBtn.style.display = "inline-block";
    if (stopBtn) stopBtn.style.display = "none";
    if (indicator) {
      indicator.className = "w-2 h-2 rounded-full bg-red-500";
    }
  }
}
document.addEventListener("DOMContentLoaded", initDeedShowPage);
document.addEventListener("turbo:load", initDeedShowPage);
document.addEventListener("turbo:before-visit", function() {
  if (timerUpdateInterval) {
    clearInterval(timerUpdateInterval);
    timerUpdateInterval = null;
  }
});
window.toggleDescription = toggleDescription;
window.toggleStatusIndicator = toggleStatusIndicator;
//# sourceMappingURL=/assets/deed_show.js.map
