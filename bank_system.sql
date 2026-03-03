create schema bank_system; 
use bank_system;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(255),
    branch_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE branches (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_name VARCHAR(100),
    city VARCHAR(100),
    manager_name VARCHAR(100),
    opened_date DATE
);

CREATE TABLE accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    branch_id INT,
    account_type ENUM('Savings', 'Current', 'Fixed Deposit'),
    balance DECIMAL(15,2) DEFAULT 0.00,
    last_transaction_date DATETIME,
    opened_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    transaction_type ENUM('Deposit', 'Withdrawal', 'Transfer'),
    amount DECIMAL(15,2),
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(255),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

INSERT INTO branches (branch_name, city, manager_name, opened_date) VALUES
('Downtown Branch', 'New York', 'Alice Johnson', '2005-03-15'),
('Uptown Branch', 'New York', 'Bob Smith', '2010-07-22'),
('Midtown Branch', 'Chicago', 'Carol White', '2012-11-10');

INSERT INTO customers (first_name, last_name, email, phone, address, branch_id) VALUES
('John', 'Doe', 'john.doe@example.com', '123-456-7890', '123 Main St', 1),
('Jane', 'Smith', 'jane.smith@example.com', '234-567-8901', '456 Elm St', 1),
('Michael', 'Brown', 'michael.brown@example.com', '345-678-9012', '789 Oak St', 2),
('Emily', 'Davis', 'emily.davis@example.com', '456-789-0123', '321 Pine St', 2),
('David', 'Wilson', 'david.wilson@example.com', '567-890-1234', '654 Cedar St', 3),
('Sophia', 'Taylor', 'sophia.taylor@example.com', '678-901-2345', '987 Maple St', 3);

INSERT INTO accounts (customer_id, branch_id, account_type, balance, last_transaction_date, opened_date) VALUES
(1, 1, 'Savings', 5000.00, '2025-11-01 10:00:00', '2020-01-10'),
(1, 1, 'Current', 2000.00, '2025-11-02 12:00:00', '2021-05-15'),
(2, 1, 'Savings', 7500.00, '2025-11-03 09:30:00', '2019-08-20'),
(3, 2, 'Current', 3000.00, '2025-11-02 14:00:00', '2022-02-11'),
(3, 2, 'Savings', 10000.00, '2025-11-04 11:45:00', '2020-12-05'),
(4, 2, 'Savings', 4500.00, '2025-11-01 16:20:00', '2021-09-30'),
(5, 3, 'Current', 2500.00, '2025-11-03 13:10:00', '2018-07-22'),
(6, 3, 'Savings', 9000.00, '2025-11-04 15:00:00', '2020-03-18');

INSERT INTO transactions (account_id, transaction_type, amount, transaction_date, description) VALUES
(1, 'Deposit', 2000.00, '2025-11-01 10:00:00', 'Initial deposit'),
(1, 'Withdrawal', 500.00, '2025-11-02 09:00:00', 'ATM withdrawal'),
(2, 'Deposit', 2000.00, '2025-11-02 12:00:00', 'Salary deposit'),
(3, 'Withdrawal', 1000.00, '2025-11-03 09:30:00', 'Bill payment'),
(4, 'Deposit', 3000.00, '2025-11-02 14:00:00', 'Freelance payment'),
(5, 'Deposit', 10000.00, '2025-11-04 11:45:00', 'Savings transfer'),
(6, 'Withdrawal', 1500.00, '2025-11-01 16:20:00', 'Online purchase'),
(7, 'Deposit', 2500.00, '2025-11-03 13:10:00', 'Salary'),
(8, 'Deposit', 9000.00, '2025-11-04 15:00:00', 'Savings transfer'),
(3, 'Deposit', 500.00, '2025-11-03 10:00:00', 'Cash deposit'),
(4, 'Withdrawal', 300.00, '2025-11-01 16:50:00', 'ATM withdrawal'),
(2, 'Withdrawal', 1000.00, '2025-11-03 15:20:00', 'Online payment'),
(1, 'Deposit', 700.00, '2025-11-04 10:30:00', 'Cash deposit'),
(5, 'Withdrawal', 500.00, '2025-11-05 09:10:00', 'Bill payment'),
(6, 'Deposit', 1000.00, '2025-11-05 12:40:00', 'Bonus deposit');