INSERT INTO customers (first_name, last_name, email, phone)
VALUES 
  ('Alice', 'Johnson', 'alice.johnson@example.com', '123-456-7890'),
  ('Bob', 'Smith', 'bob.smith@example.com', '234-567-8901'),
  ('Charlie', 'Brown', 'charlie.brown@example.com', '345-678-9012'),
  ('Diana', 'Ross', 'diana.ross@example.com', '456-789-0123'),
  ('Ethan', 'Hunt', 'ethan.hunt@example.com', '567-890-1234');
  
  INSERT INTO sales (customer_id, product_name, quantity, price, sale_date)
VALUES 
  (1, 'Laptop', 1, 1200.00, '2025-07-01 10:15:00'),
  (2, 'Smartphone', 2, 650.00, '2025-07-02 14:30:00'),
  (3, 'Tablet', 1, 300.00, '2025-07-03 09:45:00'),
  (1, 'Monitor', 2, 200.00, '2025-07-04 11:00:00'),
  (4, 'Keyboard', 1, 45.00, '2025-07-05 13:20:00'),
  (5, 'Headphones', 3, 75.00, '2025-07-06 16:10:00');