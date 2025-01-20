$junctionFolders = @(
  "Desktop",
  "Documents",
  "Downloads",
  "Music",
  "Pictures",
  "Videos"
);

foreach ($folder in $junctionFolders) {
  if (((Test-Path "$env:USERPROFILE\$folder") -ne $True) -or ((Get-Item "$env:USERPROFILE\$folder").Attributes.ToString().Contains("ReparsePoint") -ne $True)) {
    New-Item "$env:OneDrive\$folder" -Type Directory -Force -ErrorAction SilentlyContinue;
    Move-Item -Path "$env:USERPROFILE\$folder\*" -Destination "$env:OneDrive\$folder" -Force -ErrorAction SilentlyContinue;
    ## Potentially find a way to check if the folder is in use before removing it.
    # Get-Process | Where-Object { $_.Modules.FileName -icontains "$env:USERPROFILE\$folder" } | Stop-Process;
    ## Remove the original folder.
    # Remove-Item "$env:USERPROFILE\$folder" -Recurse -Force -ErrorAction SilentlyContinue;
    New-Item -ItemType Junction -Path "$env:USERPROFILE\$folder" -Value "$env:OneDrive\$folder" -Force -ErrorAction SilentlyContinue;
  }
}
