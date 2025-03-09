$rpaFile = "0x52_URM.rpa"
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$list = Get-ChildItem $scriptPath -recurse | Where-Object {$_.PSIsContainer -eq $true -and $_.Name -eq "game"}
foreach($item in $list){
    Copy-Item $rpaFile $item.FullName -Force
}