<#
.SYNOPSIS
    Upload something via FTP
.DESCRIPTION
    TODO
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
    Send-FTP "D:\backup\sites" -Type "7z" -Dest "remote\path\to"
.NOTES
    Author: Dominic Barnes
    Date:   2015-09-16   
    Owner: Trilby Multimedia Limited
#>


function Send-FTP {
    Param(
        [string]$Path, 
        [string]$Type, 
        [string]$Dest
        )
    $latest = $(Get-ChildItem -Include @("*.$Type") -Path $Path -Recurse | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
    $ParentProgressId = -1 ## Just ignore this ;)
    $ProgressActivity = "Uploading $latest"
    $dirdate= $server + $(get-date -format yyyy-MM-dd)
 
    if( -not (Test-Path $latest) ) {
        Throw "File '$latest' does not exist!"
        }
 
    $total = (gci $latest).Length
    $upload = $dirdate + "/" + $latest.Name
    #Write-Host $upload

    # $webclient = New-Object System.Net.WebClient
    $webclient = [Net.FtpWebRequest]::Create($upload)
    $webclient.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
    $webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass)
    $webclient.UsePassive = $true
    $webclient.UseBinary = $true
    $webclient.KeepAlive = $false
    $webclient.EnableSsl = $false

    $latestSize = $latest.length/(1024*1024*1024)
    $latestSize = "{0:N2}" -f $latestSize

    try {
        $read = [IO.File]::OpenRead( (Convert-Path $latest) )
        #Write-Host (Convert-Path $latest)
        $write = $webclient.GetRequestStream();
        $buffer = New-Object byte[] 1024
        $offset = 0
        $progress = 0
        do {
          #Create the latest date folder
          Create-FtpDirectory -sourceuri $dirdate -username $user -password $pass
          #Start uploading
          $offset = $read.Read($buffer, 0, $buffer.Length)
          $progress += $offset
          $write.Write($buffer, 0, $offset);
          Write-Progress $ProgressActivity "Uploading" -Percent ([int]($progress/$total * 100)) -Parent $ParentProgressId
	        }
	     while($offset -gt 0)
           $write.Close()
	         $write.Dispose()
        } finally {
        Write-Debug "Finishing..."
    }
        Write-Debug "Done!"
 }

export-modulemember -function Send-FTP
