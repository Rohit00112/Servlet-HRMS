-- Script to add ON DELETE CASCADE constraints to foreign keys

-- First, drop existing foreign key constraints
ALTER TABLE IF EXISTS leaves DROP CONSTRAINT IF EXISTS leaves_employee_id_fkey;
ALTER TABLE IF EXISTS leaves DROP CONSTRAINT IF EXISTS leaves_reviewed_by_fkey;
ALTER TABLE IF EXISTS attendance DROP CONSTRAINT IF EXISTS attendance_employee_id_fkey;
ALTER TABLE IF EXISTS payroll DROP CONSTRAINT IF EXISTS payroll_employee_id_fkey;
ALTER TABLE IF EXISTS employees DROP CONSTRAINT IF EXISTS employees_department_id_fkey;
ALTER TABLE IF EXISTS employees DROP CONSTRAINT IF EXISTS employees_designation_id_fkey;

-- Re-add constraints with ON DELETE CASCADE or ON DELETE SET NULL as appropriate

-- When an employee is deleted, all their leaves should be deleted
ALTER TABLE leaves
ADD CONSTRAINT leaves_employee_id_fkey
FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE;

-- When a user (reviewer) is deleted, set reviewed_by to NULL
ALTER TABLE leaves
ADD CONSTRAINT leaves_reviewed_by_fkey
FOREIGN KEY (reviewed_by) REFERENCES users(id) ON DELETE SET NULL;

-- When an employee is deleted, all their attendance records should be deleted
ALTER TABLE attendance
ADD CONSTRAINT attendance_employee_id_fkey
FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE;

-- When an employee is deleted, all their payroll records should be deleted
ALTER TABLE payroll
ADD CONSTRAINT payroll_employee_id_fkey
FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE;

-- When a department is deleted, set department_id to NULL for affected employees
ALTER TABLE employees
ADD CONSTRAINT employees_department_id_fkey
FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL;

-- When a designation is deleted, set designation_id to NULL for affected employees
ALTER TABLE employees
ADD CONSTRAINT employees_designation_id_fkey
FOREIGN KEY (designation_id) REFERENCES designations(id) ON DELETE SET NULL;

-- Note: The user_id in employees table already has ON DELETE SET NULL from db_update.sql
