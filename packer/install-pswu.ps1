$resourcesDir = "$ENV:UNATTEND_DIR"

# Install PSWindowsUpdate
if (!(Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    if ($PSVersionTable.PSVersion.Major -ge 5) {
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
        Install-Module PSWindowsUpdate -Force
    }
    else {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory("$resourcesDir\PSWindowsUpdate.zip", "C:\Windows\System32\WindowsPowerShell\v1.0\Modules")
    }
}

$STArgument = "-ExecutionPolicy Bypass $resourcesDir\windows-update.ps1"
#Create a new trigger that is configured to trigger at startup
$STTrigger = New-ScheduledTaskTrigger -AtStartup
#Name for the scheduled task
$STTaskName = "PSWindowsUpdate"
#Action to run as
$STAction = New-ScheduledTaskAction -Execute "powershell" -Argument $STArgument
#Configure when to stop the task and how long it can run for. In this example it does not stop on idle and uses the maximum possible duration by setting a timelimit of 0
$STSettings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
#Configure the principal to use for the scheduled task and the level to run as
$STPrincipal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel "Highest"
#Register the new scheduled task
Register-ScheduledTask $STTaskName -Action $STAction -Trigger $STTrigger -Principal $STPrincipal -Settings $STSettings

#Disable WinRM so the server can reboot itself several times without Packer erroring
Set-Service winrm -StartupType Disabled

Write-Host "WinRM disabled. Starting Windows update. WinRM will be enabled when completed. This process can take several hours."

