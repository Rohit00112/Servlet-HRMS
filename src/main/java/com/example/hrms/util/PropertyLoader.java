package com.example.hrms.util;

import java.io.IOException;
import java.util.Properties;

/**
 * Backward-compatible facade. New code should use com.example.hrms.shared.util.PropertyLoader.
 */
public final class PropertyLoader {

    private PropertyLoader() {
    }

    public static Properties loadProperties(String filename) throws IOException {
        return com.example.hrms.shared.util.PropertyLoader.loadProperties(filename);
    }

    public static String getProperty(String filename, String key) {
        return com.example.hrms.shared.util.PropertyLoader.getProperty(filename, key);
    }

    public static String getProperty(String filename, String key, String defaultValue) {
        return com.example.hrms.shared.util.PropertyLoader.getProperty(filename, key, defaultValue);
    }
}
