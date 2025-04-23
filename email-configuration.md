# Email Notification Configuration for HRMS

This document provides instructions for configuring email notifications in the HRMS system.

## Configuration Options

There are two ways to configure email settings in the HRMS system:

### Option 1: Using Environment Variables (Recommended)

For security reasons, it's recommended to use environment variables for sensitive information like email credentials. The system will look for environment variables in the following format:

```
HRMS_MAIL_USERNAME=your-email@gmail.com
HRMS_MAIL_PASSWORD=your-app-password
HRMS_MAIL_FROM=HRMS System <your-email@gmail.com>
HRMS_MAIL_ENABLED=true
```

To set these environment variables:

- **On Windows**:
  ```
  set HRMS_MAIL_USERNAME=your-email@gmail.com
  set HRMS_MAIL_PASSWORD=your-app-password
  ```

- **On Linux/Mac**:
  ```
  export HRMS_MAIL_USERNAME=your-email@gmail.com
  export HRMS_MAIL_PASSWORD=your-app-password
  ```

### Option 2: Using Properties File

1. Copy the `db.properties.template` file to `db.properties` in the `src/main/resources` directory.

2. Update the following email configuration properties:

```properties
# Email Configuration
mail.smtp.host=smtp.gmail.com
mail.smtp.port=587
mail.smtp.auth=true
mail.smtp.starttls.enable=true
mail.username=your-email@gmail.com
mail.password=your-app-password
mail.from=HRMS System <your-email@gmail.com>
mail.reply-to=no-reply@hrms.com
mail.enabled=true
```

> **IMPORTANT**: The `db.properties` file is excluded from version control for security reasons. Never commit this file with your credentials.

3. Replace the placeholder values with your actual email configuration:
   - `mail.smtp.host`: Your SMTP server hostname (e.g., smtp.gmail.com for Gmail)
   - `mail.smtp.port`: Your SMTP server port (typically 587 for TLS or 465 for SSL)
   - `mail.username`: Your email address
   - `mail.password`: Your email password or app password (for Gmail, you'll need to generate an app password)
   - `mail.from`: The sender name and email address
   - `mail.reply-to`: The reply-to email address

4. Set `mail.enabled=true` to enable email notifications. If set to `false`, emails will be logged but not sent.

## Using Gmail for Email Notifications

If you're using Gmail as your SMTP server, follow these additional steps:

1. Enable 2-Step Verification for your Google account.
2. Generate an App Password:
   - Go to your Google Account settings
   - Select "Security"
   - Under "Signing in to Google," select "App passwords"
   - Generate a new app password for "Mail" and "Other (Custom name)"
   - Use this generated password as the `mail.password` value in your configuration

## Testing Email Configuration

To test your email configuration:

1. Set `mail.enabled=true` in the `db.properties` file.
2. Run the `EmailTest` class located in the `com.example.hrms.util` package.
3. Check the console output to verify that the emails were sent successfully.

## Email Notification Types

The HRMS system currently supports the following email notification types:

1. **Leave Status Notifications**: Sent when a leave request is approved or rejected.
2. **Payslip Notifications**: Sent when a payslip is finalized.

## Troubleshooting

If you encounter issues with email notifications:

1. Check that `mail.enabled` is set to `true`.
2. Verify your SMTP server settings.
3. If using Gmail, ensure you're using an app password, not your regular account password.
4. Check your firewall settings to ensure it's not blocking outgoing SMTP connections.
5. Review the application logs for any error messages related to email sending.

## Security Considerations

- Never commit your email password to version control.
- Consider using environment variables or a secure vault for storing sensitive credentials.
- Regularly rotate your app passwords for enhanced security.
