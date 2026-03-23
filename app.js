/* ══════════════════════════════════════════════
   BlueCandleFx – app.js
   Enhanced preloader, particle canvas, hero, scroll-reveal
══════════════════════════════════════════════ */

'use strict';

// ─────────────────────────────────────────────
// 1. PARTICLE CANVAS (loader background)
//    Enhanced: includes forex symbol rain + glow dots
// ─────────────────────────────────────────────
(function initParticles() {
    const canvas = document.getElementById('particleCanvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    let W, H, particles = [], animId;

    function resize() {
        W = canvas.width = window.innerWidth;
        H = canvas.height = window.innerHeight;
    }

    resize();
    window.addEventListener('resize', resize);

    // ── Glowing dots
    class Particle {
        constructor() { this.reset(true); }
        reset(init) {
            this.x = Math.random() * W;
            this.y = init ? Math.random() * H : H + 10;
            this.vx = (Math.random() - 0.5) * 0.5;
            this.vy = -(Math.random() * 0.7 + 0.2);
            this.r = Math.random() * 2 + 0.4;
            this.alpha = Math.random() * 0.5 + 0.1;
            this.color = ['59,130,246', '34,197,94', '168,85,247'][Math.floor(Math.random() * 3)];
        }
        update() {
            this.x += this.vx;
            this.y += this.vy;
            if (this.y < -10) this.reset(false);
        }
        draw() {
            ctx.beginPath();
            ctx.arc(this.x, this.y, this.r, 0, Math.PI * 2);
            ctx.fillStyle = `rgba(${this.color},${this.alpha})`;
            ctx.fill();
        }
    }

    for (let i = 0; i < 140; i++) particles.push(new Particle());

    function loop() {
        ctx.clearRect(0, 0, W, H);
        particles.forEach(p => { p.update(); p.draw(); });
        animId = requestAnimationFrame(loop);
    }

    loop();
    window._stopParticles = () => cancelAnimationFrame(animId);
})();


// ─────────────────────────────────────────────
// 2. ENHANCED PRELOADER SEQUENCE
// ─────────────────────────────────────────────
(function initPreloader() {
    const loader = document.getElementById('loader');
    const logoStage = document.getElementById('logoStage');
    const barWrap = document.getElementById('loaderBarWrap');
    const bar = document.getElementById('loaderBar');
    const statusRow = document.querySelector('.loader-status-row');
    const pct = document.getElementById('loaderPct');
    const statusMsg = document.getElementById('loaderStatusMsg');
    const typedBlue = document.getElementById('typedBlue');
    const typedCandle = document.getElementById('typedCandle');
    const typeCursor = document.getElementById('typeCursor');
    const mainContent = document.getElementById('mainContent');
    const rings = document.querySelectorAll('.logo-ring');
    const tagline = document.getElementById('loaderTagline');

    const WORD_A = 'Blue';
    const WORD_B = 'CandleFx';
    const STATUS_MSGS = [
        'Initialising markets…',
        'Loading price data…',
        'Calibrating indicators…',
        'Connecting live feeds…',
        'Almost ready…',
    ];

    let barTimer = null;
    let progress = 0;

    if (sessionStorage.getItem('preloaderShown') === 'true') {
        if (loader) loader.style.display = 'none';
        if (mainContent) {
            mainContent.style.display = 'block';
            mainContent.style.opacity = '1';
        }
        window._stopParticles && window._stopParticles();
        initMainPage();
        return;
    }

    function startLogoPhase() {
        if (rings) rings.forEach(r => r.classList.add('active'));
        if (tagline) tagline.style.opacity = '0';
        setTimeout(() => startTyping(), 200);
    }

    startLogoPhase();

    function startTyping() {
        const fullText = WORD_A + WORD_B;
        let idx = 0;
        const speed = 60;

        function typeNext() {
            if (idx <= WORD_A.length) {
                if (typedBlue) typedBlue.textContent = fullText.slice(0, idx);
                if (typedCandle) typedCandle.textContent = '';
            } else {
                if (typedBlue) typedBlue.textContent = WORD_A;
                if (typedCandle) typedCandle.textContent = fullText.slice(WORD_A.length, idx);
            }
            idx++;
            if (idx <= fullText.length) {
                setTimeout(typeNext, speed);
            } else {
                setTimeout(() => {
                    if (typeCursor) typeCursor.style.display = 'none';
                    if (tagline) {
                        tagline.style.transition = 'opacity 0.5s ease';
                        tagline.style.opacity = '1';
                    }
                    startProgressBar();
                }, 200);
            }
        }
        typeNext();
    }

    function startProgressBar() {
        if (barWrap) barWrap.classList.add('visible');
        if (statusRow) statusRow.classList.add('visible');

        const TOTAL = 1400;
        const INTERVAL = 30;
        const STEPS = TOTAL / INTERVAL;
        let step = 0;
        let msgIdx = 0;

        if (statusMsg) statusMsg.textContent = STATUS_MSGS[0];

        barTimer = setInterval(() => {
            step++;
            const t = step / STEPS;
            const ease = t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
            progress = Math.min(Math.round(ease * 100), 99);

            if (bar) bar.style.width = progress + '%';
            if (pct) pct.textContent = progress + '%';

            const newMsgIdx = Math.min(Math.floor((progress / 100) * STATUS_MSGS.length), STATUS_MSGS.length - 1);
            if (newMsgIdx !== msgIdx && statusMsg) {
                msgIdx = newMsgIdx;
                statusMsg.style.opacity = '0';
                statusMsg.style.transition = 'opacity 0.2s';
                setTimeout(() => {
                    statusMsg.textContent = STATUS_MSGS[msgIdx];
                    statusMsg.style.opacity = '1';
                }, 220);
            }

            if (step >= STEPS) {
                clearInterval(barTimer);
                finishPreloader();
            }
        }, INTERVAL);
    }

    function finishPreloader() {
        if (bar) bar.style.width = '100%';
        if (pct) pct.textContent = '100%';
        if (statusMsg) statusMsg.textContent = 'Ready!';

        setTimeout(() => {
            if (loader) loader.classList.add('fade-out');
            if (mainContent) {
                mainContent.style.display = 'block';
                mainContent.classList.add('fade-in');
            }

            if (loader) {
                loader.addEventListener('animationend', () => {
                    loader.remove();
                    window._stopParticles && window._stopParticles();
                    sessionStorage.setItem('preloaderShown', 'true');
                    initMainPage();
                }, { once: true });
            }
        }, 300);
    }

    setTimeout(() => {
        const currentLoader = document.getElementById('loader');
        if (currentLoader) {
            if (barTimer) clearInterval(barTimer);
            currentLoader.remove();
            if (mainContent) {
                mainContent.style.display = 'block';
                mainContent.classList.add('fade-in');
            }
            setTimeout(initMainPage, 50);
        }
    }, 7000);
})();


// ─────────────────────────────────────────────
// 3. MAIN PAGE INITIALISATION
// ─────────────────────────────────────────────
function initMainPage() {
    initNavScroll();
    initHeroCanvas();
    initScrollReveal();
    initOfferingsScroll();
    initWhyScroll();
    initTimelineScroll();
    initCommunityReveal();
}


// ─────────────────────────────────────────────
// 4. NAV SCROLL EFFECT
// ─────────────────────────────────────────────
function initNavScroll() {
    const nav = document.getElementById('navbar');
    if (!nav) return;
    const onScroll = () => {
        nav.classList.toggle('scrolled', window.scrollY > 40);
    };
    window.addEventListener('scroll', onScroll, { passive: true });
}


// ─────────────────────────────────────────────
// 5. HERO CANVAS – animated market lines
// ─────────────────────────────────────────────
function initHeroCanvas() {
    const canvas = document.getElementById('heroCanvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    let W, H;

    function resize() {
        W = canvas.width = canvas.offsetWidth;
        H = canvas.height = canvas.offsetHeight;
    }

    resize();
    window.addEventListener('resize', resize);

    function tick() {
        ctx.clearRect(0, 0, W, H);
        requestAnimationFrame(tick);
    }
    tick();
}


// ─────────────────────────────────────────────
// 6. SCROLL REVEAL – all card types
// ─────────────────────────────────────────────
function initScrollReveal() {
    const selector = [
        '.feat-card', '.offer-card', '.why-card',
        '.team-card', '.rm-col', '.resource-card',
        '.contact-card', '.mission-card'
    ].join(', ');

    const revealableEls = document.querySelectorAll(selector);

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (!entry.isIntersecting) return;
            const delay = parseInt(entry.target.dataset.delay || 0);
            setTimeout(() => {
                entry.target.classList.add('revealed');
            }, delay);
            observer.unobserve(entry.target);
        });
    }, { threshold: 0.12 });

    revealableEls.forEach(el => observer.observe(el));
}


