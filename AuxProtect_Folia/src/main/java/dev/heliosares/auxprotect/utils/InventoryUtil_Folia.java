package dev.heliosares.auxprotect.utils;

import org.bukkit.entity.HumanEntity;
import org.bukkit.inventory.Inventory;

public class InventoryUtil_Folia {
    public static Inventory getTopInventory(HumanEntity player) {
        return player.getOpenInventory().getTopInventory();
    }
}
