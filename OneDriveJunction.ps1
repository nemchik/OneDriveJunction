$junctionFolders = @(
  "Desktop",
  "Documents",
  "Downloads",
  "Music",
  "Pictures",
  "Videos"
);

foreach ($folder in $junctionFolders) {
  $originalPath = "~\$folder\";
  $oneDrivePath = "~\OneDrive\$folder\";
  if (((Test-Path $originalPath) -ne $True) -or ((Get-Item $originalPath).Attributes.ToString().Contains("ReparsePoint") -ne $True)) {
    New-Item $oneDrivePath -Type Directory -Force -ErrorAction SilentlyContinue;
    Move-Item -Path "$($originalPath)*" -Destination $oneDrivePath -Force -ErrorAction SilentlyContinue;
    # This next line is dangerous and was not well thought out.
    #Remove-Item $originalPath -Recurse -Force -ErrorAction SilentlyContinue;
    New-Item -ItemType Junction -Path $originalPath -Value $oneDrivePath -Force -ErrorAction SilentlyContinue;
  }
}
