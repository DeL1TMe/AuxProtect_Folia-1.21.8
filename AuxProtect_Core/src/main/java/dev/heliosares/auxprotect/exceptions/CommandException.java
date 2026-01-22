package dev.heliosares.auxprotect.exceptions;

import dev.heliosares.auxprotect.core.Language.L;

@SuppressWarnings("deprecation")
public class CommandException extends AuxProtectException {
    public CommandException(L l, Object... format) {
        super(l, format);
    }
}
