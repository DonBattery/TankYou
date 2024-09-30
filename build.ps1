$ErrorActionPreference = "Stop"

$repositoryPath = Get-Location 
$zipFileName = "archive.zip"
$zipFilePath = Join-Path $repositoryPath $zipFileName
$webBuildFolder = "docs"

Write-Host "Zipping the repository..."

Compress-Archive -Path "$repositoryPath\*" -DestinationPath $zipFilePath -Force

Write-Host "Repository zipped to $zipFilePath."

Write-Host "Building the webpage using love.js..."
$npxCommand = "npx love.js.cmd -t TankYou -c $zipFilePath $webBuildFolder"

Invoke-Expression $npxCommand

Write-Host "Remove the zip file..."
Remove-Item $zipFilePath

Write-Host "Build complete! Webpage output is in the '$webBuildFolder' folder."
