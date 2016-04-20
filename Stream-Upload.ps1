function Stream-Upload {
  # This seems to only upload at about 2.3MBps, the UploadFile method goes at about 10MBps
  
  $total = (gci $latest).Length

  $ftpRequest = [System.Net.FTPWebRequest]::Create($uri)
  $ftpRequest.Credentials = $webclient.Credentials
  $ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
  $ftpRequest.Proxy = $null
  $ftpRequest.UsePassive = $true
  $ftpRequest.UseBinary = $true
  $ftpRequest.ContentLength = $total
  $RS = $ftpRequest.GetRequestStream()
  $Reader = New-Object System.IO.FileStream ($latest.FullName, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::Read)
  [byte[]]$Buffer = New-Object byte[] 4096
  [int]$Count = 0
  do {
    $Count = $Reader.Read($Buffer, 0, $Buffer.Length)
    $progress += $Count
    $RS.Write($Buffer, 0, $Count.length)
    Write-Progress "Uploading file:" -Percent ([int]($progress/$total * 100)) -Parent $ParentProgressId
  }
  while ($Count -gt 0)
  $RS.Close()
  $RS.Dispose()
  $Reader.Close()
  $Reader.Dispose()
}
