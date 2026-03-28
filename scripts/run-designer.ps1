# Запуск конфигуратора 1С

param(
    [string]$LogFile = ""
)

. "$PSScriptRoot\1c-common.ps1"

Write-Host "Запуск конфигуратора..."

$proc = Invoke-1CDesigner -ExtraArgs @() -LogFile $LogFile

Write-Host "Конфигуратор запущен" -ForegroundColor Green
