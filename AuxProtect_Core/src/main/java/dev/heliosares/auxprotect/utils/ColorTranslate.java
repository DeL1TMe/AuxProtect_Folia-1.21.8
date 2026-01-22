// 
// Decompiled by Procyon v0.5.36
// 

package dev.heliosares.auxprotect.utils;

import net.md_5.bungee.api.ChatColor;

@SuppressWarnings("deprecation")
public class ColorTranslate {
    public static String cc(final String msg) {
        return ChatColor.translateAlternateColorCodes('&', msg);
    }
}
