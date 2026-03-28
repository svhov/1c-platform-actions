# Разборка внешней обработки/отчёта в XML
#
# Параметры:
#   -XmlFile  - корневой XML-файл для выгрузки
#   -EpfFile  - путь к EPF/ERF файлу
#   -LogFile  - путь к лог-файлу

param(
    [Parameter(Mandatory)][string]$XmlFile,
    [Parameter(Mandatory)][string]$EpfFile,
    [string]$LogFile = "$env:TEMP\1c-dump.log"
)

. "$PSScriptRoot\1c-common.ps1"

Write-Host "Разборка обработки..."
Write-Host "  Источник: $EpfFile"
Write-Host "  Результат: $XmlFile"

$extraArgs = @("/DumpExternalDataProcessorOrReportToFiles", $XmlFile, $EpfFile)

$proc = Invoke-1CDesigner -ExtraArgs $extraArgs -LogFile $LogFile -Wait

if ($proc.ExitCode -eq 0) {
    Write-Host "Разборка завершена успешно" -ForegroundColor Green
} else {
    Write-Host "Ошибка разборки (код: $($proc.ExitCode))" -ForegroundColor Red
    if (Test-Path $LogFile) {
        Write-Host "--- Лог ---" -ForegroundColor Yellow
        Get-Content $LogFile -Encoding UTF8
    }
    exit 1
}
