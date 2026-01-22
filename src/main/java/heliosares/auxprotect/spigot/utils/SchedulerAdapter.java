package dev.heliosares.auxprotect.spigot.utils;

import org.bukkit.Bukkit;
import org.bukkit.plugin.Plugin;
import org.bukkit.scheduler.BukkitTask;

/**
 * Simple scheduler adapter for Bukkit/Spigot compatibility.
 * For Folia servers, use Bukkit.getScheduler() which provides fallback support.
 */
public class SchedulerAdapter {
    
    public static BukkitTask runAsync(Plugin plugin, Runnable run) {
        return Bukkit.getScheduler().runTaskAsynchronously(plugin, run);
    }
    
    public static BukkitTask runSync(Plugin plugin, Runnable run) {
        return Bukkit.getScheduler().runTask(plugin, run);
    }
    
    public static BukkitTask runSyncLater(Plugin plugin, Runnable run, long delayTicks) {
        return Bukkit.getScheduler().runTaskLater(plugin, run, delayTicks);
    }
    
    public static BukkitTask runAsyncRepeating(Plugin plugin, Runnable run, long delayTicks, long periodTicks) {
        return Bukkit.getScheduler().runTaskTimerAsynchronously(plugin, run, delayTicks, periodTicks);
    }
    
    public static BukkitTask runSyncRepeating(Plugin plugin, Runnable run, long delayTicks, long periodTicks) {
        return Bukkit.getScheduler().runTaskTimer(plugin, run, delayTicks, periodTicks);
    }
}
