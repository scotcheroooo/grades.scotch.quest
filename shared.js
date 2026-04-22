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

window.PS_DATA = {
  student: { name:'James Pliley', username:'james.pliley', id:'12345', grade:'11', school:'Your High School', term:'Q4 — Spring 2026', gpa:'3.7', counselor:'Ms. Torres' },
  courses: [
    { period:'1', name:'AP Computer Science A', code:'CSA401', teacher:'Harrison, T.', room:'214', credits:3.0, grade:'A+', pct:98.4, letterClass:'A', trend:'▲', missing:0 },
    { period:'2', name:'AP Lang & Composition',  code:'ENG401', teacher:'Reyes, M.',    room:'108', credits:3.0, grade:'B+', pct:89.1, letterClass:'B', trend:'▲', missing:0 },
    { period:'3', name:'Pre-Calculus',            code:'MTH350', teacher:'Chen, D.',     room:'306', credits:3.0, grade:'A-', pct:92.8, letterClass:'A', trend:'▶', missing:0 },
    { period:'4', name:'US History',              code:'HIS301', teacher:'Kaminsky, J.', room:'201', credits:2.5, grade:'C+', pct:77.3, letterClass:'C', trend:'▼', missing:2 },
    { period:'5', name:'Physics',                 code:'SCI320', teacher:'Okafor, K.',   room:'118', credits:3.0, grade:'B',  pct:84.6, letterClass:'B', trend:'▲', missing:0 },
    { period:'6', name:'Studio Art',              code:'ART210', teacher:'Park, S.',     room:'004', credits:1.5, grade:'A',  pct:95.2, letterClass:'A', trend:'▶', missing:0 },
    { period:'7', name:'Spanish III',             code:'SPA310', teacher:'Vega, R.',     room:'112', credits:2.5, grade:'B+', pct:87.9, letterClass:'B', trend:'▶', missing:0 },
  ],
  assignments: [
    { name:'Binary Trees Lab',            course:'AP Computer Science A', date:'2026-04-18', score:100, max:100, category:'Lab',   status:'graded'   },
    { name:'Rhetorical Analysis Essay',   course:'AP Lang & Composition', date:'2026-04-16', score:88,  max:100, category:'Essay', status:'graded'   },
    { name:'Unit 7 Test — Progressivism', course:'US History',            date:'2026-04-15', score:74,  max:100, category:'Test',  status:'graded'   },
    { name:'Kinematics Problem Set',      course:'Physics',               date:'2026-04-14', score:90,  max:100, category:'HW',    status:'graded'   },
    { name:'Preterite vs Imperfect Quiz', course:'Spanish III',           date:'2026-04-12', score:86,  max:100, category:'Quiz',  status:'graded'   },
    { name:'Manifest Destiny Reading',    course:'US History',            date:'2026-04-10', score:null,max:20,  category:'HW',    status:'missing'  },
    { name:'Spanish Oral Script',         course:'Spanish III',           date:'2026-04-09', score:null,max:20,  category:'Essay', status:'missing'  },
    { name:'Recursion Quiz',              course:'AP Computer Science A', date:'2026-04-23', score:null,max:50,  category:'Quiz',  status:'upcoming' },
    { name:'Synthesis Essay Draft',       course:'AP Lang & Composition', date:'2026-04-24', score:null,max:100, category:'Essay', status:'upcoming' },
    { name:'Trig Functions Test',         course:'Pre-Calculus',          date:'2026-04-25', score:null,max:100, category:'Test',  status:'upcoming' },
    { name:'WWII Primary Sources Essay',  course:'US History',            date:'2026-04-28', score:null,max:100, category:'Essay', status:'upcoming' },
    { name:'Wave Optics Lab Report',      course:'Physics',               date:'2026-04-30', score:null,max:50,  category:'Lab',   status:'upcoming' },
  ],
  attendance: [
    { date:'2026-04-21', period:'1', course:'AP Computer Science A', status:'present', note:'' },
    { date:'2026-04-21', period:'2', course:'AP Lang & Composition', status:'present', note:'' },
    { date:'2026-04-21', period:'3', course:'Pre-Calculus',          status:'present', note:'' },
    { date:'2026-04-18', period:'4', course:'US History',            status:'tardy',   note:'5 min late' },
    { date:'2026-04-17', period:'1', course:'AP Computer Science A', status:'present', note:'' },
    { date:'2026-04-15', period:'3', course:'Pre-Calculus',          status:'absent',  note:'Excused — doctor' },
    { date:'2026-04-14', period:'5', course:'Physics',               status:'present', note:'' },
    { date:'2026-04-10', period:'4', course:'US History',            status:'absent',  note:'Unexcused' },
    { date:'2026-04-08', period:'2', course:'AP Lang & Composition', status:'present', note:'' },
    { date:'2026-04-07', period:'6', course:'Studio Art',            status:'present', note:'' },
  ],
  emails: [
    { id:1, from:'Harrison, T.', subject:'Binary Trees Lab — great work!', preview:'Just wanted to say your submission was one of the best in the class...', date:'Apr 19', read:false },
    { id:2, from:'Kaminsky, J.', subject:'Missing work reminder',          preview:'You have 2 missing assignments in my class. Please submit by...', date:'Apr 17', read:false },
    { id:3, from:'Torres, C.',   subject:'AP Exam registration',           preview:'Reminder that AP exam registration closes May 1st. Please confirm your...', date:'Apr 15', read:false },
    { id:4, from:'Reyes, M.',    subject:'Feedback on Essay #3',           preview:'I left comments in your Google Doc. Overall strong thesis but...', date:'Apr 14', read:true  },
    { id:5, from:'Admin',        subject:'Q4 Progress Reports Available',  preview:'Q4 progress reports are now available in PowerSchool...', date:'Apr 12', read:true  },
    { id:6, from:'Okafor, K.',   subject:'Lab make-up opportunity',        preview:'For students who missed the wave optics lab, there will be a make-up session on...', date:'Apr 10', read:true  },
  ],
  notifications: [
    { id:1, type:'warn',  title:'Missing: Manifest Destiny Reading',       body:'US History · was due Apr 10 · −15 pts',         date:'Apr 11', read:false },
    { id:2, type:'warn',  title:'Missing: Spanish Oral Script',            body:'Spanish III · was due Apr 9 · −20 pts',          date:'Apr 10', read:false },
    { id:3, type:'alert', title:'Grade drop in US History (−4.2%)',        body:'Was 81.5% → now 77.3%',                          date:'Apr 15', read:false },
    { id:4, type:'info',  title:'AP Exam registration closes May 1',       body:'College Board · action required',                date:'Apr 12', read:true  },
    { id:5, type:'info',  title:'Teacher feedback on Essay #3',            body:'AP Lang · Ms. Reyes commented on your draft',    date:'Apr 19', read:true  },
    { id:6, type:'info',  title:'Q4 progress reports available',           body:'View in Transcript tab',                         date:'Apr 20', read:true  },
  ],
  transcript: [
    { term:'Fall 2024 — Q1',   course:'Algebra II',    grade:'A-', pct:92, credits:3.0 },
    { term:'Fall 2024 — Q1',   course:'Biology',       grade:'B+', pct:89, credits:3.0 },
    { term:'Fall 2024 — Q1',   course:'World History', grade:'A',  pct:94, credits:2.5 },
    { term:'Fall 2024 — Q2',   course:'Algebra II',    grade:'B+', pct:88, credits:3.0 },
    { term:'Fall 2024 — Q2',   course:'Biology',       grade:'A-', pct:91, credits:3.0 },
    { term:'Spring 2025 — Q3', course:'Pre-Calculus',  grade:'B+', pct:87, credits:3.0 },
    { term:'Spring 2025 — Q3', course:'AP CS A',       grade:'A',  pct:96, credits:3.0 },
    { term:'Spring 2025 — Q4', course:'Pre-Calculus',  grade:'A-', pct:91, credits:3.0 },
    { term:'Spring 2025 — Q4', course:'AP CS A',       grade:'A',  pct:97, credits:3.0 },
    { term:'Fall 2025 — Q1',   course:'AP Lang',       grade:'B',  pct:83, credits:3.0 },
    { term:'Fall 2025 — Q2',   course:'AP Lang',       grade:'B+', pct:87, credits:3.0 },
  ]
};

