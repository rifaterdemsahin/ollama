/* nav.js — Shared navigation component for Ollama Self-Learning System
 * Usage: <nav id="main-nav" data-root="."></nav>
 * data-root: relative path from current page to project root ("." or "..")
 */
(function () {
  'use strict';

  /* ── Cookie helpers ─────────────────────────────────────────────────────── */
  function getCookie(name) {
    var m = document.cookie.match(new RegExp('(^| )' + name + '=([^;]+)'));
    return m ? m[2] : null;
  }
  function setCookie(name, value, days) {
    var exp = new Date();
    exp.setDate(exp.getDate() + (days || 30));
    document.cookie = name + '=' + value + '; expires=' + exp.toUTCString() + '; path=/';
  }
  function delCookie(name) {
    document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/';
  }

  /* ── Debug mode ─────────────────────────────────────────────────────────── */
  function isDebug() {
    var p = new URLSearchParams(window.location.search);
    if (p.has('debug')) {
      if (p.get('debug') === 'true') { setCookie('debug', 'true', 30); return true; }
      delCookie('debug'); return false;
    }
    return getCookie('debug') === 'true';
  }

  /* ── Bootstrap ──────────────────────────────────────────────────────────── */
  var navEl = document.getElementById('main-nav');
  if (!navEl) return;

  var root = (navEl.getAttribute('data-root') || '.').replace(/\/$/, '');
  var debug = isDebug();

  fetch(root + '/nav_config.json')
    .then(function (r) { return r.json(); })
    .then(function (cfg) { buildNav(cfg); })
    .catch(function (e) { console.warn('[nav.js] Could not load nav_config.json', e); });

  /* ── Build nav HTML ─────────────────────────────────────────────────────── */
  function buildNav(cfg) {
    var s = cfg.social || [];
    var cm = cfg.contentMenu || [];
    var dm = cfg.debugMenu || [];

    var socialHtml = s.map(function (x) {
      return '<a href="' + x.url + '" target="_blank" rel="noopener" class="nav-social-link" title="' + (x.title || x.label) + '">' + x.icon + '</a>';
    }).join('');

    var debugBarHtml = debug ? [
      '<div class="nav-debug-bar" id="nav-debug-bar">',
      '<span class="nav-debug-label">🐛 Debug</span>',
      dm.map(function (x) {
        return '<a href="' + root + '/markdown_renderer.html?file=' + x.path + '" class="nav-debug-link">' + x.emoji + ' ' + x.label + '</a>';
      }).join(''),
      '</div>'
    ].join('') : '';

    var contentBarHtml = [
      '<div class="nav-content-bar" id="nav-content-bar">',
      cm.map(function (x) {
        return '<a href="' + root + '/' + x.path + '" class="nav-content-link">' + x.emoji + ' ' + x.label + '</a>';
      }).join(''),
      '</div>'
    ].join('');

    var mobileSections = [
      mobileSection('Navigation', cm.map(function (x) {
        return '<a href="' + root + '/' + x.path + '" class="nav-mobile-link">' + x.emoji + ' ' + x.label + '</a>';
      }).join(''))
    ];
    if (debug) {
      mobileSections.push(mobileSection('🐛 Debug — Markdown', dm.map(function (x) {
        return '<a href="' + root + '/markdown_renderer.html?file=' + x.path + '" class="nav-mobile-link">' + x.emoji + ' ' + x.label + '</a>';
      }).join('')));
    }
    mobileSections.push(mobileSection('Connect', s.map(function (x) {
      return '<a href="' + x.url + '" target="_blank" rel="noopener" class="nav-mobile-link">' + x.icon + ' ' + x.label + '</a>';
    }).join('')));

    var toggleLabel = debug ? '🐛 Debug ON' : '🔧';
    var toggleClass = debug ? 'debug-toggle-btn debug-on' : 'debug-toggle-btn';

    navEl.innerHTML = [
      '<div class="nav-container">',
        '<div class="nav-top">',
          '<div class="nav-brand">',
            '<button class="nav-hamburger" id="nav-hamburger" aria-label="Toggle menu" aria-expanded="false">☰</button>',
            '<a href="' + root + '/index.html" class="nav-title">' + (cfg.site && cfg.site.title ? cfg.site.title : 'Ollama') + '</a>',
          '</div>',
          '<div class="nav-search-wrap">',
            '<input type="text" id="nav-search" class="nav-search" placeholder="🔍 Search pages..." autocomplete="off" aria-label="Search pages" role="combobox" aria-expanded="false" aria-controls="nav-search-results">',
            '<div id="nav-search-results" class="nav-search-results" role="listbox"></div>',
          '</div>',
          '<div class="nav-social">' + socialHtml + '</div>',
        '</div>',
        debugBarHtml,
        contentBarHtml,
        '<div class="nav-mobile-menu" id="nav-mobile-menu">',
          mobileSections.join(''),
        '</div>',
      '</div>',
      '<button id="debug-toggle-btn" class="' + toggleClass + '" title="Toggle debug mode">' + toggleLabel + '</button>'
    ].join('');

    /* attach events */
    attachSearch(buildSearchIndex(cfg));
    attachHamburger();
    attachDebugToggle();
    highlightActive(cm, dm, root, debug);
  }

  function mobileSection(title, linksHtml) {
    return '<div class="nav-mobile-section"><div class="nav-mobile-section-title">' + title + '</div>' + linksHtml + '</div>';
  }

  /* ── Search index ───────────────────────────────────────────────────────── */
  function buildSearchIndex(cfg) {
    var idx = [];
    (cfg.contentMenu || []).forEach(function (x) {
      idx.push({ label: x.label, desc: x.description || '', emoji: x.emoji || '📄', href: (x.path.startsWith('http') ? x.path : root + '/' + x.path) });
    });
    if (debug) {
      (cfg.debugMenu || []).forEach(function (x) {
        idx.push({ label: x.label + ' (MD)', desc: x.description || '', emoji: x.emoji || '📝', href: root + '/markdown_renderer.html?file=' + x.path });
      });
    }
    (cfg.searchExtra || []).forEach(function (x) {
      idx.push({ label: x.label, desc: x.description || '', emoji: x.emoji || '📄', href: (x.path.startsWith('http') ? x.path : root + '/' + x.path) });
    });
    return idx;
  }

  /* ── Attach search ──────────────────────────────────────────────────────── */
  function attachSearch(idx) {
    var inp = document.getElementById('nav-search');
    var box = document.getElementById('nav-search-results');
    if (!inp || !box) return;

    var active = -1;

    function esc(s) { return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); }
    function mark(text, q) {
      return text.replace(new RegExp('(' + esc(q) + ')', 'gi'), '<mark>$1</mark>');
    }

    inp.addEventListener('input', function () {
      var q = this.value.trim().toLowerCase();
      if (!q) { box.innerHTML = ''; box.style.display = 'none'; inp.setAttribute('aria-expanded', 'false'); return; }

      var hits = idx.filter(function (x) {
        return x.label.toLowerCase().includes(q) || x.desc.toLowerCase().includes(q);
      }).slice(0, 8);

      if (!hits.length) {
        box.innerHTML = '<div class="nav-search-empty">No results for "' + q + '"</div>';
        box.style.display = 'block';
        inp.setAttribute('aria-expanded', 'true');
        return;
      }

      active = -1;
      box.innerHTML = hits.map(function (x, i) {
        return '<a href="' + x.href + '" class="nav-search-item" role="option" data-i="' + i + '">' +
          '<span class="nav-search-emoji">' + x.emoji + '</span>' +
          '<span class="nav-search-text">' +
            '<span class="nav-search-label">' + mark(x.label, q) + '</span>' +
            (x.desc ? '<span class="nav-search-desc">' + x.desc + '</span>' : '') +
          '</span></a>';
      }).join('');
      box.style.display = 'block';
      inp.setAttribute('aria-expanded', 'true');
    });

    inp.addEventListener('keydown', function (e) {
      var items = box.querySelectorAll('.nav-search-item');
      if (!items.length) return;
      if (e.key === 'ArrowDown') { e.preventDefault(); active = Math.min(active + 1, items.length - 1); setActive(items); }
      else if (e.key === 'ArrowUp') { e.preventDefault(); active = Math.max(active - 1, 0); setActive(items); }
      else if (e.key === 'Enter' && active >= 0) { items[active].click(); }
      else if (e.key === 'Escape') { box.style.display = 'none'; inp.setAttribute('aria-expanded', 'false'); active = -1; }
    });

    document.addEventListener('click', function (e) {
      if (!e.target.closest('#nav-search') && !e.target.closest('#nav-search-results')) {
        box.style.display = 'none';
        inp.setAttribute('aria-expanded', 'false');
      }
    });

    function setActive(items) {
      items.forEach(function (el, i) { el.classList.toggle('active', i === active); });
      if (active >= 0) items[active].scrollIntoView({ block: 'nearest' });
    }
  }

  /* ── Hamburger ──────────────────────────────────────────────────────────── */
  function attachHamburger() {
    var btn  = document.getElementById('nav-hamburger');
    var menu = document.getElementById('nav-mobile-menu');
    if (!btn || !menu) return;

    btn.addEventListener('click', function (e) {
      e.stopPropagation();
      var open = menu.classList.toggle('open');
      btn.setAttribute('aria-expanded', String(open));
      btn.textContent = open ? '✕' : '☰';
    });

    document.addEventListener('click', function (e) {
      if (!e.target.closest('#main-nav')) {
        menu.classList.remove('open');
        btn.textContent = '☰';
        btn.setAttribute('aria-expanded', 'false');
      }
    });
  }

  /* ── Debug toggle ───────────────────────────────────────────────────────── */
  function attachDebugToggle() {
    var btn = document.getElementById('debug-toggle-btn');
    if (!btn) return;
    btn.addEventListener('click', function () {
      if (debug) {
        delCookie('debug');
        var u = new URL(window.location.href);
        u.searchParams.delete('debug');
        window.location.href = u.toString();
      } else {
        setCookie('debug', 'true', 30);
        window.location.reload();
      }
    });
  }

  /* ── Active link highlight ──────────────────────────────────────────────── */
  function highlightActive(cm, dm, root, dbg) {
    var path = window.location.pathname;
    var allLinks = document.querySelectorAll('.nav-content-link, .nav-debug-link, .nav-mobile-link');
    allLinks.forEach(function (a) {
      var href = a.getAttribute('href') || '';
      var rel  = href.replace(root, '').replace(/^\//, '');
      if (rel && path.endsWith(rel)) a.classList.add('active');
    });
  }

})();
