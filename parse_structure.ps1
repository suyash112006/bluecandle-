$lines = Get-Content 'index.html' -Encoding UTF8
$inDash = $false
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '<!--\s*──\s*(.*?)\s*──\s*-->') {
        Write-Host "$i : $($matches[1])"
    }
    elseif ($lines[$i] -match '<section ') {
        Write-Host "  -> $($lines[$i].Trim())"
    }
}
