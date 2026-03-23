$file = 'index.html'
$lines = Get-Content $file -Encoding UTF8
$total = $lines.Count
Write-Host "Total lines: $total"

# Keep lines 1-19 (index 0-18) and lines 102+ (index 101 to end)
$before = $lines[0..18]
$after = $lines[101..($total - 1)]

$newPreloader = @(
    '  <!-- Preloader -->',
    '  <div id="loader" aria-hidden="true">',
    '    <canvas id="particleCanvas"></canvas>',
    '    <div class="fx-pair fp1">EUR/USD</div>',
    '    <div class="fx-pair fp2">GBP/JPY</div>',
    '    <div class="fx-pair fp3">USD/CHF</div>',
    '    <div class="fx-pair fp4">XAU/USD</div>',
    '    <div class="fx-pair fp5">NAS100</div>',
    '    <div class="fx-pair fp6">AUD/CAD</div>',
    '    <div class="loader-center">',
    '      <div class="candle-stage" id="candleStage">',
    '        <div class="candle-group">',
    '          <div class="candle c1"><div class="wick top"></div><div class="body bear"></div><div class="wick bot"></div></div>',
    '          <div class="candle c2"><div class="wick top"></div><div class="body bull"></div><div class="wick bot"></div></div>',
    '          <div class="candle c3"><div class="wick top"></div><div class="body bear"></div><div class="wick bot"></div></div>',
    '          <div class="candle c4"><div class="wick top"></div><div class="body bull big"></div><div class="wick bot"></div></div>',
    '          <div class="candle c5"><div class="wick top"></div><div class="body bull"></div><div class="wick bot"></div></div>',
    '          <div class="candle c6"><div class="wick top"></div><div class="body bear"></div><div class="wick bot"></div></div>',
    '          <div class="candle c7"><div class="wick top"></div><div class="body bull big"></div><div class="wick bot"></div></div>',
    '          <div class="candle c8"><div class="wick top"></div><div class="body bull"></div><div class="wick bot"></div></div>',
    '        </div>',
    '        <div class="candle-baseline"></div>',
    '      </div>',
    '      <div class="logo-stage" id="logoStage">',
    '        <div class="logo-ring-wrap">',
    '          <div class="logo-ring r1"></div>',
    '          <div class="logo-ring r2"></div>',
    '          <div class="logo-ring r3"></div>',
    '        </div>',
    '        <div class="logo-flame">',
    '          <svg width="56" height="70" viewBox="0 0 64 80" fill="none" xmlns="http://www.w3.org/2000/svg">',
    '            <rect x="18" y="36" width="28" height="36" rx="4" fill="url(#lCandleGrad)"/>',
    '            <rect x="30" y="10" width="4" height="26" rx="2" fill="#94a3b8"/>',
    '            <path d="M32 8 C28 4 22 8 24 16 C26 22 32 24 32 24 C32 24 38 22 40 16 C42 8 36 4 32 8Z" fill="url(#lFlameGrad)">',
    '              <animateTransform attributeName="transform" type="scale" values="1,1;1.05,1.08;1,1" dur="0.8s" repeatCount="indefinite" additive="sum"/>',
    '            </path>',
    '            <path d="M32 14 C30 11 27 13 28 17 C29 20 32 21 32 21 C32 21 35 20 36 17 C37 13 34 11 32 14Z" fill="url(#lInnerFlameGrad)">',
    '              <animateTransform attributeName="transform" type="scale" values="1,1;1.08,1.12;1,1" dur="0.6s" repeatCount="indefinite" additive="sum"/>',
    '            </path>',
    '            <defs>',
    '              <linearGradient id="lCandleGrad" x1="18" y1="36" x2="46" y2="72" gradientUnits="userSpaceOnUse">',
    '                <stop offset="0%" stop-color="#1e3a8a"/><stop offset="100%" stop-color="#1d4ed8"/>',
    '              </linearGradient>',
    '              <radialGradient id="lFlameGrad" cx="50%" cy="70%" r="50%">',
    '                <stop offset="0%" stop-color="#fbbf24"/><stop offset="50%" stop-color="#f97316"/>',
    '                <stop offset="100%" stop-color="#3b82f6" stop-opacity="0"/>',
    '              </radialGradient>',
    '              <radialGradient id="lInnerFlameGrad" cx="50%" cy="70%" r="50%">',
    '                <stop offset="0%" stop-color="#ffffff"/><stop offset="100%" stop-color="#fbbf24" stop-opacity="0.8"/>',
    '              </radialGradient>',
    '            </defs>',
    '          </svg>',
    '        </div>',
    '        <div class="logo-text-block">',
    '          <div class="loader-brand"><span class="logo-blue" id="typedBlue"></span><span class="logo-candle" id="typedCandle"></span><span class="type-cursor" id="typeCursor">|</span></div>',
    '          <div class="logo-tagline" id="loaderTagline">Forex Education &amp; Mentorship</div>',
    '        </div>',
    '      </div>',
    '      <div class="loader-bar-wrap" id="loaderBarWrap">',
    '        <div class="loader-bar" id="loaderBar"><div class="bar-shimmer"></div></div>',
    '      </div>',
    '      <div class="loader-status-row">',
    '        <div class="loader-pct" id="loaderPct">0%</div>',
    '        <div class="loader-status-msg" id="loaderStatusMsg">Initialising markets...</div>',
    '      </div>',
    '    </div>',
    '    <div class="grid-overlay"></div>',
    '  </div>'
)

$combined = $before + $newPreloader + $after
[System.IO.File]::WriteAllLines((Join-Path (Get-Location) $file), $combined, [System.Text.UTF8Encoding]::new($false))
Write-Host "SUCCESS: $($combined.Count) lines written"
