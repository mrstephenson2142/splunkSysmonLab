#Requires -RunAsAdministrator

.\install_sysmon.ps1 1
.\install_splunk_uf.ps1
.\install_atomicredteam.ps1
Write-Host "All tools installed." -ForegroundColor Green -BackgroundColor Black