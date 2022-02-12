$action=$args[0]

#Requires -RunAsAdministrator

function install-sysmon {

    # Check if sysmon installed 

     $error.Clear()
    try{
        get-service sysmon -ErrorAction SilentlyContinue | Out-Null  }
    catch{}
    if(!$error){Write-Host Sysmon is already installed. -ForegroundColor Yellow -BackgroundColor black; break;}

    # install sysmon 

    if(!$(test-path c:\tmp -PathType Container)){mkdir c:\tmp}

    if(!$(test-path c:\tmp\sysmon.zip -pathtype Leaf)){
    Invoke-WebRequest  https://download.sysinternals.com/files/Sysmon.zip -OutFile c:\tmp\sysmon.zip 
    }

    if(!$(test-path c:\sysmon -PathType Container)){mkdir c:\sysmon}

    if(!$(test-path C:\sysmon\Sysmon64.exe -PathType Leaf)){
    Expand-Archive -LiteralPath C:\tmp\sysmon.zip -DestinationPath c:\sysmon
    }

    if(!$(test-path  c:\sysmon\sysmonconfig-export.xml -PathType Leaf)){
    Invoke-WebRequest https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml -OutFile c:\sysmon\sysmonconfig-export.xml
    }

    # Install Sysmon 
    ## Check if Sysmon is installed 
    $error.Clear()
    try{
        get-service sysmon -ErrorAction SilentlyContinue | Out-Null  }
    catch{write-host "Sysmon not installed. Now instlaling Sysmon" -BackgroundColor Black -ForegroundColor Yellow}
    if($error){c:\sysmon\sysmon.exe -accepteula -i c:\sysmon\sysmonconfig-export.xml}

    write-host "Sysmon Installed." 
} 


function uninstall-sysmon {

    
    # Check if sysmon installed 

     $error.Clear()
    try{
        get-service sysmon -ErrorAction SilentlyContinue | Out-Null  }
    catch{}
    if($error){Write-Host Sysmon is not installed. -ForegroundColor Red -BackgroundColor Black; break;}
    
    
    C:\sysmon\Sysmon.exe -u

}

function update-sysmon{

    # Check if sysmon installed 
    $error.Clear()
    try{
        get-service sysmon -ErrorAction SilentlyContinue | Out-Null  }
    catch{}
    if($error){Write-Host Sysmon is not installed. -ForegroundColor Red -BackgroundColor Black; break;}
    
    
    $y = "c:\sysmon\sysmonconfig-export.xml"
    write-host "Full path to sysmon config file. e.g., (c:\sysmon\config.xml)."
    $x = Read-Host "Press ENTER for default path of (sysmonconfig-export.xml)"
    if(!$x){$x = $y}

    if(!$(test-path $x -PathType Leaf)){write-host "File not found." -ForegroundColor Red -BackgroundColor Black; break;}

    
    C:\sysmon\Sysmon.exe -c $x
    

}


if($action -eq 1){

install-sysmon; 

}else{

    Write-Host "Press 1 to install Sysmon."
    Write-Host "Press 2 to uninstall Sysmon."
    Write-Host "Press 3 to update Sysmon."
    $i = Read-Host 

    switch($i){
        "1" {install-sysmon; break;}
        "2" {uninstall-sysmon; break;}
        "3" {update-sysmon; break;}
        default {write-host "Invalid choice."; break; }

    }

}