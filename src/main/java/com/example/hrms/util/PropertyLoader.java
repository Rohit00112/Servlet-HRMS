package com.example.hrms.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Utility class for loading properties from configuration files
 */
public class PropertyLoader {
    
    /**
     * Loads properties from a specified file
     * 
     * @param filename The name of the properties file to load
     * @return Properties object containing the loaded properties
     * @throws IOException If the file cannot be read
     */
    public static Properties loadProperties(String filename) throws IOException {
        Properties properties = new Properties();
        InputStream inputStream = PropertyLoader.class.getClassLoader().getResourceAsStream(filename);
        
        if (inputStream != null) {
            properties.load(inputStream);
            inputStream.close();
            return properties;
        } else {
            throw new IOException("Unable to find " + filename + " file");
        }
    }
    
    /**
     * Gets a property value from a specified file
     * 
     * @param filename The name of the properties file
     * @param key The property key to retrieve
     * @return The property value or null if not found
     */
    public static String getProperty(String filename, String key) {
        try {
            Properties properties = loadProperties(filename);
            return properties.getProperty(key);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Gets a property value from a specified file with a default value
     * 
     * @param filename The name of the properties file
     * @param key The property key to retrieve
     * @param defaultValue The default value to return if the property is not found
     * @return The property value or the default value if not found
     */
    public static String getProperty(String filename, String key, String defaultValue) {
        try {
            Properties properties = loadProperties(filename);
            return properties.getProperty(key, defaultValue);
        } catch (IOException e) {
            e.printStackTrace();
            return defaultValue;
        }
    }
}
