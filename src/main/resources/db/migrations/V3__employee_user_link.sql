ALTER TABLE employees ADD COLUMN IF NOT EXISTS user_id INTEGER;
UPDATE employees
SET user_id = NULL
WHERE user_id IS NOT NULL
  AND user_id NOT IN (SELECT id FROM users);

CREATE INDEX IF NOT EXISTS idx_employee_user_id ON employees(user_id);
