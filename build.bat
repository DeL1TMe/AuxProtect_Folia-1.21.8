@echo off
setlocal enabledelayedexpansion

echo ======================================
echo  AuxProtect Gradle Build Script
echo ======================================
echo.

echo [1/3] Checking Java...
java -version >nul 2>&1
if !errorlevel! neq 0 (
    echo.
    echo [ERROR] Java not found.
    echo Install Java 16+ from https://adoptium.net/
    echo.
    pause
    exit /b 1
)
echo [OK] Java found

echo [2/3] Checking Gradle...
set "GRADLE_CMD=gradle"
if exist gradlew.bat set "GRADLE_CMD=gradlew.bat"
%GRADLE_CMD% -version >nul 2>&1
if !errorlevel! neq 0 (
    echo.
    echo [ERROR] Gradle not found.
    echo Install Gradle from https://gradle.org/install/ or add gradlew.bat.
    echo.
    pause
    exit /b 1
)
echo [OK] Gradle found

echo [3/3] Building...
echo.
%GRADLE_CMD% clean shadowJar -x test

if !errorlevel! equ 0 (
    echo.
    echo ======================================
    echo [SUCCESS] Build completed!
    echo ======================================
    echo.
    echo Plugin jar: build\libs\AuxProtect-1.3.4-pre2.jar
    echo.
    pause
) else (
    echo.
    echo ======================================
    echo [ERROR] Build failed!
    echo ======================================
    echo.
    pause
    exit /b 1
)
