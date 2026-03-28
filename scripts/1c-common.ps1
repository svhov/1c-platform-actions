# Общие функции для скриптов 1С
# Подключается через: . "$PSScriptRoot\1c-common.ps1"

function Get-1CDevBase {
    # Ищем .1c-devbase.ps1 начиная от переданного пути вверх
    $searchPath = $PSScriptRoot
    for ($i = 0; $i -lt 10; $i++) {
        $candidate = Join-Path $searchPath ".1c-devbase.ps1"
        if (Test-Path $candidate) {
            return $candidate
        }
        $searchPath = Split-Path $searchPath -Parent
        if (-not $searchPath) { break }
    }
    return $null
}

function Initialize-1CEnvironment {
    $devbase = Get-1CDevBase
    if (-not $devbase) {
        Write-Host "Ошибка: не найден .1c-devbase.ps1" -ForegroundColor Red
        Write-Host "Скопируйте .1c-devbase.ps1.example в корень проекта как .1c-devbase.ps1"
        exit 1
    }
    . $devbase

    $env:ONEC_PATH = $ONEC_PATH
    $env:ONEC_FILEBASE_PATH = $ONEC_FILEBASE_PATH
    $env:ONEC_USER = $ONEC_USER
    $env:ONEC_PASSWORD = $ONEC_PASSWORD
    if (Get-Variable ONEC_SERVER -ErrorAction SilentlyContinue) {
        $env:ONEC_SERVER = $ONEC_SERVER
    }
    if (Get-Variable ONEC_BASE -ErrorAction SilentlyContinue) {
        $env:ONEC_BASE = $ONEC_BASE
    }
}

function Get-1CConnectionArgs {
    if ($env:ONEC_SERVER) {
        return @("/S", "$($env:ONEC_SERVER)\$($env:ONEC_BASE)")
    } elseif ($env:ONEC_FILEBASE_PATH) {
        return @("/F", $env:ONEC_FILEBASE_PATH)
    } else {
        Write-Host "Ошибка: не указан ни сервер (ONEC_SERVER), ни путь к файловой базе (ONEC_FILEBASE_PATH)" -ForegroundColor Red
        exit 1
    }
}

function Get-1CAuthArgs {
    $args_list = @()
    if ($env:ONEC_USER) {
        $args_list += "/N"
        $args_list += $env:ONEC_USER
    }
    if ($env:ONEC_PASSWORD) {
        $args_list += "/P"
        $args_list += $env:ONEC_PASSWORD
    }
    return $args_list
}

function Invoke-1CDesigner {
    param(
        [string[]]$ExtraArgs,
        [string]$LogFile = "",
        [switch]$Wait
    )

    Initialize-1CEnvironment

    $allArgs = @("DESIGNER")
    $allArgs += Get-1CConnectionArgs
    $allArgs += Get-1CAuthArgs
    $allArgs += "/DisableStartupDialogs"

    if ($LogFile) {
        $allArgs += "/Out"
        $allArgs += $LogFile
    }

    $allArgs += $ExtraArgs

    $params = @{
        FilePath = $env:ONEC_PATH
        ArgumentList = $allArgs
        PassThru = $true
        NoNewWindow = $true
    }
    if ($Wait) { $params.Wait = $true }

    $proc = Start-Process @params
    return $proc
}
