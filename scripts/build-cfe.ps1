# Сборка файла расширения (.cfe) из XML
#
# Параметры:
#   -XmlDir     - каталог с XML-файлами расширения
#   -ExtName    - имя расширения
#   -OutputFile - путь к результирующему CFE-файлу
#   -LogFile    - путь к лог-файлу

param(
    [Parameter(Mandatory)][string]$XmlDir,
    [Parameter(Mandatory)][string]$ExtName,
    [Parameter(Mandatory)][string]$OutputFile,
    [string]$LogFile = "$env:TEMP\1c-build.log"
)

. "$PSScriptRoot\1c-common.ps1"

Write-Host "Сборка расширения (.cfe)..."
Write-Host "  Источник:    $XmlDir"
Write-Host "  Расширение:  $ExtName"
Write-Host "  Результат:   $OutputFile"

$extraArgs = @(
    "/LoadConfigFromFiles", $XmlDir,
    "-Extension", $ExtName,
    "/DumpCfg", $OutputFile,
    "-Extension", $ExtName
)

$proc = Invoke-1CDesigner -ExtraArgs $extraArgs -LogFile $LogFile -Wait

if ($proc.ExitCode -eq 0) {
    Write-Host "Сборка завершена успешно" -ForegroundColor Green
} else {
    Write-Host "Ошибка сборки (код: $($proc.ExitCode))" -ForegroundColor Red
    if (Test-Path $LogFile) {
        Write-Host "--- Лог ---" -ForegroundColor Yellow
        Get-Content $LogFile -Encoding UTF8
    }
    exit 1
}
