#Minh update 30/01/2026
param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectName
)

$OldName = "Genaral_Template"

Write-Host "Rename project from '$OldName' to '$ProjectName'" -ForegroundColor Cyan

$solutionFile = Get-ChildItem -Path . -File | Where-Object {
    $_.Extension -in ".sln", ".slnx" -and $_.Name -like "*$OldName*"
}

if ($solutionFile) {
    $solutionNewName = $solutionFile.Name -replace $OldName, $ProjectName
    Write-Host "Rename solution: $($solutionFile.Name) -> $solutionNewName"
    Rename-Item $solutionFile.FullName $solutionNewName
}

if (Test-Path $OldName) {
    Write-Host "Rename folder: $OldName -> $ProjectName"
    Rename-Item $OldName $ProjectName
}

Get-ChildItem -Recurse -Filter *.csproj | ForEach-Object {
    if ($_.Name -like "*$OldName*") {
        $csprojNewName = $_.Name -replace $OldName, $ProjectName
        Write-Host "Rename csproj: $($_.Name) -> $csprojNewName"
        Rename-Item $_.FullName $csprojNewName
    }
}

Get-ChildItem -Recurse -Include *.cs,*.xaml,*.csproj,*.sln,*.slnx |
Where-Object {
    $_.FullName -notmatch "\\bin\\" -and
    $_.FullName -notmatch "\\obj\\" -and
    $_.FullName -notmatch "\\.git\\" -and
    $_.FullName -notmatch "\\.vs\\"
} |
ForEach-Object {
    (Get-Content $_.FullName) `
        -replace $OldName, $ProjectName |
        Set-Content $_.FullName
}

Write-Host "DONE Project renamed to '$ProjectName'" -ForegroundColor Green
