# Trilby Powershell Library
# Owner: Trilby Multimedia Limited, 2015
# Author: Dom Barnes
# Date: 2015-06-17
# Description:
# Collection of generic reusable functions across backup servers

<#
.SYNOPSIS
    Grabs latest file in a folder
.DESCRIPTION
    Grabs latest file in a folder
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
    TODO
.NOTES
    Author: Dominic Barnes
    Date:   2016-02-02
    Owner: Trilby Multimedia Limited
#>

function Get-LatestFile {
    Param(
        [Parameter(Mandatory=$true)][string]$Path = "Help", # Specify a full valid path
        [Parameter(Mandatory=$true)][string]$Type = "Help" # Set your file type, eg txt, bat, bak, 7z
        )
    Get-ChildItem $Path -Recurse -Include $Type | WHERE {($_.CreationTime -le $(Get-Date))}
}
export-modulemember -function Get-LatestFile
