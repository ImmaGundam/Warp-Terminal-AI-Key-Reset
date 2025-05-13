<#
###################################################################
          Warp Terminal API Key Reset Script                        
          Deletes local temp files in user's APP directory           
          First run of script will ask user to locate User folder   
          https://github.com/ImmaGundam                             
          James Deitz - ImmaGundam © 2025                           
###################################################################
#>
# Prompt for username or full path
$userInput = Read-Host "Enter your Windows username (or full path to the user folder, e.g., C:\Users\YourName)"

# Determine the full path
if ($userInput -like "C:\Users\*") {
    $userPath = $userInput
} else {
    $userPath = "C:\Users\$userInput"
}

$dataPath = Join-Path $userPath "AppData\Local\warp\Warp\data"

# Confirm that the folder exists
if (-Not (Test-Path $dataPath)) {
    Write-Host "❌ The path '$dataPath' does not exist. Exiting." -ForegroundColor Red
    exit
}

# Define the script content
$cleanupScript = @"
# Auto-generated script to clean up files in: $dataPath
`$targetPath = "$dataPath"
Get-ChildItem -Path `$targetPath -File | Where-Object { `$_.Name -ne "warp.sqlite" } | Remove-Item -Force
"@

# Save the cleanup script
$outputPath = ".\delete_except_warpsqlite.ps1"
$cleanupScript | Out-File -FilePath $outputPath -Encoding UTF8

Write-Host "✅ Script 'delete_except_warpsqlite.ps1' has been created in the current directory." -ForegroundColor Green
Write-Host "Run it with: `n  PowerShell -ExecutionPolicy Bypass -File .\delete_except_warpsqlite.ps1"
