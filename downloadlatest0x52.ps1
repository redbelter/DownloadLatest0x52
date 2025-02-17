
$rpaFile = "0x52_URM.rpa"
$etagFile = "0x52_URM.rpa.etag"
$zipFile = "0x52_URM.zip"
$folderNameFromZip = "temp0x52_URMtemp"
$downloadPath = "https://api.0x52.dev/modversions/1217/download"


function CheckForNewEtag {
    $x =(invoke-webrequest $downloadPath -UseBasicParsing -method head)
    return $x.Headers.ETag;
}

function Download0x52 {
    $x =(invoke-webrequest $downloadPath -UseBasicParsing -OutFile $zipFile)
}


$shouldDownload = $False
if(-not (Test-Path $rpaFile))
{
    Write-Output "rpa file is missing"
    $shouldDownload = $True
} elseif (-not (Test-Path $etagFile))
{
    #we dont have etag cached
    Write-Output "etag cache doesnt exist"
    $shouldDownload = $True
} else {
    $currentETag = Get-Content $etagFile
    $newETag = CheckForNewEtag
    if(-not ($currentETag.Equals($newETag)))
    {
        Write-Output "New etag available"
        $shouldDownload = $True
    } else {
        Write-Output "Etag matches, no update"
    }
}

if($shouldDownload)
{
    Write-Output "Downloading 0x52"
    $newTag = CheckForNewEtag
    Download0x52
    Expand-Archive $zipFile -Force -DestinationPath $folderNameFromZip
    Remove-Item $zipFile
    Move-Item (Join-Path $folderNameFromZip $rpaFile), $rpaFile -Force
    Remove-Item $folderNameFromZip -Recurse
    $newTag | Out-File $etagFile -encoding ascii
    Write-Output "Done :)"
}
