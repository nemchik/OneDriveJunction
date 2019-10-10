$userShellFolders = @(
  @{
    Folder   = "Desktop"
    Registry = "Desktop"
  },
  @{
    Folder   = "Documents"
    Registry = "Personal"
  },
  @{
    Folder   = "Downloads"
    Registry = "{374DE290-123F-4565-9164-39C4925E467B}"
  },
  @{
    Folder   = "Favorites"
    Registry = "Favorites"
  },
  @{
    Folder   = "Music"
    Registry = "My Music"
  },
  @{
    Folder   = "Pictures"
    Registry = "My Pictures"
  },
  @{
    Folder   = "Videos"
    Registry = "My Video"
  }
)

foreach ($folder in $userShellFolders) {
  $originalPath = "~\$($folder.Folder)\"

  if ((Test-Path $originalPath -ErrorAction SilentlyContinue) -and !((Get-Item -Path $originalPath -Force -ErrorAction SilentlyContinue).LinkType)) {
    $oneDrivePath = "~\OneDrive - KeeFORCE\$($folder.Folder)\"
    New-Item -ItemType Directory -Path $oneDrivePath -Force -ErrorAction SilentlyContinue | Out-Null

    $oneDrivePathResolved = (Resolve-Path $oneDrivePath -ErrorAction SilentlyContinue).Path

    Move-Item -Path "$($originalPath)\*" -Destination $oneDrivePathResolved -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item $originalPath -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    New-Item -ItemType Junction -Path $originalPath -Value $oneDrivePathResolved -Force -ErrorAction SilentlyContinue | Out-Null

    $registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
    if (!(Test-Path $registryPath)) {
      New-Item -Path $registryPath -Force -ErrorAction SilentlyContinue | Out-Null
    }
    New-ItemProperty -Path $registryPath -Name $folder.Registry -Value $oneDrivePathResolved -PropertyType REG_EXPAND_SZ -Force -ErrorAction SilentlyContinue | Out-Null

  }

}
