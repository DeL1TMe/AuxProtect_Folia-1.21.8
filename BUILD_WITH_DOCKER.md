# Использование Docker для сборки AuxProtect

Если на вашей системе установлен Docker, вы можете собрать проект без установки Java и Maven!

## Быстрая сборка с Docker

```bash
cd C:\Users\Denis\Downloads\AuxProtect-main
docker run -it --rm -v %cd%:/workspace -w /workspace maven:3.9-eclipse-temurin-21 mvn clean package -DskipTests
```

## На macOS/Linux

```bash
cd ~/Downloads/AuxProtect-main
docker run -it --rm -v $(pwd):/workspace -w /workspace maven:3.9-eclipse-temurin-21 mvn clean package -DskipTests
```

## Что происходит

Docker контейнер с Maven и Java 21:
1. Скачивается образ `maven:3.9-eclipse-temurin-21`
2. Запускается контейнер с исходными кодами
3. Выполняется `mvn clean package -DskipTests`
4. JAR файл сохраняется в `AuxProtect_Core/target/`

## Если Docker не установлен

Установить Docker можно:
- Windows/Mac: https://www.docker.com/products/docker-desktop
- Linux: `sudo apt install docker.io`

## Преимущества использования Docker

✅ Не нужно устанавливать Java и Maven  
✅ Всегда свежая версия инструментов  
✅ Одна команда для сборки  
✅ Изолированная среда сборки  

## Выполнение после установки Java

Если вы установили Java и Maven через `install-build-tools.ps1`, просто выполните:

```bash
cd C:\Users\Denis\Downloads\AuxProtect-main
mvn clean package -DskipTests
```
