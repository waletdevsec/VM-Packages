$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'apktool'
  $category = 'Java & Android'
  $rawToolPath = Join-Path ${Env:RAW_TOOLS_DIR} "$toolName"

  # Download apktool.bat
  $wrapperPath = Join-Path $rawToolPath "$toolName.bat"
  $wrapperSource = 'https://raw.githubusercontent.com/iBotPeaches/Apktool/0741664808724bda41744ad3981bac2eec672d1b/scripts/windows/apktool.bat'
  $wrapperChecksum = "3e1c29f9d2c7b3a7c938573f4c2ae61172f6221dc9febfa85080f354357d6336"
  Get-ChocolateyWebFile -PackageName '$toolName wrapper script' -FileFullPath $wrapperPath -Url $wrapperSource -Checksum $wrapperChecksum -ChecksumType "sha256"

  # Download apktool.jar
  $toolPath = Join-Path $rawToolPath "$toolName.jar"
  $toolSource = 'https://github.com/iBotPeaches/Apktool/releases/download/v2.9.1/apktool_2.9.1.jar'
  $toolChecksum = "de7ce8aa109acb649e7f69cfe91030ffc20dbcc46edd8abbf6c2d1e36cfccd7b"
  Get-ChocolateyWebFile -PackageName $toolName -FileFullPath $toolPath -Url $toolSource -Checksum $toolChecksum -ChecksumType "sha256"

  # Add apktool to Path
  VM-Add-To-Path $rawToolPath

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"

  $executableCmd  = Join-Path ${Env:WinDir} "system32\cmd.exe"
  $executableDir  = Join-Path ${Env:UserProfile} "Desktop"
  $executableArgs = "/K `"$toolName`""

  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executableCmd -Arguments $executableArgs -WorkingDirectory $executableDir
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}
