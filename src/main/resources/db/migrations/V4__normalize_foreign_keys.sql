ALTER TABLE IF EXISTS leaves DROP CONSTRAINT IF EXISTS leaves_employee_id_fkey;
ALTER TABLE IF EXISTS leaves DROP CONSTRAINT IF EXISTS leaves_reviewed_by_fkey;
ALTER TABLE IF EXISTS attendance DROP CONSTRAINT IF EXISTS attendance_employee_id_fkey;
ALTER TABLE IF EXISTS payroll DROP CONSTRAINT IF EXISTS payroll_employee_id_fkey;
ALTER TABLE IF EXISTS notifications DROP CONSTRAINT IF EXISTS notifications_employee_id_fkey;
ALTER TABLE IF EXISTS user_activities DROP CONSTRAINT IF EXISTS user_activities_user_id_fkey;
ALTER TABLE IF EXISTS employees DROP CONSTRAINT IF EXISTS employees_department_id_fkey;
ALTER TABLE IF EXISTS employees DROP CONSTRAINT IF EXISTS employees_designation_id_fkey;
ALTER TABLE IF EXISTS employees DROP CONSTRAINT IF EXISTS employees_user_id_fkey;
ALTER TABLE IF EXISTS employees DROP CONSTRAINT IF EXISTS fk_employee_user;

ALTER TABLE leaves
    ADD CONSTRAINT leaves_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE;
ALTER TABLE leaves
    ADD CONSTRAINT leaves_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES users(id) ON DELETE SET NULL;
ALTER TABLE attendance
    ADD CONSTRAINT attendance_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE;
ALTER TABLE payroll
    ADD CONSTRAINT payroll_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE;
ALTER TABLE notifications
    ADD CONSTRAINT notifications_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE;
ALTER TABLE user_activities
    ADD CONSTRAINT user_activities_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE employees
    ADD CONSTRAINT employees_department_id_fkey FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL;
ALTER TABLE employees
    ADD CONSTRAINT employees_designation_id_fkey FOREIGN KEY (designation_id) REFERENCES designations(id) ON DELETE SET NULL;
ALTER TABLE employees
    ADD CONSTRAINT employees_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL;
