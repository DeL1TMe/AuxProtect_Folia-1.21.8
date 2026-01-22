package dev.heliosares.auxprotect.exceptions;

import dev.heliosares.auxprotect.core.Language.L;

@SuppressWarnings("deprecation")
public class LookupException extends AuxProtectException {
    public LookupException(L l, Object... format) {
        super(l, format);
    }
}