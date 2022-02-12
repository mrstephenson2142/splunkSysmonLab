$splServer=$args[0]

#Requires -RunAsAdministrator

if(!$splServer){
    $splServer = read-host "Enter Splunk server IP"
}





#Test using 192.168.202.135

# Download Universal Forwarder 

if(!$(test-path c:\tmp -PathType Container)){mkdir c:\tmp}

if(!$(test-path "c:\tmp\splunkforwarder-8.2.3x64.msi" -pathtype Leaf)){
Invoke-WebRequest https://download.splunk.com/products/universalforwarder/releases/8.2.3/windows/splunkforwarder-8.2.3-cd0848707637-x64-release.msi -OutFile "c:\tmp\splunkforwarder-8.2.3x64.msi"
}


# Install Universal Forwarder 
Write-Host "Installing Splunk UF you may see flashing on your screen. Please wait."
msiexec.exe /i c:\tmp\splunkforwarder-8.2.3x64.msi SPLUNKUSERNAME=admin SPLUNKPASSWORD="P@ssword"		 RECEIVING_INDEXER=$splServer":9997" DEPLOYMENT_SERVER=$splServer":8089" LAUNCHSPLUNK=1  SERVICESTARTTYPE=auto AGREETOLICENSE=Yes /quiet 


# Check for Service Installaiton Status 

$i = 0 # 5 minute timeout 
do{
$error.Clear()
    try{
       get-service SplunkForwarder -ErrorAction SilentlyContinue | Out-Null }
    catch{}
    
    
    
    #if($error){Write-Host Sysmon is already installed. -ForegroundColor Yellow -BackgroundColor black; break;} 
    Start-Sleep -Seconds 5
    $i++
    
    

    }while(($error -or  $(get-service SplunkForwarder).Status -ne "Running") -xor $i -eq 60)
    
    
    
    if($i -eq "60"){
    Write-Host Something went wrong during forwarder installation. -ForegroundColor Red -BackgroundColor Black
    }else{write-host "Splunk Universal Forwarder Installed. It can take several minutes for logs to begin appearing in Splunk." -ForegroundColor Green}

