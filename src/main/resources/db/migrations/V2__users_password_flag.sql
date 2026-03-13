ALTER TABLE users ADD COLUMN IF NOT EXISTS password_change_required BOOLEAN DEFAULT FALSE;
UPDATE users SET password_change_required = FALSE WHERE password_change_required IS NULL;
