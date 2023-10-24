echo "Welcome to the automated security audit. These findings will show you if you have base-level security enabled on your computer."

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
echo "Secure Boot and Smart Screen:"
echo "--------------------"
# Checks if SecureBoot is enabled
$SecureBoot = Confirm-SecureBootUEFI
if ($SecureBoot -eq $true) {
    Write-Host "Secure Boot is enabled. Way to be secure!"
} 
else {
    Write-Host "Secure Boot is not enabled. You should turn it on to protect your computer."
}

#$ Checks if Smart Screen is enabled
$SmartScreenSettings = Get-MpPreference

if ($SmartScreenSettings.SmartScreenEnabled -eq $on) {
    Write-Host "Smart Screen is enabled. Way to be secure!"
} 
else {
    Write-Host "Smart Screen is not enabled. You should turn it on for more protection."
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