Write-Host "Restoring Inventory Kamera..."

$msbuild = "A:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe"

& $msbuild .\InventoryKamera.sln `
    /t:Restore `
    /p:RuntimeIdentifier=win

if ($LASTEXITCODE -ne 0)
{
    Write-Host "Restore failed!" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "Building Inventory Kamera..."

& $msbuild .\InventoryKamera.sln `
    /p:Configuration=Release `
    /p:RuntimeIdentifier=win

if ($LASTEXITCODE -eq 0)
{
    Write-Host ""
    Write-Host "Build succeeded!" -ForegroundColor Green
    Write-Host "EXE location:"
    Write-Host ".\InventoryKamera\bin\Release\InventoryKamera.exe"
}
else
{
    Write-Host ""
    Write-Host "Build failed!" -ForegroundColor Red
    exit $LASTEXITCODE
}