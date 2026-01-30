param(
    [Parameter(Mandatory = $true)]
    [string]$NewName
)

$OldName = "Genaral_Template"

Write-Host "Rename project from '$OldName' to '$NewName'" -ForegroundColor Cyan

Get-ChildItem -Path . -File | Where-Object {
    $_.Extension -in ".sln", ".slnx"
} | ForEach-Object {

    if ($_.Name -like "*$OldName*") {
        $newName = $_.Name -replace $OldName, $NewName
        Write-Host "Rename solution: $($_.Name) -> $newName"
        Rename-Item $_.FullName $newName
    }
}

if (Test-Path $OldName) {
    Write-Host "Rename folder: $OldName -> $NewName"
    Rename-Item $OldName $NewName
}

Get-ChildItem -Recurse -Filter *.csproj | ForEach-Object {

    if ($_.Name -like "*$OldName*") {
        $newName = $_.Name -replace $OldName, $NewName
        Write-Host "Rename csproj: $($_.Name) -> $newName"
        Rename-Item $_.FullName $newName
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
        -replace $OldName, $NewName |
        Set-Content $_.FullName
}

Write-Host "DONE Project renamed to '$NewName'" -ForegroundColor Green