# Trilby Powershell Library
# Owner: Trilby Multimedia Limited, 2015
# Author: Dom Barnes
# Date: 2015-06-17
# Description:
# Collection of generic reusable functions across backup servers

<#
.SYNOPSIS
    Deletes files based on age
.DESCRIPTION
    Deletes all files of a given type that are older than a given number of days
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
    Delete-Files -Path "D:\backup\sites\" -Filefilter "*.bak" -Age 3
.NOTES
    Author: Dominic Barnes
    Date:   2015-09-16   
    Owner: Trilby Multimedia Limited
#>

function Delete-Files {
    Param(
        [string]$Path = "Help", # Specify a full valid path
        [string]$Filefilter = "Help", # Set your file type, eg txt, bat, bak, 7z
        [int]$Age
        )
    Get-ChildItem $path -Recurse -Include $Filefilter | WHERE {($_.CreationTime -le $(Get-Date).AddDays(-$Age))} | Remove-Item -force
}
export module-member Delete-Files