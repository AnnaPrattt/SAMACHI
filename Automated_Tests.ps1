echo "Welcome to the automated security audit. These findings will show you if you have base-level security enabled on your computer."


echo ""
echo "Antivirus:"
echo "--------------------"

$AVStatus = Get-MpComputerStatus | select AntivirusEnabled
if ($AVStatus[0].AntivirusEnabled -eq $False) {
    echo "Your Windows Antivirus is turned off."
    echo "If you have another Antivirus program on your computer, you can disregard."
    echo "If you do not have another solution, you should enable your Windows Antivirus"
}
else {
    echo "Your Antivirus is enabled. Way to be secure!"
}

$OutOfDateSignatureStatus = Get-MpComputerStatus | select DefenderSignaturesOutOfDate
if ($OutOfDateSignatureStatus[0].DefenderSignaturesOutOfDate -eq $True) {
    echo "Your Antivirus knowledge base is out of date."
    echo "Update your Windows security in order to be secure"
}
else {
    echo "Your Antivirus knowledge base is up to date. Way to be secure!"
}


echo ""
echo "Firewall:"
echo "--------------------"
#Gather firewall status into one variable
#This result will later be parsed into its different firewall profiles
$result = Get-NetFirewallProfile

#$result[0] is the results only for the DOMAIN firewall
$contentForDomainFW = $result[0]
if ($contentForDomainFW.enabled -eq $true) {
    echo "Your domain firewall is enabled. Way to be secure!"
}
else {
    echo "Your domain firewall is disabled. You should turn it on to protect your computer."
}

#$result[0] is the results only for the PRIVATE firewall
$contentForPrivateFW = $result[1]
if ($contentForPrivateFW.enabled -eq $true) {
    echo "Your private firewall is enabled. Way to be secure!"
}
else {
    echo "Your private firewall is disabled. You should turn it on to protect your computer."
}

#$result[1] is the results only for the PUBLIC firewall
$contentForPublicFW = Write-Output $result[2]
if ($contentForPublicFW.enabled -eq $true) {
    echo "Your public firewall is enabled. Way to be secure!"
}
else {
    echo "Your public firewall is disabled. You should turn it on to protect your computer."
}


echo ""
echo "User Accounts:"
echo "--------------------"

$guestUserContent = Get-LocalUser -Name Guest
if ($guestUserContent.enabled -eq $false) {
    echo "Your Guest account is disabled. Way to be secure!"
}
else {
    echo "Your Guest account is enabled. You should disable it to be secure."
}

echo ""
echo "Last Quick Scan:" 
# Checks when thelast quick scan happened
$LastQuickStand = Get-MpComputerStatus | Select QuickScanEndTime
$LastQuickStand
Start-Sleep -Seconds 1

echo ""
echo "Miscellaneous Security Features:"


echo ""
echo "SecureBoot Status:"
echo "--------------------"
# Checks if SecureBoot is enabled
$SecureBoot = Confirm-SecureBootUEFI
if ($SecureBoot -eq $true) {
    Write-Host "Secure Boot is enabled. Way to be secure!"
} 
else {
    Write-Host "Secure Boot is not enabled. You should turn it on to protect your computer."
}

echo ""
echo "Tamper Protection:"
echo "--------------------"
# Check if tamper protection is enabled

$TamperProtection = Get-MpComputerStatus | Select IsTamperProtected

if ($TamperProtection[0].IsTamperProtected -eq $False) {
    Write-Host "Tamper protection is not enabled."
} 
else {
    Write-Host "Tamper protection is enabled."
}

echo ""
echo "Real Time Protection Status:"
echo "--------------------"
# Check if tamper protection is enabled

$RealTimeProtection = Get-MpComputerStatus | Select RealTimeProtectionEnabled

if ($RealTimeProtection[0].RealTimeProtectionEnabled -eq $False) {
    Write-Host "Real Time Protection is not enabled."
} 
else {
    Write-Host "Real Time Protection is enabled."
}



echo ""
echo "SMBv1 status:"
echo "--------------------"
$SMBv1Enabled = Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol

if ($SMBv1Enabled.state -eq $false) {
    echo "SMBv1 is disabled. Way to be secure!"
}
else {
    echo "SMBv1 is enabled on this computer, but this protocol version is deprecated. You should disable it to be secure."
}


echo ""
echo "Google Chrome Version:"
echo "--------------------"
# Test to see if Chrome is installed
$chromeInstalled = Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe"
if ($chromeInstalled) {
    # Get the version info of the currently installed Chrome version
    $versionInfo = (Get-Item (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe")."(Default)").VersionInfo
    # Extract just the version number
    $version = $versionInfo.ProductVersion

    # Scrape the latest stable version of Google Chrome from this website: https://omahaproxy.appspot.com/all?csv=1
    $response = Invoke-WebRequest -Uri "https://omahaproxy.appspot.com/all?csv=1"
    $scrapedData = $response.content

    # Split the response data into an array 
    $respArr = $scrapedData.Split("`n")
    $stableInfo = $respArr[20]
    # Confirm that $stableInfo is indeed the correct string that contains the info about the stable version of Chrome for win64
    if ($stableInfo.SubString(0, 13 ) -ne "win64,stable,") {
        echo "Internal script logic error: `$respArr[20] does not contain the stable version info for win64 based Chromium."
        echo "Skipping Test."
    }
    # Get just the version number of the latest stable version of Chrome
    $newestStableChrome = $stableInfo.SubString(13, 14)

    # Check the installed Chrome version number versus the latest stable version of Chrome
    if ($version -eq $newestStableChrome) {
        echo "You have the latest stable verion of Chrome installed. Way to keep it up to date!"
    }
    elseif ($version.SubString(0, 3) -eq $newestStableChrome.SubString(0, 3)) {
        echo "You are at least one minor version behind on Chrome. Consider updating Chrome."
    }
    else {
        echo "Your version of Google Chrome is very outdated! Please upgrade it ASAP!"
    }
}
else {
    echo "Google Chrome is not installed. Skipping Test."
}


echo ""
echo "Windows Updates:"
echo "--------------------"
#Command sourced from https://www.action1.com/check-missing-windows-updates-script/
#Show Windows updates that still need to be installed
(New-Object -ComObject Microsoft.Update.Session).CreateupdateSearcher().Search('IsHidden=0 and IsInstalled=0').Updates | Select-Object Title

# Sleep for 5 seconds. This presents the output of the Windows Updates
# section from being cut off by the following commands
Start-Sleep -Seconds 3

echo ""
echo "Testing complete."
Read-Host -Prompt "Press Enter to exit"

