package dev.heliosares.auxprotect.utils;

import dev.heliosares.auxprotect.exceptions.BusyException;

import java.sql.Connection;
import java.sql.SQLException;

@SuppressWarnings("deprecation")
@FunctionalInterface
public interface SQLConsumer {
    void accept(Connection connection) throws SQLException, BusyException;
}
