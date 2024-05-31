#================================================================================================================================

#----------------INFO----------------
#
# CC-BY-SA-NC Stella Ménier <stella.menier@gmx.de>
# Project creator for Skrivanek GmbH
#
# Usage: powershell.exe -executionpolicy bypass -file ".\Rocketlaunch.ps1"
# Usage: Compiled form, just double-click.
#
#-------------------------------------


    #===============================================
    #                Initialization                =
    #===============================================

#========================================
# Get all important variables in place 

# Grab script location in a way that is compatible with PS2EXE
if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript")
    { $global:ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition }
else
    {$global:ScriptPath = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0]) 
    if (!$ScriptPath){ $global:ScriptPath = "." } }

# Read the file
$settings = Import-LocalizedData -FileName settings.psd1

# Load everything we need
Import-Module $ScriptPath\sources\UI.ps1
Import-Module $ScriptPath\sources\utils.ps1




# Start the subprocesses
if ($settings.TopLeftOverview.Enabled)
{
    Start-Process -FilePath $ScriptPath\functionalities\hotcorner_topleft.exe -ArgumentList $settings.TopLeftOverview.reactivity,$settings.TopLeftOverview.sensitivity 
}

if ($settings.WindowsButton.Enabled) 
{
    Start-Process  -FilePath $ScriptPath\functionalities\hotcorner_winbutton.exe -ArgumentList $settings.WindowsButton.reactivity,$settings.WindowsButton.sensitivity
}


if ($settings.KeepAwake.Enabled)
{
    Start-Process -FilePath $ScriptPath\functionalities\keepawake.exe    
}



# Tell user we started
$Main_Tool_Icon.BalloonTipTitle = "Started !"
$Main_Tool_Icon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
$Main_Tool_Icon.BalloonTipText = "The puter is now prevented from going to sleep"
$Main_Tool_Icon.Visible = $true
$Main_Tool_Icon.ShowBalloonTip(500)



# Force garbage collection just to start slightly lower RAM usage.
[System.GC]::Collect()

# Create an application context for it to all run within.
# This helps with responsiveness, especially when clicking Exit.
$appContext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appContext)


