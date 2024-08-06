﻿param($ROOT = "C:\Users\$Env:UserName\Desktop")

$LOGS = "$ROOT\PS-LOGS"

Start-Transcript -Path "$LOGS\PS-SOFTWARE-OUT.txt"

. {
    $WAZUH_URL = "https://packages.wazuh.com/4.x/windows/wazuh-agent-4.8.0-1.msi"
    $KF_URL = "https://www.kfsensor.net/kfsensor/download/kfsens40.msi"
    $REG_MAN_URL = "https://www.resplendence.com/download/RegistrarHomeV9.exe"
    $AUTORUNS_URL = "https://download.sysinternals.com/files/Autoruns.zip"
    $2016_BASELINE_URL = "https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/Windows%2010%20Version%201607%20and%20Windows%20Server%202016%20Security%20Baseline.zip"
    $LGPO_URL = "https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip"
    $POLICYANALYZER_URL = "https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/PolicyAnalyzer.zip"

    echo "`n******************** DOWNLOADING AND INSTALLING WAZUH AGENT ********************`n"

    wget $WAZUH_URL -OutFile "$ROOT\wazuh-agent.msi"
    $IP = Read-Host "Enter the wazuh manager IP"
    & $ROOT\wazuh-agent.msi /q WAZUH_MANAGER=$IP
    Start-Sleep -Seconds 4
    NET START Wazuh

    echo "`n******************** DOWNLOADING KF SENSOR HONEYPOT ********************`n"

    wget $KF_URL -OutFile "$ROOT\kfsense.msi"

    echo "`n******************** DOWNLOADING AUTORUNS ********************`n"

    wget $AUTORUNS_URL -OutFile $ROOT\autoruns.zip
    Expand-Archive -Path $ROOT\autoruns.zip -DestinationPath $ROOT\autoruns

    echo "`n******************** DOWNLOADING REGISTRY MANAGER ********************`n"

    wget $REG_MAN_URL -OutFile "$ROOT\regman-installer.exe"

    echo "`n******************** DOWNLOADING AND INSTALLING SECURITY BASELINES AND TOOLS ********************`n"

    wget $2016_BASELINE_URL -OutFile "$ROOT\2016-baseline-toolkit.zip"
    Expand-Archive -Path $ROOT\2016-baseline-toolkit.zip -DestinationPath $ROOT\2016-baseline-toolkit

    wget $LGPO_URL -OutFile "$ROOT\LGPO.zip"
    Expand-Archive -Path $ROOT\LGPO.zip -DestinationPath $ROOT\LGPO

    Copy-Item -Path $ROOT\LGPO\LGPO_30\LGPO.exe -Destination $ROOT\2016-baseline-toolkit\Windows-10-RS1-and-Server-2016-Security-Baseline\Local_Script\Tools\

    Start-Process powershell $ROOT\2016-baseline-toolkit\Windows-10-RS1-and-Server-2016-Security-Baseline\Local_Script\Member_Server_Install.cmd

} | Out-Default

Stop-Transcript