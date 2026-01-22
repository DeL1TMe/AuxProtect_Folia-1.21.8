package dev.heliosares.auxprotect.utils;

import com.comphenix.protocol.ProtocolManager;
import org.bukkit.Location;
import org.bukkit.entity.Player;

import java.io.IOException;
import java.util.UUID;

public class FakePlayer {
    private long lastMoved = System.currentTimeMillis();

    public FakePlayer(String name, ProtocolManager protocol, Player audience) {
    }

    public void spawn(Location location, Skin skin) {
        this.lastMoved = System.currentTimeMillis();
    }

    public void setLocation(Location location, boolean onGround) {
        this.lastMoved = System.currentTimeMillis();
    }

    public void setPosture(PosEncoder.Posture posture) {
        // no-op placeholder
    }

    public void swingArm() {
        // no-op placeholder
    }

    public void remove() {
        // no-op placeholder
    }

    public long getLastMoved() {
        return lastMoved;
    }

    public static Skin getSkin(UUID uuid) throws IOException, InterruptedException {
        return null;
    }

    public record Skin(String value, String signature) {
    }
}
