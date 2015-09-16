<#
.SYNOPSIS
    Send messages to Slack
.DESCRIPTION
    Sends a specified JSON package to the DevOps slack channel
.PARAMETER Path
    The path to the .
.PARAMETER LiteralPath
    Specifies a path to one or more locations. Unlike Path, the value of 
    LiteralPath is used exactly as it is typed. No characters are interpreted 
    as wildcards. If the path includes escape characters, enclose it in single
    quotation marks. Single quotation marks tell Windows PowerShell not to 
    interpret any characters as escape sequences.
.EXAMPLE
    C:\PS> 
    Tell-Slack -notificationPayload "{"text": "Hello, World"}"
.NOTES
    Author: Dominic Barnes
    Date:   2015-09-16   
    Owner: Trilby Multimedia Limited
#>

function Tell-Slack{
    Param(
        [Parameter(Mandatory=$true)][string] $notificationPayload = "Help" #Accepts a valid JSON bundle
        )
    
    # Set the Slack channel webhook URL
    $slackURI="https://hooks.slack.com/services/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"
    
    # Call a post function with a valid JSON payload
    Invoke-RestMethod -Uri $slackURI -Method Post -Body $notificationPayload
}

export-modulemember -function Tell-Slack
