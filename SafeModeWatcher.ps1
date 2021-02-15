$ServiceName = "WebCon WorkFlow Service"

$arrService = Get-Service -Name $ServiceName -Verbose

if ($arrService.Status -ne "Running"){

Start-Service $ServiceName

Write-Host "Starting " $ServiceName " service" 
" ---------------------- " 
" Service is now started"
}

if ($arrService.Status -eq "running"){ 
$s = 'Safe mode
Service is in safe mode. Please restart.
Message
Error has occurred, only license service works'

        $Events = Get-EventLog -LogName "WebCon WorkFlow" -Newest 100 -Message $s -ErrorAction SilentlyContinue 

       if ($Events.Message -like 'Safe Mode'){
       
            if($Events.Message -notlike 'Timeout'){ 
            
            Restart-Service "WebCon WorkFlow Service" -Verbose
            Write-Host "$ServiceName service has been restarted after Safe Mode status"
            $msg = "Safe Mode Watcher log : $ServiceName service has been restarted after Safe Mode status"
            Write-EventLog -LogName 'WebCon WorkFlow' -Source "WebCon WorkFlow" -Message $msg -EventId 0
            
            }
            else{    
            }
       }
       else {
       Write-Host "$ServiceName service is already started"

       $msg = "Safe Mode Watcher log : $ServiceName service is already started"
       Write-EventLog -LogName 'WebCon WorkFlow' -Source "WebCon WorkFlow" -Message $msg -EventId 0
       }
}
