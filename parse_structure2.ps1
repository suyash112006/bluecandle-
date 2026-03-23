$lines = Get-Content 'index.html' -Encoding UTF8
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '<!-- ── (.*?) ── -->') {
        Write-Host "$i | $($matches[1])"
    }
}
