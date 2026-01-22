# 🔧 Установка требуемых инструментов для сборки AuxProtect

## Требования

Для сборки AuxProtect вам нужны:
- **Java 16+**
- **Maven 3.6+**
- **Git** (опционально, если вы еще не клонировали)

## Windows

### 1. Установка Java

#### Вариант A: Adoptium (Рекомендуется)
1. Перейти на https://adoptium.net/
2. Выбрать версию Java 21 (LTS)
3. Нажать "Latest Release"
4. Скачать Windows x64 MSI инсталлер
5. Запустить инсталлер и следовать инструкциям
6. Выбрать "Set JAVA_HOME variable" при установке

#### Вариант B: Oracle Java
1. Перейти на https://www.oracle.com/java/technologies/downloads/
2. Скачать JDK 21
3. Установить

#### Проверка установки Java
```powershell
java -version
```

Должно вывести что-то вроде:
```
openjdk version "21.0.1" 2023-10-17
```

### 2. Установка Maven

1. Перейти на https://maven.apache.org/download.cgi
2. Скачать "Binary zip archive" (apache-maven-3.9.x-bin.zip)
3. Распаковать в удобное место, например: `C:\Program Files\maven`
4. Добавить Maven в PATH:
   - Нажать Win+X → "System"
   - Нажать "Advanced system settings"
   - Нажать "Environment Variables"
   - Под "System variables" нажать "New"
   - Имя переменной: `M2_HOME`
   - Значение: `C:\Program Files\maven`
   - Нажать OK
   - Найти переменную `Path`, нажать "Edit"
   - Нажать "New" и добавить: `C:\Program Files\maven\bin`
   - Нажать OK

5. Закрыть PowerShell полностью (если была открыта)

#### Проверка установки Maven
```powershell
mvn -version
```

Должно вывести что-то вроде:
```
Apache Maven 3.9.5
Maven home: C:\Program Files\maven
Java version: 21.0.1
```

### 3. Сборка проекта

После установки Java и Maven, просто запустите:

```powershell
cd C:\Users\<ВашИмя>\Downloads\AuxProtect-main
build.bat
```

Или вручную:
```powershell
mvn clean package -DskipTests
```

---

## macOS

### 1. Установка Java

#### С использованием Homebrew (рекомендуется)
```bash
# Установить Homebrew если еще не установлен
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Установить Java
brew install openjdk@21
```

#### Или скачать с Adoptium
1. Перейти на https://adoptium.net/
2. Выбрать macOS
3. Скачать и установить

#### Проверка
```bash
java -version
```

### 2. Установка Maven

```bash
brew install maven
```

#### Проверка
```bash
mvn -version
```

### 3. Сборка проекта

```bash
cd ~/Downloads/AuxProtect-main
chmod +x build.sh
./build.sh
```

---

## Linux (Ubuntu/Debian)

### 1. Установка Java

```bash
sudo apt update
sudo apt install openjdk-21-jdk-headless
```

#### Проверка
```bash
java -version
```

### 2. Установка Maven

```bash
sudo apt install maven
```

#### Проверка
```bash
mvn -version
```

### 3. Сборка проекта

```bash
cd ~/Downloads/AuxProtect-main
chmod +x build.sh
./build.sh
```

---

## Linux (Fedora/RHEL/CentOS)

### 1. Установка Java

```bash
sudo dnf install java-21-openjdk-headless
```

### 2. Установка Maven

```bash
sudo dnf install maven
```

### 3. Сборка проекта

```bash
cd ~/Downloads/AuxProtect-main
chmod +x build.sh
./build.sh
```

---

## Проверка установки всего необходимого

Запустите эту команду для полной проверки:

### Windows (PowerShell)
```powershell
java -version; Write-Host ""; mvn -version; Write-Host ""; git --version
```

### macOS/Linux
```bash
java -version && echo "" && mvn -version && echo "" && git --version
```

---

## Решение проблем

### Проблема: "java: command not found"

**Решение:**
- Windows: Перезагрузите PowerShell полностью
- macOS/Linux: Может потребоваться перезагрузка системы

### Проблема: "mvn: command not found"

**Решение:**
- Убедитесь что Maven установлен в PATH
- Windows: Переустановите Maven и убедитесь в PATH переменных
- macOS/Linux: `brew install maven`

### Проблема: Maven скачивает зависимости очень долго

**Решение:**
- Это нормально при первой сборке
- Зависимости кэшируются в `~/.m2/repository`

### Проблема: OutOfMemoryError при сборке

**Решение:**
Установите переменную окружения для Maven:

Windows:
```powershell
$env:MAVEN_OPTS = "-Xmx2g"
mvn clean package -DskipTests
```

macOS/Linux:
```bash
export MAVEN_OPTS="-Xmx2g"
mvn clean package -DskipTests
```

---

## Быстрый старт

После установки всех инструментов:

### Windows
```powershell
cd C:\Users\Denis\Downloads\AuxProtect-main
build.bat
```

### macOS/Linux
```bash
cd ~/Downloads/AuxProtect-main
./build.sh
```

---

## Дополнительные ресурсы

- [Java Adoptium](https://adoptium.net/)
- [Maven Official](https://maven.apache.org/)
- [Java Documentation](https://docs.oracle.com/en/java/)
- [Maven Documentation](https://maven.apache.org/guides/)

---

Если у вас остались вопросы, посмотрите [BUILDING.md](BUILDING.md) для более подробной информации.
