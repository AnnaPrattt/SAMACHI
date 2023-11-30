param(
    [switch]$p
)

#Check if the -p is present
if ($p) {
    #Ask for the user's password
    echo "Please note that SAMACHI does not store user input anywhere and has no memory of what you input."
    $credential = Get-Credential -Message "Please enter your Windows password used to logon to this machine. Enter any username, as we do not check it. Enter 'Cancel' to cancel this test."
    $userPass = $credential.GetNetworkCredential().Password
    #Give them a chance to cancel the test
    if ($userPass -eq "Cancel") {
        echo "Cancelling Password Test. If your password is actually 'Cancel', please consider changing it as that is not a very strong password!"
    }
    else {
        #Read the rockyou list into a hash set
        $wordlistContent = Get-Content -Path ".\rockyou-top100.txt"
        $hashSet = New-Object [System.Collections.Generic.HashSet[string]]
        $hashSet.AddRange($wordlistContent)

        #Check if the user's password appears in the rockyou list
        if ($hashSet.Contains($userPass)) {
            echo "Uh oh!"
        }
        else {
            echo "hahaha good :)"
        }
    }
}
else {
    echo "You opted not to run the password check"
}