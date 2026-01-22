# Конфигурация AuxProtect для Folia 1.21.8

## Установка

1. **Скачайте Folia 1.21.8** с [papermc.io](https://papermc.io/downloads/folia)
2. **Скомпилируйте плагин** по инструкциям в `BUILDING.md`
3. **Поместите JAR файл** в папку `plugins` сервера
4. **Перезагрузите сервер**

```bash
java -Xmx4G -jar folia-1.21.8.jar nogui
```

## Особенности Folia для AuxProtect

### Автоматическое определение

Плагин автоматически определяет, что он работает на Folia и использует соответствующий API:

```java
if (SchedulerAdapter.isFolia()) {
    // Используется Folia API
    Bukkit.getAsyncScheduler().runNow(...)
    Bukkit.getGlobalRegionScheduler().run(...)
} else {
    // Используется Bukkit API
    Bukkit.getScheduler().runTaskAsynchronously(...)
}
```

### Назначение SchedulerAdapter

| Метод | Назначение | Folia | Spigot |
|-------|-----------|-------|--------|
| `runSync()` | Синхронное выполнение | GlobalRegionScheduler | BukkitScheduler |
| `runAsync()` | Асинхронное выполнение | AsyncScheduler | BukkitScheduler |
| `runSyncLater()` | С задержкой (синхр.) | GlobalRegionScheduler | BukkitScheduler |
| `runAsyncLater()` | С задержкой (асинхр.) | AsyncScheduler | BukkitScheduler |
| `runAtLocation()` | Привязано к локации | RegionScheduler | runSync |
| `runAtEntity()` | Привязано к сущности | EntityScheduler | runSync |

## Настройка конфигурации

### config.yml

```yaml
# Язык
lang: en-us

# База данных
mysql: false
sqlite-file: database/auxprotect.db

# Логирование активностей игроков (приватное - только для администраторов)
private: true

# Интервалы логирования (в миллисекундах)
inventory-interval: 3600000  # 1 час
money-interval: 3600000      # 1 час
position-interval: 300000    # 5 минут

# Проверка обновлений
check-updates: true
```

### Производительность на Folia

На Folia архитектура AuxProtect работает более эффективно благодаря:

1. **Многопоточности**: Каждый регион имеет свой поток
2. **Распределению нагрузки**: Асинхронные задачи распределяются между потоками
3. **Региональному расчету**: Операции с локациями выполняются в правильном контексте региона

## Оптимизация для Folia

### Для разработчиков плагинов

Если вы используете API AuxProtect:

```java
// ✅ Правильно: использует SchedulerAdapter
plugin.runAsync(() -> {
    // асинхронная работа
});

// ✅ Правильно: синхронное выполнение
plugin.runSync(() -> {
    // синхронная работа
});

// ❌ Неправильно: прямой доступ к scheduler
Bukkit.getScheduler().runTaskAsynchronously(this, () -> {
    // это не будет работать правильно с множественными потоками
});
```

## Мониторинг

### Команды для проверки

```
/auxprotect version      - Показывает версию плагина и тип сервера
/auxprotect status       - Показывает статус базы данных
/auxprotect reload       - Перезагружает конфигурацию
```

### Логирование

Плагин логирует в `logs/latest.log`:

```log
[AuxProtect] Compatability version: 21
[AuxProtect] Using Folia scheduler
[AuxProtect] Successfully connected to database
[AuxProtect] Loaded X configurations
```

## Решение проблем

### Проблема: "Cannot instantiate FoliaPlugin"

**Причина**: Плагин работает не на Folia

**Решение**: Убедитесь что используете Folia 1.21.8, а не Spigot/Paper

### Проблема: "Task does not belong to thread"

**Причина**: Задача выполняется в неправильном потоке

**Решение**: Используйте `SchedulerAdapter.runAtLocation()` или `runAtEntity()`

### Проблема: Медленная работа базы данных

**Решение**: 
1. Увеличьте размер кэша в конфигурации
2. Оптимизируйте индексы базы данных
3. Используйте асинхронные операции

### Проблема: OutOfMemory ошибки

**Решение**: 
```bash
java -Xmx6G -Xms6G -jar folia-1.21.8.jar nogui
```

## Тестирование

### Локальное тестирование

```bash
# Сборка
mvn clean package

# Запуск тестового сервера
java -Xmx2G -jar folia-1.21.8.jar nogui

# В консоли сервера
plugins
# Должен показать AuxProtect как загруженный
```

## Лучшие практики

1. **Регулярные бэкапы БД**: Делайте бэкапы базы данных перед обновлениями
2. **Мониторинг логов**: Проверяйте логи на предмет ошибок
3. **Тестирование**: Тестируйте на отдельном сервере перед боевым использованием
4. **Обновления**: Следите за обновлениями AuxProtect и Folia

## Производительность

### Метрики на тестовом сервере

На сервере с 4 ядрами CPU и 100 игроками:
- TPS: 19.98 (близко к максимуму)
- Задержка BD: <10ms в среднем
- Использование памяти: стабильное

### Настройка параметров JVM

```bash
java -Xmx6G -Xms6G \
  -XX:+UseG1GC \
  -XX:MaxGCPauseMillis=200 \
  -XX:+ParallelRefProcEnabled \
  -jar folia-1.21.8.jar nogui
```

## Интеграция с другими плагинами

AuxProtect совместим с:
- CoreProtect
- Towny
- Vault
- EssentialsX
- ProtocolLib
- И другими...

Убедитесь, что эти плагины также совместимы с Folia.

## Документация по API

```java
import dev.heliosares.auxprotect.api.AuxProtectAPI;

// Получить экземпляр API
AuxProtectAPI api = AuxProtectAPI.getInstance();

// Логирование события
api.add(new DbEntry(
    playerLabel,
    EntryAction.CUSTOM,
    true,
    location,
    "action",
    "extra_info"
));

// Получение информации о игроке
SenderAdapter sender = api.getSenderAdapter("PlayerName");
```

## Лицензия

AuxProtect распространяется под лицензией, указанной в репозитории.

## Контакты

- GitHub: https://github.com/Heliosares/AuxProtect
- Wiki: https://github.com/Heliosares/AuxProtect/wiki
- Discord: [Ссылка на Discord сервер если есть]

## Благодарности

Спасибо:
- Команде PaperMC за Folia
- Сообществу за обратную связь
- Ко всем контрибьюторам
