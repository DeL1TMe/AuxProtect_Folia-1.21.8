# PowerShell скрипт для автоматической установки и добавления в PATH

param(
    [switch]$SkipDownload = $false
)

Write-Host "======================================"
Write-Host "  Advanced Build Environment Setup"
Write-Host "======================================"
Write-Host ""

# Проверка администраторских прав
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[ERROR] Этот скрипт требует администраторских прав!" -ForegroundColor Red
    Write-Host "Пожалуйста, нажмите правой кнопкой на PowerShell и выберите 'Run as administrator'" -ForegroundColor Yellow
    Read-Host "Нажмите Enter для выхода"
    exit 1
}

# Функция для скачивания файла
function Download-File {
    param([string]$url, [string]$output)
    
    Write-Host "[*] Скачивание $output..."
    try {
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $url -OutFile $output
        Write-Host "[OK] Скачан: $output" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "[ERROR] Ошибка скачивания: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Функция для распаковки ZIP
function Extract-ZIP {
    param([string]$source, [string]$destination)
    
    Write-Host "[*] Распаковка $source..."
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($source, $destination)
        Write-Host "[OK] Распакован: $destination" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "[ERROR] Ошибка распаковки: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Функция для добавления в PATH
function Add-ToPath {
    param([string]$pathToAdd)
    
    Write-Host "[*] Добавление в PATH: $pathToAdd"
    
    $currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    if ($currentPath -notlike "*$pathToAdd*") {
        $newPath = $currentPath + ";" + $pathToAdd
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
        Write-Host "[OK] Добавлено в PATH" -ForegroundColor Green
        return $true
    } else {
        Write-Host "[WARN] Уже в PATH" -ForegroundColor Yellow
        return $false
    }
}

$tempDir = "$env:TEMP\auxprotect-build-tools"
$programFilesDir = "C:\Program Files"

# Создать временную директорию
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# Сценарий 1: Попытка установки через winget
Write-Host "[1/4] Попытка установки через winget..."
$wingetExists = $null -ne (Get-Command winget -ErrorAction SilentlyContinue)

if ($wingetExists) {
    Write-Host "[*] winget найден, установка Java 21..."
    & winget install --id Oracle.OpenJDK.21 -e --accept-package-agreements --accept-source-agreements 2>&1 | Out-Null
    
    Write-Host "[*] Установка Maven..."
    & winget install --id Apache.Maven -e --accept-package-agreements --accept-source-agreements 2>&1 | Out-Null
    
    Start-Sleep -Seconds 5
} else {
    Write-Host "[WARN] winget не найден" -ForegroundColor Yellow
}

# Сценарий 2: Проверка Java в стандартных местах
Write-Host ""
Write-Host "[2/4] Поиск установленной Java..."

$javaPath = $null
$javaPaths = @(
    "C:\Program Files\Eclipse Adoptium\*\bin",
    "C:\Program Files\OpenJDK\*\bin",
    "C:\Program Files\Java\*\bin",
    "$env:ProgramFiles\OpenJDK\*\bin"
)

foreach ($pattern in $javaPaths) {
    $found = Get-Item -Path $pattern -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        $javaPath = $found.FullName
        Write-Host "[OK] Java найдена: $javaPath" -ForegroundColor Green
        Add-ToPath $javaPath
        break
    }
}

if (-not $javaPath) {
    Write-Host "[WARN] Java не найдена в стандартных местах" -ForegroundColor Yellow
}

# Сценарий 3: Поиск Maven
Write-Host ""
Write-Host "[3/4] Поиск установленного Maven..."

$mavenPath = $null
$mavenPaths = @(
    "C:\Program Files\apache-maven*\bin",
    "C:\Program Files\Maven\bin",
    "$env:ProgramFiles\apache-maven*\bin"
)

foreach ($pattern in $mavenPaths) {
    $found = Get-Item -Path $pattern -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        $mavenPath = $found.FullName
        Write-Host "[OK] Maven найден: $mavenPath" -ForegroundColor Green
        Add-ToPath $mavenPath
        break
    }
}

if (-not $mavenPath) {
    Write-Host "[WARN] Maven не найден в стандартных местах" -ForegroundColor Yellow
}

# Сценарий 4: Проверка в новом процессе
Write-Host ""
Write-Host "[4/4] Проверка установки..."

$javaCheck = & powershell -NoProfile -Command {
    try {
        $output = & java -version 2>&1
        return "OK"
    } catch {
        return "FAIL"
    }
}

$mvnCheck = & powershell -NoProfile -Command {
    try {
        $output = & mvn -version 2>&1
        return "OK"
    } catch {
        return "FAIL"
    }
}

Write-Host ""
Write-Host "======================================"
Write-Host "  Результат установки:"
Write-Host "======================================"
Write-Host ""

if ($javaCheck -eq "OK") {
    Write-Host "[OK] Java установлена и в PATH" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Java не найдена в PATH" -ForegroundColor Red
    Write-Host "      Может потребоваться перезагрузка системы" -ForegroundColor Yellow
}

if ($mvnCheck -eq "OK") {
    Write-Host "[OK] Maven установлена и в PATH" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Maven не найдена в PATH" -ForegroundColor Red
    Write-Host "      Может потребоваться перезагрузка системы" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Инструкции для ручной установки: MANUAL_INSTALL_JAVA_MAVEN.md" -ForegroundColor Cyan
Write-Host ""

# Очистка
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue

Read-Host "Нажмите Enter для выхода"
