# Загрузка конфигурации из XML в базу с обновлением БД
#
# Параметры:
#   -XmlDir       - каталог с XML-файлами конфигурации
#   -Files        - список файлов через запятую для частичной загрузки
#   -SkipDbUpdate - пропустить обновление конфигурации БД
#   -LogFile      - путь к лог-файлу

param(
    [Parameter(Mandatory)][string]$XmlDir,
    [string]$Files = "",
    [switch]$SkipDbUpdate,
    [string]$LogFile = "$env:TEMP\1c-load.log"
)

. "$PSScriptRoot\1c-common.ps1"

$extraArgs = @("/LoadConfigFromFiles", $XmlDir)

if ($Files) {
    $extraArgs += @("-files", $Files, "-Format", "Hierarchical")
    Write-Host "Частичная загрузка конфигурации из $XmlDir..."
    Write-Host "  Файлы: $Files"
} else {
    Write-Host "Полная загрузка конфигурации из $XmlDir..."
}

$extraArgs += "-updateConfigDumpInfo"

if (-not $SkipDbUpdate) {
    $extraArgs += "/UpdateDBCfg"
    Write-Host "  Обновление БД: да"
} else {
    Write-Host "  Обновление БД: нет"
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
