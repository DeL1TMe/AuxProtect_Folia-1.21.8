# AuxProtect Folia 1.21.8 - Адаптация

Этот документ описывает все изменения, внесенные для поддержки Folia 1.21.8.

## Обзор изменений

AuxProtect был переписан для поддержки Folia 1.21.8 - современной версии Paper, которая использует многопоточный региональный планировщик задач вместо традиционного однопоточного tick loop Spigot/Paper.

## Основные изменения

### 1. Новый модуль: `AuxProtect_Folia`
- **Расположение**: `AuxProtect_Folia/`
- **Назначение**: Поддержка Folia 1.21.8
- **Зависимости**: `io.papermc.folia:folia-api:1.21.8-R0.1-SNAPSHOT`
- **Файлы**:
  - `pom.xml` - конфигурация Maven для модуля
  - `src/main/java/dev/heliosares/auxprotect/utils/InventoryUtil_Folia.java` - утилиты для работы с инвентарем

### 2. SchedulerAdapter - Абстракция для планировщика задач
**Файл**: `AuxProtect_Core/src/main/java/dev/heliosares/auxprotect/spigot/utils/SchedulerAdapter.java`

Это ключевой компонент, который обеспечивает совместимость с обоими серверами (Spigot и Folia).

#### Основные методы:

```java
// Синхронное выполнение
SchedulerAdapter.runSync(plugin, runnable);

// Асинхронное выполнение
SchedulerAdapter.runAsync(plugin, runnable);

// Синхронное выполнение с задержкой (в тиках)
SchedulerAdapter.runSyncLater(plugin, runnable, delayTicks);

// Асинхронное выполнение с задержкой
SchedulerAdapter.runAsyncLater(plugin, runnable, delayTicks);

// Повторяющееся синхронное выполнение
SchedulerAdapter.runSyncRepeating(plugin, runnable, delayTicks, periodTicks);

// Повторяющееся асинхронное выполнение
SchedulerAdapter.runAsyncRepeating(plugin, runnable, delayTicks, periodTicks);

// Выполнение, привязанное к локации
SchedulerAdapter.runAtLocation(plugin, location, runnable);

// Выполнение, привязанное к сущности
SchedulerAdapter.runAtEntity(plugin, entity, runnable);

// Проверка, является ли сервер Folia
SchedulerAdapter.isFolia();
```

### 3. Обновленные файлы

Все файлы, использующие `BukkitScheduler`, были обновлены для использования `SchedulerAdapter`:

#### Основные файлы:

1. **AuxProtectSpigot.java**
   - Заменены все `BukkitRunnable` на lambda-функции с `SchedulerAdapter`
   - Методы `runAsync()` и `runSync()` используют `SchedulerAdapter`
   - Добавлены приватные методы для периодических задач

2. **PlayerListener.java**
   - Все вызовы scheduler переписаны
   - Удалена зависимость от `BukkitRunnable`

3. **WorldListener.java**
   - Обновлены вызовы для raid события

4. **VeinListener.java**
   - Переписаны асинхронные задачи

5. **EntityListener.java**
   - Обновлены отложенные задачи

6. **InvCommand.java**
   - Обновлены вызовы scheduler

7. **SpigotSenderAdapter.java**
   - Переписаны асинхронные операции

8. **TownyManager.java**
   - Обновлены асинхронные вызовы

9. **Metrics.java**
   - Переписаны синхронные вызовы

## Архитектура решения

```
┌─────────────────────────────────────┐
│  AuxProtectSpigot (плагин)          │
├─────────────────────────────────────┤
│  Все компоненты используют:         │
│  - SchedulerAdapter.runXXX()        │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  SchedulerAdapter                   │
├─────────────────────────────────────┤
│  Проверяет тип сервера:            │
│  - isFolia() == true  → Folia API  │
│  - isFolia() == false → Bukkit API │
└──────────┬──────────────────────────┘
           │
   ┌───────┴────────┐
   ▼                ▼
┌──────────────┐  ┌──────────────┐
│ Folia API    │  │ Bukkit API   │
├──────────────┤  ├──────────────┤
│AsyncScheduler│  │BukkitScheduler
│GlobalRegion  │  │Task methods  │
│Scheduler     │  └──────────────┘
└──────────────┘
```

## Преимущества Folia

1. **Многопоточность**: Каждый регион имеет свой поток
2. **Масштабируемость**: Лучше использует многоядерные процессоры
3. **Производительность**: Уменьшенная задержка для операций

## Обратная совместимость

SchedulerAdapter автоматически определяет, работает ли плагин на Folia или Spigot, поэтому **один бинарник JAR файла работает на обоих серверах** без каких-либо проблем.

## Сборка проекта

```bash
mvn clean package
```

Это создаст файл `AuxProtect-1.3.4-pre2.jar`, который работает как на Spigot, так и на Folia 1.21.8.

## Тестирование

Для тестирования на Folia:
1. Скачайте Folia 1.21.8 с [papermc.io](https://papermc.io)
2. Поместите JAR файл в папку `plugins`
3. Перезагрузите сервер

## Нюансы при разработке для Folia

1. **Завис операции**: Избегайте `runTask()` на сущностях в другом регионе - используйте `runAtEntity()` вместо этого
2. **Локации**: Работа с разными локациями требует использования `runAtLocation()`
3. **Таймеры**: Задержки указываются в тиках (20 тиков = 1 секунда)

## Версионность

- **AuxProtect версия**: 1.3.4-pre2
- **Поддержка Minecraft**: 1.21.8
- **Поддерживаемые серверы**:
  - Folia 1.21.8
  - Paper 1.21.x
  - Spigot 1.21.x

## Направления развития

Возможные улучшения:
1. Оптимизация для использования регионального scheduler для локационных операций
2. Добавление поддержки для более новых версий Minecraft
3. Оптимизация обработки событий для многопоточной архитектуры

## Контакты и поддержка

Если у вас возникнут проблемы с работой плагина на Folia, создайте issue на GitHub с описанием проблемы и логами сервера.
