package com.example.hrms.shared.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;
import java.util.Properties;

/**
 * Utility class for loading properties from configuration files.
 */
public final class PropertyLoader {

    private PropertyLoader() {
    }

    public static Properties loadProperties(String filename) throws IOException {
        Properties properties = new Properties();
        try (InputStream inputStream = PropertyLoader.class.getClassLoader().getResourceAsStream(filename)) {
            if (inputStream == null) {
                throw new IOException("Unable to find " + filename + " file");
            }

            properties.load(inputStream);
            overrideWithEnvironmentVariables(properties);
            return properties;
        }
    }

    private static void overrideWithEnvironmentVariables(Properties properties) {
        Map<String, String> env = System.getenv();

        for (String key : properties.stringPropertyNames()) {
            String envKey = "HRMS_" + key.toUpperCase().replace('.', '_');
            if (env.containsKey(envKey)) {
                properties.setProperty(key, env.get(envKey));
            }
        }
    }

    public static String getProperty(String filename, String key) {
        try {
            return loadProperties(filename).getProperty(key);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String getProperty(String filename, String key, String defaultValue) {
        try {
            return loadProperties(filename).getProperty(key, defaultValue);
        } catch (IOException e) {
            e.printStackTrace();
            return defaultValue;
        }
    }
}
