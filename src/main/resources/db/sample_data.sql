-- Sample notifications
INSERT INTO notifications (employee_id, title, message, type, is_read, created_at)
VALUES 
(1, 'Leave Approved', 'Your leave request for May 25-26 has been approved', 'SUCCESS', false, NOW() - INTERVAL '1 day'),
(1, 'Payslip Generated', 'Your April 2023 payslip is now available', 'INFO', false, NOW() - INTERVAL '3 days'),
(1, 'Attendance Marked', 'You checked in at 9:02 AM today', 'INFO', false, NOW());

-- Make sure the notifications table exists
CREATE TABLE IF NOT EXISTS notifications (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL, -- INFO, SUCCESS, WARNING, ERROR
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_notifications_employee_id ON notifications(employee_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);
