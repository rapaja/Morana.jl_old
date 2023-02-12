$files = get-childitem -path . -file -recurse -include *.cov
$files | Remove-Item -whatif