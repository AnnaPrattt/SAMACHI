echo "Welcome to the automated security audit. These findings will show you if you have base-level security enabled on your computer."

echo ""
echo "Firewall:"
echo "--------------------"
#Gather firewall status
$result = Get-NetFirewallProfile
#$result[0] is the results only for the DOMAIN firewall
$contentForDomainFW = Write-Output $result[0]
#Store the information about the DOMAIN firewall in a text file
#This is necessary because only strings can use the Select-String command later
Write-Output $contentforDomainFW  | out-file -filepath firewallDomainTest.txt
#Output only the line about if the domain firewall is enabled
$isDomainEnabled = Get-Content firewallDomainTest.txt | Select-String "Enabled"
if ($isDomainEnabled -like "*True*") {
    echo "Your domain firewall is enabled. Way to be secure!"
}
else {
    echo "Your domain firewall is disabled. You should turn it on to protect your computer."
}

$contentForPrivateFW = Write-Output $result[1]
#Store the information about the PRIVATE firewall in a text file
#This is necessary because only strings can use the Select-String command later
Write-Output $contentforPrivateFW  | out-file -filepath firewallPrivateTest.txt
#Output only the line about if the PRIVATE firewall is enabled
$isPrivateEnabled = Get-Content firewallPrivateTest.txt | Select-String "Enabled"
if ($isPrivateEnabled -like "*True*") {
    echo "Your private firewall is enabled. Way to be secure!"
}
else {
    echo "Your private firewall is disabled. You should turn it on to protect your computer."
}

$contentForPublicFW = Write-Output $result[2]
#Store the information about the PUBLIC firewall in a text file
#This is necessary because only strings can use the Select-String command later
Write-Output $contentforPublicFW  | out-file -filepath firewallPublicTest.txt
#Output only the line about if the PUBLIC firewall is enabled
$isPublicEnabled = Get-Content firewallPublicTest.txt | Select-String "Enabled"
if ($isPublicEnabled -like "*True*") {
    echo "Your public firewall is enabled. Way to be secure!"
}
else {
    echo "Your public firewall is disabled. You should turn it on to protect your computer."
}



echo ""
echo "User Accounts:"
echo "--------------------"

$guestUserContent = Get-LocalUser -Name Guest
#Store the information about the guest user in a text file
#This is necessary because only strings can be compared in if/else statements later
Write-Output $guestUserContent  | out-file -filepath guestUserInformation.txt
$guestUserInformation = Get-Content guestUserInformation.txt
if ($guestUserInformation -like "*False*") {
    echo "Your Guest account is disabled. Way to be secure!"
}
else {
    echo "Your Guest account is enabled. You should disable it to be secure."
}

#Clean up files
Remove-Item firewallDomainTest.txt
Remove-Item firewallPrivateTest.txt
Remove-Item guestUserInformation.txt
Remove-Item firewallPublicTest.txt


echo ""
echo "Windows Updates:"
echo "--------------------"
#I found this command online at https://www.action1.com/check-missing-windows-updates-script/
#Show Windows updates that still need to be installed
(New-Object -ComObject Microsoft.Update.Session).CreateupdateSearcher().Search('IsHidden=0 and IsInstalled=0').Updates | Select-Object Title




