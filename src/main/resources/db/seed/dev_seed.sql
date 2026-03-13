INSERT INTO users (username, password_hash, role, password_change_required)
VALUES ('hr', '$2a$12$PDt1yFq6SZf.41kzWM.CF.Dg7OpBGUPcQCQZfEumSMLvsawVCDvtG', 'HR', FALSE)
ON CONFLICT (username) DO NOTHING;

INSERT INTO users (username, password_hash, role, password_change_required)
VALUES ('employee', '$2a$12$A4wkihFBbYSvV3ysKhZnN.kc6iOSFBDPvNvgVQvMR5i5yK2pZcCOS', 'EMPLOYEE', FALSE)
ON CONFLICT (username) DO NOTHING;

INSERT INTO employees (name, email, department_id, designation_id, join_date, user_id)
SELECT 'HR Manager', 'hr@company.com', 1, 1, CURRENT_DATE, u.id
FROM users u
WHERE u.username = 'hr'
  AND NOT EXISTS (SELECT 1 FROM employees WHERE email = 'hr@company.com');

INSERT INTO employees (name, email, department_id, designation_id, join_date, user_id)
SELECT 'Test Employee', 'employee@company.com', 1, 2, CURRENT_DATE, u.id
FROM users u
WHERE u.username = 'employee'
  AND NOT EXISTS (SELECT 1 FROM employees WHERE email = 'employee@company.com');

INSERT INTO notifications (employee_id, title, message, type, is_read, created_at)
SELECT e.id, 'Welcome to HRMS', 'Your HR account is ready.', 'INFO', FALSE, CURRENT_TIMESTAMP
FROM employees e
WHERE e.email = 'hr@company.com'
  AND NOT EXISTS (
      SELECT 1 FROM notifications n
      WHERE n.employee_id = e.id AND n.title = 'Welcome to HRMS'
  );

INSERT INTO notifications (employee_id, title, message, type, is_read, created_at)
SELECT e.id, 'Payslip Generated', 'A sample payslip has been generated for your account.', 'SUCCESS', FALSE, CURRENT_TIMESTAMP
FROM employees e
WHERE e.email = 'employee@company.com'
  AND NOT EXISTS (
      SELECT 1 FROM notifications n
      WHERE n.employee_id = e.id AND n.title = 'Payslip Generated'
  );
