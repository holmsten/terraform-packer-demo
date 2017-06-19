param([String]$resourcesDir="C:\UnattendResources")

Import-Module PSWindowsUpdate -Force

# Add Microsoft Updates (updates Windows + other Microsoft products)
Add-WUServiceManager -ServiceID 7971f918-a847-4430-9279-4a52d1efe18d -Confirm:$false

# Check if there is any update available and if so install it and reboot
$UpdatesAvailable = Get-WUList –MicrosoftUpdate -AutoSelectOnly
if ($UpdatesAvailable) {
    Get-WUInstall –MicrosoftUpdate -AutoSelectOnly -AutoReboot
    Restart-Computer
}
else {
    Add-Content $resourcesDir\done.txt "done"
    #Enable WinRM again
    Set-Service winrm -StartupType Automatic
    Start-Service winrm
}

