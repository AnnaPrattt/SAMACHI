# SAMACHI: Secure Audit Machine
### By Anna Pratt, Riley Croft, Dallin Duke, and Eric Pressler
# BYU IS 565 - Digital Forensics with Dr. Justin Giboney

## Overview
SAMACHI (Secure-Audited Machine) is a simple PowerShell script that checks your Windows device for some basic secure configuration settings. We developed it as a custom security tool to help cyber defenders with checking Windows configurations for security concerns. We are currently developing this script and adding more features so that it checks for more configuration settings.

### Added In November

#### Password Test
We added `password-test.ps1`, which prompts you for your Windows password and checks to see if your password is contained within the rockyou list, a famous list of over 14 million common passwords. If your password appears in the rockyou list, then your password is a well know password to every hacker in the world, and we recommend you change it.

```PowerShell
.\password-test.ps1 -p
```

When the password test portion of the code runs, you will be prompted with a window like that in figure 0 which will ask you for your credentials. Enter anything you want for the username, as the username is not used. But enter in your Windows user password that you use to log into your Windows machine. 

![prompt for password](November-Documentation/enter-pass.png)

*Figure 0: Screenshot of the prompt for user credentials*

```
Please make sure that your copy of the rockyou list is in the same directory as the Automated_Tests.ps1 file
```

[The rockyou list can be downloaded here](https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt) (too large for this repo).

***Please note that SAMACHI does NOT store your password or send it over any network connections. The script does not do anything with your password except for compare it to the rockyou list. Furthermore, the password test is optional so if you are uncomfortable entering your password into the script, you do not have to use that specific test.***

#### Possible Password Test Output
**Successful Output**

![Successful Password Test Output](November-Documentation/passwd-test-good.png)

*Figure 0.1: Successful Password Test Output*

**Failed Output**

![Failed Password Test Output](November-Documentation/passwd-test-fail.png)

*Figure 0.2: Failed Password Test Output*

Regardless of the outcome, SAMACHI suggests some good password practices to implement.

Please note that the password test takes approximately 90 seconds to complete.


### How to Run
To run SAMACHI, first download the file or clone this GitHub repo. The easiest way to run the script is to right click the .ps1 file and choose the option "Run with PowerShell".

![Run with powershell](/images/run-with-powershell.png)

*Figure 1: Run with PowerShell option after right-clicking the file.*


#### Potential Problems

Windows might not let you run this script by default because the script is of unknown origin. 

If you see an Unknown Publisher error as shown in Figure 2 below, click on the Open button. Microsoft shows this warning to help prevent users from running malicious scripts. The script should run after you click "Open".

![Unknown publisher error](/images/unknown-publisher.png)

*Figure 2: Unknown Publisher Error*

Because this script is not signed, many people encounter an issue with the execution policy. We have observed that cachines running Windows 11 encounter this issue more often, but it may occur on Windows 10 as well. In order to avoid this issue perform the following steps:
1. Run powershell as Admin
2. Check your execution policy so that you can return it back to normal after running the script. Run `Get-ExecutionPolicy -List` and make note of the default settings.
3. Run `Set-ExecutionPolicy Unrestricted` to enable any script to be run. Then press r to run.

![Set-ExecutionPolicy Unrestricted Example](/images/execution-policy-unrestricted.png)

*Figure 3: Set-ExecutionPolicy Unrestricted Example*

4. Run the script.
5. Return the execution policy to how it was set before in order to keep your machine secure with `Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope LocalMachine`.

![Set-ExecutionPolicy restricted Example](/images/execution-policy-restricted.png)

*Figure 4: Set-ExecutionPolicy Restricted Example*


### Proof of Concept

![All firewalls good](/images/all-firewalls-good.png)

*Figure 5: shows what it looks like when all of the user’s firewalls are enabled.*


![1 firewall bad](/images/domain-firewall-disabled.png)

*Figure 6: shows what it looks like when the user’s domain firewall is disabled.*


![2 firewalls bad](/images/2-firewalls-disabled.png)

*Figure 7: shows what it looks like when the user’s domain and private firewalls are disabled.*


![SAMACHI_Testing_EverythingEnabled](/images/SAMACHI_Testing_EverythingEnabled.png)

*Figure 8: shows the script output when the Guest account is disbled, and when Windows updates are pending to be installed.*
 

![SAMACHI_Testing_GuestAccountEnabled](/images/SAMACHI_Testing_GuestAccountEnabled.png)

*Figure 9: shows the script output when the Guest account is enabled. Note that the script notices the Guest account is enabled and recommends it to be disabled.*


![DellUpdatesPending](/images/DellUpdatesPending.png) 

*Figure 10: shows a visual representation of the updates that were detailed in the script. The script notified the user that they needed to install these updates.*

![Chrome up to date](/images/chrome-up-to-date.png)

*Figure 11: shows that Google Chrome is installed and up to date with the latest stable version.*

![Chrome not installed](/images/chrome-not-installed.png)

*Figure 11: shows that Google Chrome is not installed on the computer.*




## Features
The automated program audits the following security features:

* Antivirus
* Firewall
* User Accounts
* Windows Updates
* Miscellaneous Security Features

    * Smart Screen
    * Secure Boot
    * SMBv1 
    * Google Chrome Version
    