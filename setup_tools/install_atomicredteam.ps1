#Requires -RunAsAdministrator

Write-Host "Answer Yes to all prompts." -ForegroundColor Yellow -BackgroundColor Black

# Make AtomicRedTeam Dir

if(!$(test-path c:\AtomicRedTeam -PathType Container)){mkdir c:\AtomicRedTeam}

# Add Atomic RedTeamDir to Exceptions 

Add-MpPreference -ExclusionPath "C:\AtomicRedTeam"

Install-Module -Name invoke-atomicredteam,powershell-yaml 
IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing);
Install-AtomicRedTeam -getAtomics -Force -InstallPath "c:\AtomicRedTeam" 

# Install Invoke AtomicRedTeam 

Import-Module "C:\AtomicRedTeam\invoke-atomicredteam\Invoke-AtomicRedTeam.psd1" -Force

# Add invoke-atomicredteam to your PowerShell Profile 

Import-Module "C:\AtomicRedTeam\invoke-atomicredteam\Invoke-AtomicRedTeam.psd1" -Force
$PSDefaultParameterValues = @{"Invoke-AtomicTest:PathToAtomicsFolder"="C:\AtomicRedTeam\atomics"}