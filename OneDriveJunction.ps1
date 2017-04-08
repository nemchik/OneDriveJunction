$junctionFolders = @(
  "Contacts",
  "Desktop",
  "Documents",
  "Downloads",
  "Favorites", #broken
  "Links",
  "Music",
  "Pictures",
  "Saved Games",
  "Videos"
);

foreach ($folder in $junctionFolders) {
  $originalPath = "~\$folder\";
  $oneDrivePath = "~\OneDrive\$folder\";
  if ((Get-Item $originalPath).Attributes.ToString().Contains("ReparsePoint") -ne $True) {
    New-Item $oneDrivePath -Type Directory -Force;
    Move-Item -Path "$($originalPath)*" -Destination $oneDrivePath -Force;
    Remove-Item $originalPath -Recurse -Force;
    New-Item -ItemType Junction -Path $originalPath -Value $oneDrivePath -Force;
  }
}
