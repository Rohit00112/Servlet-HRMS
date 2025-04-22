-- Add password_change_required column to users table
ALTER TABLE users ADD COLUMN IF NOT EXISTS password_change_required BOOLEAN DEFAULT FALSE;

-- Update existing users to not require password change
UPDATE users SET password_change_required = FALSE WHERE password_change_required IS NULL;
