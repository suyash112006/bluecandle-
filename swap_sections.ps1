$lines = Get-Content 'index.html' -Encoding UTF8

$before = $lines[0..225]
$sphere = $lines[226..265]
$dashboard = $lines[267..400]
$after = $lines[401..($lines.Count - 1)]

# Put dashboard (267-400) entirely above sphere (226-265)
$newContent = $before + "" + $dashboard + "" + $sphere + $after
[System.IO.File]::WriteAllLines("index.html", $newContent, [System.Text.Encoding]::UTF8)
