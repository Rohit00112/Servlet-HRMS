-- Create user_activities table
CREATE TABLE IF NOT EXISTS user_activities (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    username VARCHAR(50) NOT NULL,
    user_role VARCHAR(20) NOT NULL,
    activity_type VARCHAR(50) NOT NULL, -- LOGIN, LOGOUT, CREATE, UPDATE, DELETE, etc.
    description TEXT NOT NULL,
    entity_type VARCHAR(50), -- EMPLOYEE, LEAVE, ATTENDANCE, PAYROLL, etc.
    entity_id INTEGER, -- ID of the related entity (if applicable)
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(50)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_user_activities_user_id ON user_activities(user_id);
CREATE INDEX IF NOT EXISTS idx_user_activities_timestamp ON user_activities(timestamp);
CREATE INDEX IF NOT EXISTS idx_user_activities_entity ON user_activities(entity_type, entity_id);

-- Insert sample data (if needed)
-- Note: These will be inserted only if you run this script manually
-- In production, activities will be logged by the application

-- Admin activities
INSERT INTO user_activities (user_id, username, user_role, activity_type, description, entity_type, entity_id, timestamp, ip_address)
VALUES 
(1, 'admin', 'ADMIN', 'LOGIN', 'Admin logged in', NULL, NULL, NOW() - INTERVAL '1 hour', '127.0.0.1'),
(1, 'admin', 'ADMIN', 'CREATE', 'Created a new department: IT', 'DEPARTMENT', 1, NOW() - INTERVAL '55 minutes', '127.0.0.1'),
(1, 'admin', 'ADMIN', 'CREATE', 'Created a new designation: Software Engineer', 'DESIGNATION', 1, NOW() - INTERVAL '50 minutes', '127.0.0.1'),
(1, 'admin', 'ADMIN', 'CREATE', 'Added a new employee: John Doe', 'EMPLOYEE', 1, NOW() - INTERVAL '45 minutes', '127.0.0.1'),
(1, 'admin', 'ADMIN', 'UPDATE', 'Updated employee information for: John Doe', 'EMPLOYEE', 1, NOW() - INTERVAL '40 minutes', '127.0.0.1'),
(1, 'admin', 'ADMIN', 'VIEW', 'Viewed payroll report for April 2023', 'PAYROLL', NULL, NOW() - INTERVAL '35 minutes', '127.0.0.1'),
(1, 'admin', 'ADMIN', 'GENERATE_PAYROLL', 'Generated payroll for all employees for April 2023', 'PAYROLL', NULL, NOW() - INTERVAL '30 minutes', '127.0.0.1');

-- HR activities
INSERT INTO user_activities (user_id, username, user_role, activity_type, description, entity_type, entity_id, timestamp, ip_address)
VALUES 
(2, 'hr', 'HR', 'LOGIN', 'HR logged in', NULL, NULL, NOW() - INTERVAL '2 hours', '127.0.0.1'),
(2, 'hr', 'HR', 'VIEW', 'Viewed employee list', 'EMPLOYEE', NULL, NOW() - INTERVAL '1 hour 55 minutes', '127.0.0.1'),
(2, 'hr', 'HR', 'VIEW', 'Viewed employee profile: John Doe', 'EMPLOYEE', 1, NOW() - INTERVAL '1 hour 50 minutes', '127.0.0.1'),
(2, 'hr', 'HR', 'UPDATE', 'Updated employee contact information: John Doe', 'EMPLOYEE', 1, NOW() - INTERVAL '1 hour 45 minutes', '127.0.0.1'),
(2, 'hr', 'HR', 'VIEW', 'Viewed pending leave requests', 'LEAVE', NULL, NOW() - INTERVAL '1 hour 40 minutes', '127.0.0.1'),
(2, 'hr', 'HR', 'APPROVE', 'Approved leave request for: John Doe', 'LEAVE', 1, NOW() - INTERVAL '1 hour 35 minutes', '127.0.0.1'),
(2, 'hr', 'HR', 'REJECT', 'Rejected leave request for: Jane Smith', 'LEAVE', 2, NOW() - INTERVAL '1 hour 30 minutes', '127.0.0.1'),
(2, 'hr', 'HR', 'VIEW', 'Viewed attendance report for April 2023', 'ATTENDANCE', NULL, NOW() - INTERVAL '1 hour 25 minutes', '127.0.0.1');

-- Employee activities
INSERT INTO user_activities (user_id, username, user_role, activity_type, description, entity_type, entity_id, timestamp, ip_address)
VALUES 
(3, 'john.doe', 'EMPLOYEE', 'LOGIN', 'Employee logged in', NULL, NULL, NOW() - INTERVAL '3 hours', '127.0.0.1'),
(3, 'john.doe', 'EMPLOYEE', 'MARK_ATTENDANCE', 'Marked attendance for today', 'ATTENDANCE', 1, NOW() - INTERVAL '2 hours 55 minutes', '127.0.0.1'),
(3, 'john.doe', 'EMPLOYEE', 'VIEW', 'Viewed personal profile', 'EMPLOYEE', 1, NOW() - INTERVAL '2 hours 50 minutes', '127.0.0.1'),
(3, 'john.doe', 'EMPLOYEE', 'APPLY_LEAVE', 'Applied for leave from 2023-05-01 to 2023-05-03', 'LEAVE', 1, NOW() - INTERVAL '2 hours 45 minutes', '127.0.0.1'),
(3, 'john.doe', 'EMPLOYEE', 'VIEW', 'Viewed leave status', 'LEAVE', 1, NOW() - INTERVAL '2 hours 40 minutes', '127.0.0.1'),
(3, 'john.doe', 'EMPLOYEE', 'VIEW', 'Viewed attendance history', 'ATTENDANCE', NULL, NOW() - INTERVAL '2 hours 35 minutes', '127.0.0.1'),
(3, 'john.doe', 'EMPLOYEE', 'VIEW', 'Viewed payslip for March 2023', 'PAYROLL', 1, NOW() - INTERVAL '2 hours 30 minutes', '127.0.0.1'),
(3, 'john.doe', 'EMPLOYEE', 'DOWNLOAD', 'Downloaded payslip for March 2023', 'PAYROLL', 1, NOW() - INTERVAL '2 hours 25 minutes', '127.0.0.1');
