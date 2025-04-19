-- Create payroll table
CREATE TABLE IF NOT EXISTS payroll (
    id SERIAL PRIMARY KEY,
    emp_id INTEGER NOT NULL REFERENCES employees(id),
    month VARCHAR(7) NOT NULL, -- Format: YYYY-MM
    year INTEGER NOT NULL,
    base_salary DECIMAL(10, 2) NOT NULL,
    days_present INTEGER NOT NULL,
    days_absent INTEGER NOT NULL,
    days_late INTEGER NOT NULL,
    days_half INTEGER NOT NULL,
    allowances DECIMAL(10, 2) DEFAULT 0.00,
    deductions DECIMAL(10, 2) DEFAULT 0.00,
    gross_salary DECIMAL(10, 2) NOT NULL,
    net_salary DECIMAL(10, 2) NOT NULL,
    tax_amount DECIMAL(10, 2) DEFAULT 0.00,
    generation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'GENERATED', -- GENERATED, APPROVED, PAID
    notes TEXT,
    UNIQUE(emp_id, month, year)
);

-- Create payroll_items table for detailed breakdown
CREATE TABLE IF NOT EXISTS payroll_items (
    id SERIAL PRIMARY KEY,
    payroll_id INTEGER NOT NULL REFERENCES payroll(id) ON DELETE CASCADE,
    item_type VARCHAR(20) NOT NULL, -- ALLOWANCE, DEDUCTION, BONUS, TAX
    item_name VARCHAR(100) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    description TEXT
);
