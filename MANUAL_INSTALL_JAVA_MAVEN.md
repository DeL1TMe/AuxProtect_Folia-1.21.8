# Ручная установка Java и Maven для Windows

Если автоматическая установка не сработала, следуйте этим шагам:

## 1. Скачивание Java 21

### Способ A: Adoptium (рекомендуется)
1. Перейти на https://adoptium.net/
2. Нажать "Latest Release"
3. Выбрать Windows → x64 → MSI
4. Скачать `OpenJDK21U-jdk_x64_windows_hotspot_21.0.1_12.msi`
5. Запустить инсталлер и установить

### Способ B: Oracle Java
1. Перейти на https://www.oracle.com/java/technologies/downloads/
2. Скачать JDK 21
3. Установить

## 2. Скачивание Maven

1. Перейти на https://maven.apache.org/download.cgi
2. Скачать "Binary zip archive" (`apache-maven-3.9.5-bin.zip`)
3. Распаковать в `C:\Program Files\apache-maven-3.9.5`

## 3. Добавление в PATH

### Способ A: Используя PowerShell (как администратор)

```powershell
# Установить переменные окружения
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Eclipse Adoptium\jdk-21.0.1+12", [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable("MAVEN_HOME", "C:\Program Files\apache-maven-3.9.5", [System.EnvironmentVariableTarget]::Machine)

# Добавить в Path
$path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
$newPath = $path + ";C:\Program Files\Eclipse Adoptium\jdk-21.0.1+12\bin;C:\Program Files\apache-maven-3.9.5\bin"
[System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)

# Закрыть и переоткрыть PowerShell
```

### Способ B: Через Settings (графический интерфейс)

1. Нажать Win+X → "System"
2. Нажать "Advanced system settings"
3. Нажать "Environment Variables"
4. Нажать "New" и добавить:
   - Имя: `JAVA_HOME`
   - Значение: `C:\Program Files\Eclipse Adoptium\jdk-21.0.1+12`
5. Нажать "New" и добавить:
   - Имя: `MAVEN_HOME`
   - Значение: `C:\Program Files\apache-maven-3.9.5`
6. Найти переменную `Path`, нажать "Edit"
7. Нажать "New" и добавить: `C:\Program Files\Eclipse Adoptium\jdk-21.0.1+12\bin`
8. Нажать "New" и добавить: `C:\Program Files\apache-maven-3.9.5\bin`
9. Нажать OK везде

## 4. Проверка установки

Закройте PowerShell полностью и откройте заново:

```powershell
java -version
mvn -version
```

## 5. Сборка проекта

```powershell
cd C:\Users\Denis\Downloads\AuxProtect-main
mvn clean package -DskipTests
```

---

## Альтернатива: Использование Scoop (если установлен)

```powershell
scoop install openjdk21
scoop install maven
```

Затем повторите сборку.
