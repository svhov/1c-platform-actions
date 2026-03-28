# Запуск 1С:Предприятие
#
# Параметры:
#   -EpfFile - (опционально) путь к обработке для автооткрытия

param(
    [string]$EpfFile = ""
)

. "$PSScriptRoot\1c-common.ps1"
Initialize-1CEnvironment

$allArgs = @("ENTERPRISE")
$allArgs += Get-1CConnectionArgs
$allArgs += Get-1CAuthArgs

if ($EpfFile) {
    $allArgs += @("/Execute", $EpfFile)
    Write-Host "Запуск предприятия с обработкой $EpfFile..."
} else {
    Write-Host "Запуск предприятия..."
}

Start-Process -FilePath $env:ONEC_PATH -ArgumentList $allArgs

Write-Host "Предприятие запущено" -ForegroundColor Green
