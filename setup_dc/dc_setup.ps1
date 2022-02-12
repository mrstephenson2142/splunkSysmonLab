#Requires -RunAsAdministrator


############################
## Installation Functions ##
############################
# Script 1 
function script1 {

    # Skip Hostname Setting if it's been set
    $x = hostname 
    if($x -ne "WinDC1"){
        Rename-Computer -NewName "WinDC1" 
        read-host “Press ENTER to contiue..."
        Restart-Computer
        }
}
# Script 2 
function script2 {  
    # Install AD Roles and Tools 
    Add-WindowsFeature AD-Domain-Services,RSAT-ADDS
    # Create credential for use in forest creation 
    $Secure_String_Pwd = ConvertTo-SecureString "P@ssword" -AsPlainText -Force
    # Create Forest and Restart 
    Install-ADDSForest  -DomainName testlab.local -InstallDNS -SafeModeAdministratorPassword $Secure_String_Pwd -force  -NoRebootOnCompletion
    read-host “Press ENTER to contiue..."
    Restart-Computer
}
# Script 3 

function script3 {  
    # Add a domain user for use with the client machine
    $Secure_String_Pwd = ConvertTo-SecureString "P@ssword" -AsPlainText -Force
    New-ADUser -Name "lab_admin" -Accountpassword $Secure_String_Pwd -Enabled $true -ChangePasswordAtLogon 0 -PasswordNeverExpires 1 

    # Disaply IP so that the user knows what to use in the client script
    $ip =  Get-NetIPAddress -AddressFamily ipv4  | Where-Object {$_.InterfaceAlias -like "Ethernet*"} | Select-Object IPAddress
    Write-Host Make note of this IP Address, you will needed when configuring client machines. 
    Write-host "DC IP Addresss: $($ip.IPAddress)"
}


##################
## Start Script ##
##################



if(test-path -path .\state1.txt -pathtype Leaf){
    # Load Installtion State
    $c = Get-Content .\state1.txt
    
    switch ($c) {
        "2" {  script2; "3" | Out-File .\state1.txt  ; break }
        "3" {  script3; "finished" | Out-File .\state1.txt ; Write-Host "DC setup complete!" -ForegroundColor Green -BackgroundColor Black ; break }
        "finished" {  write-host "Script has already run to completion." ; break }
        default { "Uh, something unexpected happened" }
      } 
    }
    else {
        # Run Script Part 1
        write-host "Starting initial install" 
        script1; "2" | Out-File .\state1.txt  
    }
    
    