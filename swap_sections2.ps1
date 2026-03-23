$lines = Get-Content 'index.html' -Encoding UTF8

$before = $lines[0..224]
$sphereAndModal = $lines[225..265]
$dashboard = $lines[266..400]
$after = $lines[401..($lines.Count - 1)]

# Put dashboard (266-400) entirely above sphere (225-265)
$newContent = $before + "" + $dashboard + "" + $sphereAndModal + $after
[System.IO.File]::WriteAllLines("index.html", $newContent, [System.Text.Encoding]::UTF8)
