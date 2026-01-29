param(
    [Parameter(Mandatory = $true)]
    [string]$NewName
)

$OldName = "Machine1"

Write-Host "Rename project from '$OldName' to '$NewName'" -ForegroundColor Cyan

# 1. Rename solution (.sln or .slnx)
Get-ChildItem -File -Include *.sln, *.slnx | ForEach-Object {
    $newFile = $_.Name -replace $OldName, $NewName
    Rename-Item $_.FullName $newFile
}

# 2. Rename project folder
if (Test-Path $OldName) {
    Rename-Item $OldName $NewName
}

# 3. Rename csproj
Get-ChildItem -Recurse -Filter *.csproj | ForEach-Object {
    $newFile = $_.Name -replace $OldName, $NewName
    Rename-Item $_.FullName $newFile
}

# 4. Replace namespace & references in files
Get-ChildItem -Recurse -Include *.cs,*.xaml,*.csproj,*.sln,*.slnx |
Where-Object {
    $_.FullName -notmatch "\\bin\\" -and
    $_.FullName -notmatch "\\obj\\" -and
    $_.FullName -notmatch "\\.git\\"
} |
ForEach-Object {
    (Get-Content $_.FullName) |
        ForEach-Object { $_ -replace $OldName, $NewName } |
        Set-Content $_.FullName
}

Write-Host "DONE ✅ Project renamed to '$NewName'" -ForegroundColor Green