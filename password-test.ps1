echo ""
echo "Password Test:"
echo "--------------------"

#Ask for the user's password
echo "Please note that SAMACHI does not store user input anywhere and has no memory of what you input."
echo ""
$credential = Get-Credential -Message "Please enter your Windows password used to logon to this machine. Enter any username, as we do not check it. Enter 'Cancel' to cancel this test."
echo ""
$userPass = $credential.GetNetworkCredential().Password

$startTime = Get-Date

#Give them a chance to cancel the test
if ($userPass -eq "Cancel") {
    echo "Cancelling Password Test. If your password is actually 'Cancel', please consider changing it as that is not a very strong password!"
}
else {
    #Check if the user's password is in the rockyou list
    $passwordInList = (Get-Content ".\rockyou.txt" | Select-String -Pattern $userPass -SimpleMatch).Count -gt 0

    $endTime = Get-Date
    $timeElapsed = $endTime - $startTime
    echo "Script execution time: $($timeElapsed.TotalSeconds) seconds"

    #Print the results
    if ($passwordInList) {
        echo "Uh oh! Your password is in a list of 14 million common passwords! Please change your password as soon as possible!"
        echo ""
    }
    else {
        echo "Your password does not appear in the rockyou list. Good job!"
        echo ""
    }

    #Provide general good password practices
    echo "Recommended Good Password Practices:"
    echo "* Passwords should be at least 12 characters in length"
    echo "* Passwords should contain upper and lowercase letters"
    echo "* Passwords should contain at least one number"
    echo "* Passwords should contain at least one special character"
    echo ""
    echo "* You can also consider a passphrase, which is longer than a normal password but doesn't have to be as complex. An example (that you shouldn't use) is 'CorrectHorseBatteryStaple'."
}