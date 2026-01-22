# AuxProtect Build (Gradle)

## Requirements
- Java 21+
- Gradle (or use `./gradlew` / `gradlew.bat` if present)
- Git

## Quick build
```bash
gradle clean shadowJar -x test
```

Resulting jar:
```
build/libs/AuxProtect-1.3.4-pre2.jar
```

## Install
Copy the jar into your server plugins folder.

Folia 1.21.8:
```bash
cp build/libs/AuxProtect-1.3.4-pre2.jar /path/to/folia/plugins/
```

Spigot/Paper 1.21.x:
```bash
cp build/libs/AuxProtect-1.3.4-pre2.jar /path/to/spigot/plugins/
```

## Troubleshooting
- Dependency download issues:
  ```bash
  gradle clean shadowJar --refresh-dependencies -x test
  ```
- Out of memory:
  ```bash
  export GRADLE_OPTS="-Xmx2g"
  gradle clean shadowJar -x test
  ```
