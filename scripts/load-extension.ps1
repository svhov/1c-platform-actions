# Загрузка расширения конфигурации из XML в базу с обновлением БД
#
# Параметры:
#   -XmlDir       - каталог с XML-файлами расширения
#   -ExtName      - имя расширения
#   -SkipDbUpdate - пропустить обновление расширения в БД
#   -LogFile      - путь к лог-файлу (по умолчанию $env:TEMP\1c-load.log)

param(
    [Parameter(Mandatory)][string]$XmlDir,
    [Parameter(Mandatory)][string]$ExtName,
    [switch]$SkipDbUpdate,
    [string]$LogFile = "$env:TEMP\1c-load.log"
)

. "$PSScriptRoot\1c-common.ps1"

$extraArgs = @(
    "/LoadConfigFromFiles", $XmlDir,
    "-Extension", $ExtName,
    "-updateConfigDumpInfo"
)

if (-not $SkipDbUpdate) {
    $extraArgs += "/UpdateDBCfg"
    Write-Host "Загрузка расширения '$ExtName' из $XmlDir (с обновлением БД)..."
} else {
    Write-Host "Загрузка расширения '$ExtName' из $XmlDir (без обновления БД)..."
}

$proc = Invoke-1CDesigner -ExtraArgs $extraArgs -LogFile $LogFile -Wait

if ($proc.ExitCode -eq 0) {
    Write-Host "Загрузка завершена успешно" -ForegroundColor Green
} else {
    Write-Host "Ошибка загрузки (код: $($proc.ExitCode))" -ForegroundColor Red
    if (Test-Path $LogFile) {
        Write-Host "--- Лог ---" -ForegroundColor Yellow
        Get-Content $LogFile -Encoding UTF8
    }
    exit 1
}