function gradeColor(l) {
  return {A:'var(--green)',B:'var(--cyan)',C:'var(--yellow)',D:'var(--amber)',F:'var(--red)'}[l[0]] || 'var(--green)';
}
function statusPill(s) {
  return {
    graded:  '<span class="pill green">graded</span>',
    missing: '<span class="pill red">missing</span>',
    upcoming:'<span class="pill cyan">upcoming</span>',
    late:    '<span class="pill amber">late</span>',
    present: '<span class="pill green">present</span>',
    absent:  '<span class="pill red">absent</span>',
    tardy:   '<span class="pill amber">tardy</span>',
    excused: '<span class="pill yellow">excused</span>',
  }[s] || `<span class="pill">${s}</span>`;
}
function daysUntil(d) {
  const diff = Math.ceil((new Date(d) - new Date()) / 86400000);
  if (diff < 0) return `${Math.abs(diff)}d ago`;
  if (diff === 0) return 'today';
  return `in ${diff}d`;
}
function scoreColor(pct) {
  if (pct >= 90) return 'var(--green)';
  if (pct >= 80) return 'var(--cyan)';
  if (pct >= 70) return 'var(--yellow)';
  if (pct >= 60) return 'var(--amber)';
  return 'var(--red)';
}

window.addEventListener('DOMContentLoaded', startClock);
