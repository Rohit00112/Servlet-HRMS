-- Add user_id column to employees table
ALTER TABLE employees ADD COLUMN user_id INT;

-- Add foreign key constraint
ALTER TABLE employees 
ADD CONSTRAINT fk_employee_user 
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL;

-- Create index for faster lookups
CREATE INDEX idx_employee_user_id ON employees(user_id);
