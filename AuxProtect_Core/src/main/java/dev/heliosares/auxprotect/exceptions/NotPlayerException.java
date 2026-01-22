package dev.heliosares.auxprotect.exceptions;

import dev.heliosares.auxprotect.core.Language.L;

@SuppressWarnings("deprecation")
public class NotPlayerException extends CommandException {
    public NotPlayerException() {
        super(L.NOTPLAYERERROR);
    }
}