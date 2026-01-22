package dev.heliosares.auxprotect.spigot.utils;

import org.bukkit.Bukkit;
import org.bukkit.Location;
import org.bukkit.entity.Entity;
import org.bukkit.plugin.java.JavaPlugin;

/**
 * Абстракция для работы с планировщиком задач.
 * Поддерживает как обычный Spigot/Paper, так и Folia.
 */
public class SchedulerAdapter {
    
    private static final boolean isFolia = detectFolia();

    private static boolean detectFolia() {
        try {
            Bukkit.class.getMethod("getGlobalRegionScheduler");
            Bukkit.class.getMethod("getAsyncScheduler");
            return true;
        } catch (NoSuchMethodException ignored) {
            return false;
        } catch (Throwable ignored) {
            return false;
        }
    }
    
    public static boolean isFolia() {
        return isFolia;
    }
    
    /**
     * Выполнить асинхронную задачу
     */
    public static void runAsync(JavaPlugin plugin, Runnable task) {
        if (isFolia) {
            Bukkit.getAsyncScheduler().runNow(plugin, (scheduledTask) -> task.run());
            return;
        }
        Bukkit.getScheduler().runTaskAsynchronously(plugin, task);
    }
    
    /**
     * Выполнить синхронную задачу
     */
    public static void runSync(JavaPlugin plugin, Runnable task) {
        if (isFolia) {
            Bukkit.getGlobalRegionScheduler().run(plugin, (scheduledTask) -> task.run());
            return;
        }
        Bukkit.getScheduler().runTask(plugin, task);
    }
    
    /**
     * Выполнить синхронную задачу позже (в тиках)
     */
    public static void runSyncLater(JavaPlugin plugin, Runnable task, long delayTicks) {
        if (isFolia) {
            Bukkit.getGlobalRegionScheduler().runDelayed(plugin, 
                (scheduledTask) -> task.run(), delayTicks);
            return;
        }
        Bukkit.getScheduler().runTaskLater(plugin, task, delayTicks);
    }
    
    /**
     * Выполнить асинхронную задачу позже (в тиках)
     */
    public static void runAsyncLater(JavaPlugin plugin, Runnable task, long delayTicks) {
        if (isFolia) {
            Bukkit.getAsyncScheduler().runDelayed(plugin, 
                (scheduledTask) -> task.run(), delayTicks * 50, java.util.concurrent.TimeUnit.MILLISECONDS);
            return;
        }
        Bukkit.getScheduler().runTaskLaterAsynchronously(plugin, task, delayTicks);
    }
    
    /**
     * Выполнить повторяющуюся синхронную задачу
     */
    public static void runSyncRepeating(JavaPlugin plugin, Runnable task, long delayTicks, long periodTicks) {
        if (isFolia) {
            Bukkit.getGlobalRegionScheduler().runAtFixedRate(plugin, 
                (scheduledTask) -> task.run(), delayTicks, periodTicks);
            return;
        }
        Bukkit.getScheduler().runTaskTimer(plugin, task, delayTicks, periodTicks);
    }
    
    /**
     * Выполнить повторяющуюся асинхронную задачу
     */
    public static void runAsyncRepeating(JavaPlugin plugin, Runnable task, long delayTicks, long periodTicks) {
        if (isFolia) {
            Bukkit.getAsyncScheduler().runAtFixedRate(plugin, 
                (scheduledTask) -> task.run(), delayTicks * 50, periodTicks * 50, java.util.concurrent.TimeUnit.MILLISECONDS);
            return;
        }
        Bukkit.getScheduler().runTaskTimerAsynchronously(plugin, task, delayTicks, periodTicks);
    }
    
    /**
     * Выполнить задачу, привязанную к конкретной сущности
     */
    public static void runAtEntity(JavaPlugin plugin, Entity entity, Runnable task) {
        if (isFolia) {
            entity.getScheduler().run(plugin, (scheduledTask) -> task.run(), null);
        } else {
            task.run();
        }
    }
    
    /**
     * Выполнить задачу, привязанную к конкретной локации
     */
    public static void runAtLocation(JavaPlugin plugin, Location location, Runnable task) {
        if (isFolia) {
            location.getWorld().getChunkAtAsync(location).thenAccept(chunk -> {
                Bukkit.getRegionScheduler().run(plugin, location, (scheduledTask) -> task.run());
            });
        } else {
            task.run();
        }
    }
}
