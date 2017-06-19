$resourcesDir = "$ENV:UNATTEND_DIR"

function Clean-UpdateResources {
    # We're done, disable AutoLogon
    $items = @(("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "Unattend*"),
               ("HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "AutoLogonCount*"),
               ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs", "*"))
    foreach ($item in $items) {
        if (Test-Path $item[0]) {
            Remove-ItemProperty -Path "$item[0]" -Name "$item[1]"
        }
    }

    # Cleanup
    if (Test-Path $resourcesDir) {
        Remove-Item -Recurse -Force $resourcesDir
    }
    if (Test-Path $ENV:SystemDrive\Unattend.xml) {
        Remove-Item -Force "$ENV:SystemDrive\Unattend.xml"
    }
}

function Run-Defragment {
    Write-Host "Running Defrag..."
    #Defragmenting all drives at normal priority
    defrag.exe /C /H /V
    if ($LASTEXITCODE) { 
        throw "Defrag.exe failed"
    }
}

try {
    $programFilesDir = $ENV:ProgramFiles

    Write-Host "Cleaning up install files..."
    Unregister-ScheduledTask -TaskName PSWindowsUpdate -Confirm:$false

    Write-Host "Running SetSetupComplete..."
    & "$programFilesDir\Cloudbase Solutions\Cloudbase-Init\bin\SetSetupComplete.cmd"

    Clean-UpdateResources
    Run-Defragment

    Write-Host "Running Sysprep..."
    $unattendedXmlPath = "$programFilesDir\Cloudbase Solutions\Cloudbase-Init\conf\Unattend.xml"
    & "$ENV:SystemRoot\System32\Sysprep\Sysprep.exe" `/generalize `/oobe `/quit `/unattend:"$unattendedXmlPath"
} catch {
    $host.ui.WriteErrorLine($_.Exception.ToString())
    $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    throw
}

