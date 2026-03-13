CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'HR', 'EMPLOYEE')),
    password_change_required BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS designations (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    department_id INTEGER REFERENCES departments(id) ON DELETE SET NULL,
    designation_id INTEGER REFERENCES designations(id) ON DELETE SET NULL,
    join_date DATE NOT NULL,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS leaves (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason TEXT NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED')),
    applied_date DATE NOT NULL,
    reviewed_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    reviewed_date DATE,
    comments TEXT
);

CREATE TABLE IF NOT EXISTS attendance (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    check_in_time TIME,
    check_out_time TIME,
    status VARCHAR(20) NOT NULL CHECK (status IN ('PRESENT', 'ABSENT', 'HALF_DAY', 'LATE')),
    notes TEXT,
    UNIQUE(employee_id, date)
);

CREATE TABLE IF NOT EXISTS payroll (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(id) ON DELETE CASCADE,
    month VARCHAR(7) NOT NULL,
    base_salary DECIMAL(10, 2) NOT NULL,
    days_present INTEGER NOT NULL,
    days_absent INTEGER NOT NULL,
    days_late INTEGER NOT NULL,
    days_half INTEGER NOT NULL,
    allowances DECIMAL(10, 2) DEFAULT 0,
    deductions DECIMAL(10, 2) DEFAULT 0,
    net_salary DECIMAL(10, 2) NOT NULL,
    generation_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('DRAFT', 'FINALIZED', 'PAID')),
    notes TEXT,
    UNIQUE(employee_id, month)
);

CREATE TABLE IF NOT EXISTS notifications (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_activities (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    username VARCHAR(50) NOT NULL,
    user_role VARCHAR(20) NOT NULL,
    activity_type VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    entity_type VARCHAR(50),
    entity_id INTEGER,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(50)
);

CREATE INDEX IF NOT EXISTS idx_employee_user_id ON employees(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_employee_id ON notifications(employee_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_user_activities_user_id ON user_activities(user_id);
CREATE INDEX IF NOT EXISTS idx_user_activities_timestamp ON user_activities(timestamp);
CREATE INDEX IF NOT EXISTS idx_user_activities_entity ON user_activities(entity_type, entity_id);

INSERT INTO departments (name) VALUES ('Human Resources') ON CONFLICT (name) DO NOTHING;
INSERT INTO departments (name) VALUES ('Information Technology') ON CONFLICT (name) DO NOTHING;
INSERT INTO departments (name) VALUES ('Finance') ON CONFLICT (name) DO NOTHING;
INSERT INTO departments (name) VALUES ('Marketing') ON CONFLICT (name) DO NOTHING;
INSERT INTO departments (name) VALUES ('Operations') ON CONFLICT (name) DO NOTHING;

INSERT INTO designations (title) VALUES ('Manager') ON CONFLICT (title) DO NOTHING;
INSERT INTO designations (title) VALUES ('Team Lead') ON CONFLICT (title) DO NOTHING;
INSERT INTO designations (title) VALUES ('Senior Developer') ON CONFLICT (title) DO NOTHING;
INSERT INTO designations (title) VALUES ('Junior Developer') ON CONFLICT (title) DO NOTHING;
INSERT INTO designations (title) VALUES ('HR Specialist') ON CONFLICT (title) DO NOTHING;
INSERT INTO designations (title) VALUES ('Financial Analyst') ON CONFLICT (title) DO NOTHING;
INSERT INTO designations (title) VALUES ('Marketing Specialist') ON CONFLICT (title) DO NOTHING;

INSERT INTO users (username, password_hash, role, password_change_required)
VALUES ('admin', '$2a$12$VsjjVLoXxdkZn29hmYnRYurGKwZZOSU6u.qynngaEd6o8OtmIjnMC', 'ADMIN', FALSE)
ON CONFLICT (username) DO NOTHING;
