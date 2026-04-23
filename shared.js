/* grades.scotch.quest — shared.js */

function startClock() {
  const el = document.getElementById('clock');
  if (!el) return;
  const tick = () => {
    const n = new Date();
    el.textContent = [n.getHours(), n.getMinutes(), n.getSeconds()]
      .map(x => String(x).padStart(2,'0')).join(':');
  };
  tick(); setInterval(tick, 1000);
}

// 1. KEEP THIS: This is your fallback/placeholder data
window.PS_DATA = {
  student: { name:'James Pliley', username:'james.pliley', id:'12345', grade:'11', school:'Your High School', term:'Q4 — Spring 2026', gpa:'3.7', counselor:'Ms. Torres' },
  courses: [
    { period:'1', name:'AP Computer Science A', code:'CSA401', teacher:'Harrison, T.', room:'214', credits:3.0, grade:'A+', pct:98.4, letterClass:'A', trend:'▲', missing:0 },
    // ... rest of your existing courses
  ],
  assignments: [ /* ... your existing assignments */ ],
  attendance: [ /* ... your existing attendance */ ],
  emails: [ /* ... your existing emails */ ],
  notifications: [ /* ... your existing notifications */ ],
  transcript: [ /* ... your existing transcript */ ]
};

// 2. PASTE THIS HERE: This overwrites the placeholder courses with real ones
async function loadRealData() {
  return new Promise(resolve => {
    chrome.storage.local.get('psData', d => {
      if (d.psData && d.psData.courses.length > 0) {
        // Change 'D.courses' to 'PS_DATA.courses' to match your file
        window.PS_DATA.courses = d.psData.courses.map(c => ({
          p:     c.period || '?',
          name:  c.name,
          grade: c.grade,
          pct:   c.pct,
          lc:    c.grade?.[0] || 'A',
          tchr:  c.teacher,
        }));
      }
      resolve();
    });
  });
}

// 3. PASTE THIS AT THE VERY BOTTOM:
window.addEventListener('DOMContentLoaded', async () => {
  await loadRealData();
  if (typeof pageInit === 'function') {
    pageInit();
  }
  startClock(); // Start your clock after data is ready
});

function gradeColor(l) {
  return {A:'var(--green)',B:'var(--cyan)',C:'var(--yellow)',D:'var(--amber)',F:'var(--red)'}[l[0]] || 'var(--green)';
}
// ... rest of your helper functions (statusPill, etc)
