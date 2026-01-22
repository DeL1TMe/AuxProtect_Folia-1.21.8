# Скрипт PowerShell для установки Java и Maven
# Запустить: powershell -ExecutionPolicy Bypass -File install-build-tools.ps1

Write-Host "======================================"
Write-Host "  AuxProtect Build Environment Setup"
Write-Host "======================================"
Write-Host ""

# Проверка администраторских прав
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[ERROR] Этот скрипт требует администраторских прав!" -ForegroundColor Red
    Write-Host "Пожалуйста, запустите PowerShell как администратор и повторите." -ForegroundColor Yellow
    Read-Host "Нажмите Enter для выхода"
    exit 1
}

# Функция для установки через winget
function Install-WithWinget {
    param([string]$id, [string]$name)
    
    Write-Host "[*] Установка $name через winget..."
    & winget install --id $id -e --accept-package-agreements --accept-source-agreements 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq -1978335189) {
        Write-Host "[OK] $name установлена" -ForegroundColor Green
        return $true
    } else {
        Write-Host "[WARN] Возможно, $name уже установлена" -ForegroundColor Yellow
        return $false
    }
}

# Проверка и установка Java
Write-Host "[1/3] Проверка/Установка Java 21..."
$javaExists = $null -ne (Get-Command java -ErrorAction SilentlyContinue)

if (-not $javaExists) {
    Install-WithWinget "Oracle.OpenJDK.21" "Java 21"
} else {
    Write-Host "[OK] Java уже установлена" -ForegroundColor Green
}

# Проверка и установка Maven
Write-Host ""
Write-Host "[2/3] Проверка/Установка Maven..."
$mvnExists = $null -ne (Get-Command mvn -ErrorAction SilentlyContinue)

if (-not $mvnExists) {
    Install-WithWinget "Apache.Maven" "Maven"
} else {
    Write-Host "[OK] Maven уже установлена" -ForegroundColor Green
}

# Проверка установки
Write-Host ""
Write-Host "[3/3] Проверка установки..."

$javaVersion = $null
try {
    $javaVersion = & java -version 2>&1 | Select-Object -First 1
    Write-Host "[OK] Java: $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "[WARN] Java не найдена в PATH" -ForegroundColor Yellow
}

$mvnVersion = $null
try {
    $mvnVersion = & mvn -version 2>&1 | Select-Object -First 1
    Write-Host "[OK] Maven: $mvnVersion" -ForegroundColor Green
} catch {
    Write-Host "[WARN] Maven не найдена в PATH" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "======================================"
Write-Host "[OK] Установка завершена!" -ForegroundColor Green
Write-Host "======================================"
Write-Host ""

if ($null -eq $javaVersion -or $null -eq $mvnVersion) {
    Write-Host "[INFO] Если Java или Maven не найдены, может потребоваться перезагрузка системы." -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "Теперь вы можете запустить сборку:"
Write-Host "  cd $PSScriptRoot"
Write-Host "  mvn clean package -DskipTests"
Write-Host ""

Read-Host "Нажмите Enter для выхода"