// ─────────────────────────────────────────────
// 6b. OFFERINGS HORIZONTAL SCROLL & CARD REVEAL
// ─────────────────────────────────────────────
function initOfferingsScroll() {
    const grid = document.querySelector('.offerings-grid');
    if (!grid) return;

    grid.addEventListener('wheel', (e) => {
        if (e.deltaY !== 0) {
            e.preventDefault();
            grid.scrollBy({ left: e.deltaY * 1.5, behavior: 'smooth' });
        }
    }, { passive: false });

    const cards = grid.querySelectorAll('.offer-card');

    function checkVisibility() {
        const gridRect = grid.getBoundingClientRect();
        cards.forEach((card, i) => {
            if (card.classList.contains('revealed')) return;
            const rect = card.getBoundingClientRect();
            if (rect.left < gridRect.right && rect.right > gridRect.left) {
                setTimeout(() => card.classList.add('revealed'), i * 80);
            }
        });
    }

    grid.addEventListener('scroll', checkVisibility, { passive: true });

    const sectionObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                checkVisibility();
                sectionObserver.disconnect();
            }
        });
    }, { threshold: 0.1 });

    sectionObserver.observe(grid);
}


// ─────────────────────────────────────────────
// 6c. WHY BLUECANDLEFX HORIZONTAL SCROLL & REVEAL
// ─────────────────────────────────────────────
function initWhyScroll() {
    const grid = document.querySelector('.why-grid');
    if (!grid) return;

    grid.addEventListener('wheel', (e) => {
        if (e.deltaY !== 0) {
            e.preventDefault();
            grid.scrollBy({ left: e.deltaY * 1.5, behavior: 'smooth' });
        }
    }, { passive: false });

    const cards = grid.querySelectorAll('.why-card');

    function checkVisibility() {
        const gridRect = grid.getBoundingClientRect();
        cards.forEach((card, i) => {
            if (card.classList.contains('revealed')) return;
            const rect = card.getBoundingClientRect();
            if (rect.left < gridRect.right && rect.right > gridRect.left) {
                setTimeout(() => card.classList.add('revealed'), i * 80);
            }
        });
    }

    grid.addEventListener('scroll', checkVisibility, { passive: true });

    const sectionObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                checkVisibility();
                sectionObserver.disconnect();
            }
        });
    }, { threshold: 0.1 });

    sectionObserver.observe(grid);
}

