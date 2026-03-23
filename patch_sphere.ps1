$file = 'index.html'
$lines = Get-Content $file -Encoding UTF8
$total = $lines.Count

# Find the line index of <!-- ── LIVE DASHBOARD PREVIEW ── -->
$dashIdx = -1
for ($i = 0; $i -lt $total; $i++) {
    if ($lines[$i] -match '<!-- ── LIVE DASHBOARD PREVIEW ── -->') {
        $dashIdx = $i
        break
    }
}

if ($dashIdx -lt 0) {
    Write-Host "Error: Dashboard section not found"
    exit 1
}

Write-Host "DASHBOARD section found at index: $dashIdx"

$before = $lines[0..($dashIdx - 1)]
$after = $lines[$dashIdx..($total - 1)]

$sphereSection = @(
    '',
    '    <!-- ── 3D TRADING PAIRS SPHERE ── -->',
    '    <section class="sphere-section" id="market-sphere">',
    '      <div class="container">',
    '        <div class="sphere-header">',
    '          <div class="section-label">Global Markets</div>',
    '          <h2>Trading Universe</h2>',
    '          <p>Explore top cryptos, metals, and standard pairs. Click any asset to open live technical analysis.</p>',
    '        </div>',
    '        <div class="sphere-wrapper">',
    '          <div id="sphereContainer" class="sphere-container"></div>',
    '        </div>',
    '      </div>',
    '    </section>',
    '',
    '    <!-- ── TRADING CHART MODAL ── -->',
    '    <div class="chart-modal-backdrop" id="chartModal">',
    '      <div class="chart-modal-dialog">',
    '        <button class="modal-close" id="closeModalBtn">&times;</button>',
    '        <div class="modal-header">',
    '          <div class="modal-pair-info">',
    '            <h3 id="modalPairName">EUR/USD</h3>',
    '            <span class="modal-pair-desc" id="modalPairDesc">Euro to US Dollar</span>',
    '          </div>',
    '          <div class="modal-price-badges">',
    '            <span class="modal-buy">BUY</span>',
    '            <span class="modal-sell">SELL</span>',
    '          </div>',
    '        </div>',
    '        <div class="modal-stats text-sm text-zinc-500 mb-4">',
    '          Live Market Data - Last update: <span class="flash-text">Just now</span>',
    '        </div>',
    '        <div class="modal-chart-area">',
    '          <div class="mc-overlay">',
    '             <div class="mc-signal">Optimized Entry Window</div>',
    '          </div>',
    '          <!-- Canvas for drawing candlestick chart preview -->',
    '          <canvas id="modalChartCanvas"></canvas>',
    '        </div>',
    '      </div>',
    '    </div>',
    ''
)

$combined = $before + $sphereSection + $after
[System.IO.File]::WriteAllLines((Join-Path (Get-Location) $file), $combined, [System.Text.UTF8Encoding]::new($false))
Write-Host "SUCCESS: $($combined.Count) lines written"
