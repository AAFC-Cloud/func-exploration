$sub = "mysub"
$rg="my-rg"
$storage="myrustazurefunc"
Write-Host "Getting access key"
$access_key = az storage account show-connection-string `
--subscription $sub `
--resource-group $rg `
--name $storage -o tsv

Write-Host "Updating local.settings.json"
$settings = Get-Content -Raw .\local.settings.json | ConvertFrom-Json
$settings.Values.AzureWebJobsStorage = $access_key
$settings | ConvertTo-Json | Set-Content .\local.settings.json