// ─────────────────────────────────────────────
// 6d. TIMELINE HORIZONTAL SCROLL & REVEAL
// ─────────────────────────────────────────────
function initTimelineScroll() {
    const grid = document.querySelector('.rm-timeline');
    if (!grid) return;

    grid.addEventListener('wheel', (e) => {
        if (e.deltaY !== 0) {
            e.preventDefault();
            grid.scrollBy({ left: e.deltaY * 1.5, behavior: 'smooth' });
        }
    }, { passive: false });

    const cards = grid.querySelectorAll('.rm-col');

    function checkVisibility() {
        const gridRect = grid.getBoundingClientRect();
        cards.forEach((card, i) => {
            if (card.classList.contains('revealed')) return;
            const rect = card.getBoundingClientRect();
            if (rect.left < gridRect.right && rect.right > gridRect.left) {
                setTimeout(() => card.classList.add('revealed'), i * 80);
            }
        });
    }

    grid.addEventListener('scroll', checkVisibility, { passive: true });

    const sectionObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                grid.classList.add('revealed');
                checkVisibility();
                sectionObserver.disconnect();
            }
        });
    }, { threshold: 0.1 });

    sectionObserver.observe(grid);
}

// ─────────────────────────────────────────────
// 7. COMMUNITY REVEAL
// ─────────────────────────────────────────────
function initCommunityReveal() {
    const cards = document.querySelectorAll('.contact-card.reveal-on-scroll');
    if (!cards.length) return;

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const delay = parseInt(entry.target.getAttribute('data-delay')) || 0;
                setTimeout(() => {
                    entry.target.classList.add('revealed');
                }, delay);
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.15 });

    cards.forEach(card => observer.observe(card));
}
