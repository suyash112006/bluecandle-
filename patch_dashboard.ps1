$file = 'index.html'
$lines = Get-Content $file -Encoding UTF8
$total = $lines.Count

# Find the line index of <!-- ── ABOUT ── --> (0-indexed)
$aboutIdx = -1
for ($i = 0; $i -lt $total; $i++) {
    if ($lines[$i] -like '*<!-- -- ABOUT --*' -or $lines[$i] -like '*<!-- ── ABOUT ──*' -or $lines[$i] -match '<!--\s*──\s*ABOUT') {
        $aboutIdx = $i
        break
    }
}

if ($aboutIdx -lt 0) {
    # Fallback: search for 'about-section'
    for ($i = 0; $i -lt $total; $i++) {
        if ($lines[$i] -match 'about-section') {
            $aboutIdx = $i - 1
            break
        }
    }
}

Write-Host "ABOUT section found at line index: $aboutIdx (1-indexed: $($aboutIdx+1))"

$before = $lines[0..($aboutIdx - 1)]
$after = $lines[$aboutIdx..($total - 1)]

$dashSection = @(
    '',
    '    <!-- ── LIVE DASHBOARD PREVIEW ── -->',
    '    <section class="dash-preview-section" id="dashboard">',
    '',
    '      <!-- Ticker Strip -->',
    '      <div class="ticker-wrap">',
    '        <div class="ticker-label">LIVE MARKETS</div>',
    '        <div class="ticker-inner" id="tickerInner"></div>',
    '      </div>',
    '',
    '      <div class="container">',
    '        <div class="section-header">',
    '          <div class="section-label">Market Dashboard</div>',
    '          <h2>Live Market Overview</h2>',
    '          <p>Real-time simulation of the trading environment our students learn to navigate.</p>',
    '        </div>',
    '',
    '        <!-- Stat Cards Row -->',
    '        <div class="dash-stat-row">',
    '          <div class="dash-stat-card">',
    '            <div class="dsc-label">EUR/USD</div>',
    '            <div class="dsc-value" id="dscEur">1.0842</div>',
    '            <div class="dsc-change positive" id="dscEurChg">▲ +0.18%</div>',
    '          </div>',
    '          <div class="dash-stat-card">',
    '            <div class="dsc-label">GBP/USD</div>',
    '            <div class="dsc-value" id="dscGbp">1.2634</div>',
    '            <div class="dsc-change positive" id="dscGbpChg">▲ +0.22%</div>',
    '          </div>',
    '          <div class="dash-stat-card featured">',
    '            <div class="dsc-label">XAU/USD</div>',
    '            <div class="dsc-value" id="dscGold">2318.40</div>',
    '            <div class="dsc-change positive" id="dscGoldChg">▲ +1.04%</div>',
    '          </div>',
    '          <div class="dash-stat-card">',
    '            <div class="dsc-label">USD/JPY</div>',
    '            <div class="dsc-value" id="dscJpy">154.72</div>',
    '            <div class="dsc-change negative" id="dscJpyChg">▼ -0.31%</div>',
    '          </div>',
    '          <div class="dash-stat-card">',
    '            <div class="dsc-label">NAS100</div>',
    '            <div class="dsc-value" id="dscNas">17842</div>',
    '            <div class="dsc-change positive" id="dscNasChg">▲ +0.67%</div>',
    '          </div>',
    '        </div>',
    '',
    '        <!-- Main chart + side panels -->',
    '        <div class="dash-main-grid">',
    '',
    '          <!-- Candlestick chart panel -->',
    '          <div class="dash-chart-panel">',
    '            <div class="dcp-header">',
    '              <div class="dcp-pair">EUR/USD <span class="dcp-tf">H1</span></div>',
    '              <div class="dcp-tabs">',
    '                <button class="dca-tab active" data-tf="M15">M15</button>',
    '                <button class="dca-tab" data-tf="H1">H1</button>',
    '                <button class="dca-tab" data-tf="H4">H4</button>',
    '                <button class="dca-tab" data-tf="D1">D1</button>',
    '              </div>',
    '              <div class="dcp-price-live">',
    '                <span id="dashLivePrice">1.0842</span>',
    '                <span class="dcp-pip positive" id="dashLivePip">+12 pips</span>',
    '              </div>',
    '            </div>',
    '            <div class="dcp-chart-wrap">',
    '              <canvas id="dashChartCanvas"></canvas>',
    '              <!-- Overlay: signal annotation -->',
    '              <div class="chart-signal-badge" id="chartSignalBadge">',
    '                <span class="csb-dot"></span> Buy Signal Detected',
    '              </div>',
    '            </div>',
    '          </div>',
    '',
    '          <!-- Right side panels -->',
    '          <div class="dash-side-panels">',
    '',
    '            <!-- Orderbook / recent trades -->',
    '            <div class="dash-panel">',
    '              <div class="dp-title">Order Flow</div>',
    '              <div class="orderbook" id="orderBook">',
    '                <div class="ob-header">',
    '                  <span>Price</span>',
    '                  <span>Size</span>',
    '                  <span>Side</span>',
    '                </div>',
    '              </div>',
    '            </div>',
    '',
    '            <!-- Signal card -->',
    '            <div class="dash-panel signal-panel">',
    '              <div class="dp-title">AI Signal Monitor</div>',
    '              <div class="sig-pair">EUR/USD <span class="sig-badge bull">BUY</span></div>',
    '              <div class="sig-row"><span>Entry</span><span class="sig-val">1.0840</span></div>',
    '              <div class="sig-row"><span>Target</span><span class="sig-val positive">1.0920</span></div>',
    '              <div class="sig-row"><span>Stop</span><span class="sig-val negative">1.0790</span></div>',
    '              <div class="sig-row"><span>R:R</span><span class="sig-val">1 : 1.6</span></div>',
    '              <div class="sig-conf">',
    '                <div class="sig-conf-label">Confidence</div>',
    '                <div class="sig-conf-bar"><div class="sig-conf-fill" style="width:82%"></div></div>',
    '                <div class="sig-conf-pct">82%</div>',
    '              </div>',
    '            </div>',
    '',
    '          </div>',
    '        </div>',
    '',
    '        <!-- Markets table -->',
    '        <div class="dash-table-wrap">',
    '          <div class="dt-header">',
    '            <div class="dt-title">Forex Pairs &amp; Signals</div>',
    '            <div class="dt-tabs">',
    '              <button class="dca-tab active">Majors</button>',
    '              <button class="dca-tab">Minors</button>',
    '              <button class="dca-tab">Metals</button>',
    '            </div>',
    '          </div>',
    '          <table class="markets-table">',
    '            <thead>',
    '              <tr>',
    '                <th>#</th><th>Pair</th><th>Price</th><th>Change</th><th>Spread</th><th>Signal</th>',
    '              </tr>',
    '            </thead>',
    '            <tbody id="marketsBody"></tbody>',
    '          </table>',
    '        </div>',
    '',
    '      </div>',
    '    </section>',
    ''
)

$combined = $before + $dashSection + $after
[System.IO.File]::WriteAllLines((Join-Path (Get-Location) $file), $combined, [System.Text.UTF8Encoding]::new($false))
Write-Host "SUCCESS: $($combined.Count) lines written"
