$dnsServer=$args[0]

#Requires -RunAsAdministrator

if(!$dnsServer){
    $dnsServer = read-host "Enter DNS server IP"
}



# Client Setup 

# Options 

# Change this address to match the DC ip address
#$dnsServer = "192.168.202.136"

# TODO **Check for admin shell**

#Change DNS Server 
$index = Get-NetAdapter | Where-Object {$_.Status -eq "up"} | Select-Object ifIndex
set-DnsClientServerAddress -InterfaceIndex $index.ifIndex -ServerAddresses ($dnsServer,"8.8.8.8")
# Add DC to hosts 
#"WinDC1.testlab.local $dnsServer"  | Out-File C:\Windows\System32\drivers\etc\hosts -Append -NoClobber -Encoding utf8
ipconfig /flushdns
write-host "Please wait..."
#start-sleep -s 10

# Join Computer to domain 
# Rename and Join AD
# Create Cred for Domain Join
$joinCred = New-Object pscredential -ArgumentList ([pscustomobject]@{UserName = "testlab\Administrator"; Password = (ConvertTo-SecureString -String 'P@ssword' -AsPlainText -Force)[0]; })
$myhost = hostname
#Add-Computer -DomainName testlab.local -ComputerName $myhost -NewName WinClient1 -Force -Credential $joinCred -server WinDC1.testlab.local



$a = 1
do{
    
    Write-Host "Domain join attempt $a of 5" -BackgroundColor Black -ForegroundColor Yellow
    Start-sleep -s 15
    
    $error.Clear()
    try{
        Add-Computer -DomainName testlab.local -ComputerName $myhost -NewName WinClient1 -Force -Credential $joinCred -server WinDC1.testlab.local }
    catch{Write-Host "could not join domain." -BackgroundColor black -ForegroundColor Red}
    if (!$error){write-host "Domain joined, continue script."; break}
    $a++
}while($a -le 5 )




                         
# Add Domain Admin to administrators list 

$restartIt = Read-Host "Press 1 to add user and restart. Press 2 to quit."

switch ($restartIt){

    "1" { Add-LocalGroupMember -Group "Administrators" -Member "testlab\lab_admin";   read-host "Press ENTER to contiue...";   restart-computer; break }
    "2" {break}
    default  {break}
    }

