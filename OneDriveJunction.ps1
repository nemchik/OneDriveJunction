$junctionFolders = @(
  "Desktop",
  "Documents",
  "Downloads",
  "Music",
  "Pictures",
  "Videos"
);

foreach ($folder in $junctionFolders) {
  $originalPath = (Get-Item "$env:USERPROFILE\$folder").FullName;
  $oneDrivePath = (Get-Item "$env:OneDrive\$folder").FullName;
  if (((Test-Path $originalPath) -ne $True) -or ((Get-Item $originalPath).Attributes.ToString().Contains("ReparsePoint") -ne $True)) {
    New-Item $oneDrivePath -Type Directory -Force -ErrorAction SilentlyContinue;
    Move-Item -Path "$($originalPath)\*" -Destination $oneDrivePath -Force -ErrorAction SilentlyContinue;
    ## Potentially find a way to check if the folder is in use before removing it.
    # Get-Process | Where-Object { $_.Modules.FileName -icontains $originalPath } | Stop-Process;
    ## Remove the original folder.
    # Remove-Item $originalPath -Recurse -Force -ErrorAction SilentlyContinue;
    New-Item -ItemType Junction -Path $originalPath -Value $oneDrivePath -Force -ErrorAction SilentlyContinue;
  }
}
