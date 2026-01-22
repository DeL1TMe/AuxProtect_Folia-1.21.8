#!/bin/bash
set -e

echo "======================================"
echo "  AuxProtect Gradle Build Script"
echo "======================================"
echo ""

echo "[1/3] Checking Java..."
if ! command -v java &> /dev/null; then
    echo ""
    echo "[ERROR] Java not found."
    echo "Install Java 16+ from https://adoptium.net/"
    echo ""
    exit 1
fi
echo "[OK] Java found"

echo "[2/3] Checking Gradle..."
GRADLE_CMD="gradle"
if [ -x "./gradlew" ]; then
    GRADLE_CMD="./gradlew"
fi
if ! $GRADLE_CMD -version > /dev/null 2>&1; then
    echo ""
    echo "[ERROR] Gradle not found."
    echo "Install Gradle from https://gradle.org/install/ or add ./gradlew."
    echo ""
    exit 1
fi
echo "[OK] Gradle found"

echo "[3/3] Building..."
echo ""
$GRADLE_CMD clean shadowJar -x test

echo ""
echo "======================================"
echo "[SUCCESS] Build completed!"
echo "======================================"
echo ""
echo "Plugin jar: build/libs/AuxProtect-1.3.4-pre2.jar"
echo ""
