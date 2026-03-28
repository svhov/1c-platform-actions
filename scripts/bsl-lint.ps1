# Проверка BSL-кода через BSL Language Server
#
# Параметры:
#   -SrcDir     - каталог с BSL-файлами для проверки
#   -ConfigFile - путь к .bsl-language-server.json (опционально)
#   -Reporter   - формат отчёта: console, json, junit, tslint, generic (по умолчанию console)
#   -OutputFile - файл для сохранения отчёта (опционально)

param(
    [Parameter(Mandatory)][string]$SrcDir,
    [string]$ConfigFile = "",
    [ValidateSet("console", "json", "junit", "tslint", "generic")]
    [string]$Reporter = "console",
    [string]$OutputFile = ""
)

# Поиск bsl-language-server
$bslLsCmd = Get-Command "bsl-language-server" -ErrorAction SilentlyContinue
if (-not $bslLsCmd) {
    $bslLsJar = Get-ChildItem -Path $PSScriptRoot, "." -Filter "bsl-language-server*.jar" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($bslLsJar) {
        $bslLs = "java -jar `"$($bslLsJar.FullName)`""
    } else {
        Write-Host "Ошибка: bsl-language-server не найден" -ForegroundColor Red
        Write-Host "Установите: https://github.com/1c-syntax/bsl-language-server/releases"
        Write-Host "Или положите JAR-файл рядом со скриптами"
        exit 1
    }
} else {
    $bslLs = "bsl-language-server"
}

if (-not (Test-Path $SrcDir)) {
    Write-Host "Ошибка: каталог '$SrcDir' не найден" -ForegroundColor Red
    exit 1
}

Write-Host "Проверка BSL-кода..."
Write-Host "  Каталог: $SrcDir"
Write-Host "  Формат:  $Reporter"

$analyzeArgs = @("--analyze", "--srcDir", $SrcDir, "--reporter", $Reporter)

if ($ConfigFile) {
    if (-not (Test-Path $ConfigFile)) {
        Write-Host "Ошибка: файл конфигурации '$ConfigFile' не найден" -ForegroundColor Red
        exit 1
    }
    $analyzeArgs += @("--configuration", $ConfigFile)
    Write-Host "  Конфиг:  $ConfigFile"
}

if ($OutputFile) {
    $analyzeArgs += @("--outputDir", (Split-Path $OutputFile -Parent))
    Write-Host "  Отчёт:   $OutputFile"
}

if ($bslLs -like "java*") {
    $jarPath = ($bslLs -replace 'java -jar "', '' -replace '"$', '')
    $proc = Start-Process -FilePath "java" -ArgumentList (@("-jar", $jarPath) + $analyzeArgs) -PassThru -NoNewWindow -Wait
} else {
    $proc = Start-Process -FilePath $bslLs -ArgumentList $analyzeArgs -PassThru -NoNewWindow -Wait
}

if ($proc.ExitCode -eq 0) {
    Write-Host "Проверка завершена: ошибок не найдено" -ForegroundColor Green
} else {
    Write-Host "Проверка завершена: найдены замечания (код: $($proc.ExitCode))" -ForegroundColor Yellow
    exit $proc.ExitCode
}
