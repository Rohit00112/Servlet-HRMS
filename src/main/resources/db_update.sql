-- Add user_id column to employees table
ALTER TABLE employees ADD COLUMN IF NOT EXISTS user_id INT;

-- Add foreign key constraint
ALTER TABLE employees DROP CONSTRAINT IF EXISTS fk_employee_user;
ALTER TABLE employees DROP CONSTRAINT IF EXISTS employees_user_id_fkey;
ALTER TABLE employees
ADD CONSTRAINT employees_user_id_fkey
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL;

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_employee_user_id ON employees(user_id);
