# Сборка внешней обработки/отчёта из XML
#
# Параметры:
#   -XmlFile    - корневой XML-файл обработки
#   -OutputFile - путь к результирующему EPF/ERF файлу
#   -LogFile    - путь к лог-файлу

param(
    [Parameter(Mandatory)][string]$XmlFile,
    [Parameter(Mandatory)][string]$OutputFile,
    [string]$LogFile = "$env:TEMP\1c-build.log"
)

. "$PSScriptRoot\1c-common.ps1"

Write-Host "Сборка обработки..."
Write-Host "  Источник: $XmlFile"
Write-Host "  Результат: $OutputFile"

$extraArgs = @("/LoadExternalDataProcessorOrReportFromFiles", $XmlFile, $OutputFile)

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
