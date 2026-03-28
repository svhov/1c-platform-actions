# Выгрузка расширения конфигурации из базы в XML
#
# Параметры:
#   -XmlDir   - каталог для выгрузки XML
#   -ExtName  - имя расширения
#   -Update   - инкрементальная выгрузка (только изменения)
#   -LogFile  - путь к лог-файлу

param(
    [Parameter(Mandatory)][string]$XmlDir,
    [Parameter(Mandatory)][string]$ExtName,
    [switch]$Update,
    [string]$LogFile = "$env:TEMP\1c-dump.log"
)

. "$PSScriptRoot\1c-common.ps1"

$extraArgs = @(
    "/DumpConfigToFiles", $XmlDir,
    "-Extension", $ExtName
)

if ($Update) {
    $extraArgs += "-update"
    Write-Host "Инкрементальная выгрузка расширения '$ExtName' в $XmlDir..."
} else {
    Write-Host "Полная выгрузка расширения '$ExtName' в $XmlDir..."
}

$proc = Invoke-1CDesigner -ExtraArgs $extraArgs -LogFile $LogFile -Wait

if ($proc.ExitCode -eq 0) {
    Write-Host "Выгрузка завершена успешно" -ForegroundColor Green
} else {
    Write-Host "Ошибка выгрузки (код: $($proc.ExitCode))" -ForegroundColor Red
    if (Test-Path $LogFile) {
        Write-Host "--- Лог ---" -ForegroundColor Yellow
        Get-Content $LogFile -Encoding UTF8
    }
    exit 1
}
