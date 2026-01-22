@echo off
REM Скрипт для установки Java и Maven на Windows
REM Требует winget (Windows 10/11)

setlocal enabledelayedexpansion

cls
echo ======================================
echo   AuxProtect Build Environment Setup
echo ======================================
echo.

REM Проверка администраторских прав
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Этот скрипт требует администраторских прав!
    echo Пожалуйста, запустите PowerShell как администратор и повторите:
    echo.
    echo   winget install --id Oracle.OpenJDK.21 -e
    echo   winget install --id Apache.Maven -e
    echo.
    pause
    exit /b 1
)

echo [1/4] Проверка наличия winget...
winget --version >nul 2>&1
if !errorlevel! neq 0 (
    echo [ERROR] winget не найден!
    echo Пожалуйста, обновите Windows или установите App Installer.
    pause
    exit /b 1
)
echo [OK] winget найден

echo.
echo [2/4] Установка Java 21...
winget install --id Oracle.OpenJDK.21 -e --accept-package-agreements --accept-source-agreements
if !errorlevel! equ 0 (
    echo [OK] Java установлена
) else (
    echo [WARN] Возможно, Java уже установлена
)

echo.
echo [3/4] Установка Maven...
winget install --id Apache.Maven -e --accept-package-agreements --accept-source-agreements
if !errorlevel! equ 0 (
    echo [OK] Maven установлен
) else (
    echo [WARN] Возможно, Maven уже установлен
)

echo.
echo [4/4] Проверка установки...
powershell -Command "java -version 2>&1"
if !errorlevel! neq 0 (
    echo.
    echo [WARN] Java все еще не найдена в PATH
    echo Возможно потребуется перезагрузка системы
    echo.
)

powershell -Command "mvn -version 2>&1"
if !errorlevel! neq 0 (
    echo.
    echo [WARN] Maven все еще не найден в PATH
    echo Возможно потребуется перезагрузка системы
    echo.
)

echo.
echo ======================================
echo [OK] Установка завершена!
echo ======================================
echo.
echo Если Java и Maven не найдены, перезагрузите систему.
echo.
pause
