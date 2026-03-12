create schema my_sql_project;
use my_sql_project;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    product_name VARCHAR(100),
    quantity INT,
    price DECIMAL(10, 2),
    sale_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

select first_name
from customers
where exists (select product_name from sales where customers.customer_id = sales.customer_id);


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
  
  create index product_name 
  on sales (product_name);
  
show index from sales;
 
select * from sales; 
  
  select 
  product_name, quantity,
  case
  when price between 40.00 and 190.00 then "cheap"
  when price between 200.00 and 350.00 then "average"
  when price between 400.00 and 800.00 then "expensive"
  else "very expensive"
  end as price_estimation
  from sales;
  
  select 
  s.product_name,
  s.quantity,
  s.sale_date,
  c.first_name as name,
  p.method as payment_method,
  s.price
from sales s
join customers c on s.customer_id = c.customer_id
join payments p on p.customer_id = c.customer_id
group by  s.product_name, s.quantity, c.first_name, s.sale_date, p.method, s.price
order by s.price;

  create index sales_report on sales(price, product_name);
  create index customer_random on customers(first_name, phone);
  
  select
  distinct first_name
  from customers;
  
  select first_name
  from customers
  group by first_name;
  
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10,2),
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    method VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO payments (customer_id, amount, method)
VALUES
(1, 1250.50, 'Credit Card'),
(2, 240.99, 'Cash'),
(3, 150.50, 'Cash'),
(4, 550, 'Credit Card');


#FILTERING  

select customer_id from payments
where method = 'Cash';


select
concat(first_name, '(',phone,')' ) as employee
from customers;

select product_name, avg(price) as price
from sales
group by product_name 

select s.customer_id, sale_id
from sales s
left join payments p
on s.customer_id = p.customer_id 

create index idx_name
on customers(customer_id);

show index from customers;

select * from customers
limit 10;


select phone, count(*)
from customers
group by phone
having count(*) >1;

select payment_id, amount
from payments
order by amount desc
limit 2;

select distinct customer_id
from payments;

select * from payments
where amount > 50;

select customer_id, avg(amount) as avg_amount
from payments
group by customer_id
having avg_amount > 20
limit 1 offset 1;

select * from payments
order by amount desc;

select * from payments
where amount <400;

select DATE(sale_date), sum(quantity * price) as profit
from sales
group by DATE(sale_date)
order by profit desc;


SELECT s.customer_id, c.last_name , s.product_name
from sales s
join customers c
on c.customer_id = s.customer_id
order by c.last_name asc;



select s.customer_id, c.last_name , s.product_name
from sales s
join customers c
on s.customer_id = s.customer_id
order by c.last_name ;

create index just_name
on customers(first_name);

show index from customers;

select customer_id,  sum(quantity * price) as profit
from sales
group by customer_id 
order by profit desc
limit 2;

select s.customer_id, c.last_name,  sum(quantity * price) as profit
from sales s
join customers c
on s.customer_id = c.customer_id
group by s.customer_id
order by profit desc
limit 1 offset 1;

SELECT c.customer_id, c.last_name
from customers c
join sales s
on c.customer_id = s.customer_id
where sale_id is null;





















