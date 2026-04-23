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

async function loadFromProxy() {
  try {
    const res = await fetch('http://localhost:3001/api/grades'); // or your deployed URL
    const json = await res.json();
    if (json.ok && json.courses.length) {
      D.courses = json.courses.map(c => ({
        p:     c.period,
        name:  c.name,
        grade: c.grade || '—',
        pct:   c.pct || 0,
        lc:    (c.grade || 'A')[0],
        tchr:  c.teacher,
        room:  c.room,
        cr:    3.0,
        miss:  0,
        trend: '▶',
        code:  '',
      }));
    }
  } catch(e) {
    console.warn('[gsq] proxy unreachable, using demo data');
  }
}

window.addEventListener('DOMContentLoaded', async () => {
  if (!auth()) return;
  await loadFromProxy();
  // ... rest of your init
});

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
