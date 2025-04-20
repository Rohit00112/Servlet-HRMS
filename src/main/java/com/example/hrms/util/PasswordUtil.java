package com.example.hrms.util;

import at.favre.lib.crypto.bcrypt.BCrypt;

/**
 * Utility class for password operations
 */
public class PasswordUtil {
    
    /**
     * Hash a password using BCrypt
     * 
     * @param password The plain text password
     * @return The hashed password
     */
    public static String hashPassword(String password) {
        return BCrypt.withDefaults().hashToString(12, password.toCharArray());
    }
    
    /**
     * Verify a password against a hash
     * 
     * @param password The plain text password
     * @param hash The hashed password
     * @return True if the password matches the hash
     */
    public static boolean verifyPassword(String password, String hash) {
        return BCrypt.verifyer().verify(password.toCharArray(), hash).verified;
    }
    
    /**
     * Generate a random password
     * 
     * @param length The length of the password
     * @return A random password
     */
    public static String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int index = (int) (Math.random() * chars.length());
            sb.append(chars.charAt(index));
        }
        return sb.toString();
    }
}
