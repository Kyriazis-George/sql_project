create database restaurants;
use restaurants;
CREATE TABLE Managers (
    manager_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2) NOT NULL
);

-- Create Restaurants Table
CREATE TABLE Restaurants (
    restaurant_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    opened_date DATE NOT NULL,
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES Managers(manager_id)
);

-- Create Menu_Items Table
CREATE TABLE Menu_Items (
    item_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(6,2) NOT NULL
);

-- Create Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    restaurant_id INT,
    item_id INT,
    quantity INT NOT NULL,
    order_date DATE NOT NULL);

    
INSERT INTO Managers (manager_id, name, hire_date, salary) VALUES
(1, 'Alice Johnson', '2018-05-01', 4500.00),
(2, 'Bob Smith', '2019-03-12', 4200.00),
(3, 'Carol Lee', '2020-07-23', 4000.00);

select * from managers;

-- Insert Data into Restaurants
INSERT INTO Restaurants (restaurant_id, name, location, opened_date, manager_id) VALUES
(101, 'Pizza Palace', 'New York', '2018-06-15', 1),
(102, 'Burger Barn', 'Chicago', '2019-05-20', 2),
(103, 'Taco Town', 'Los Angeles', '2020-08-10', 3);

-- Insert Data into Menu_Items
INSERT INTO Menu_Items (item_id, name, category, price) VALUES
(1001, 'Pepperoni Pizza', 'Main Course', 12.50),
(1002, 'Cheeseburger', 'Main Course', 8.99),
(1003, 'Taco', 'Main Course', 3.50),
(1004, 'Cola', 'Beverage', 1.99),
(1005, 'Ice Cream', 'Dessert', 4.50);

-- Insert Data into Orders
INSERT INTO Orders (order_id, restaurant_id, item_id, quantity, order_date) VALUES
(5001, 101, 1001, 2, '2023-05-10'),
(5002, 102, 1002, 3, '2023-05-11'),
(5003, 103, 1003, 5, '2023-05-12'),
(5004, 101, 1004, 4, '2023-06-01'),
(5005, 102, 1005, 2, '2023-06-02');

-- 1. List the names of restaurants that are managed by managers earning more than the average salary.

select r.name, managers.salary
from restaurants r
join managers m on m.manager_id = r.manager_id
where m.salary > ( select avg(salary) from managers);

-- Find the menu items whose price is above the average price of all menu items.

select m.item_id, m.price
from menu_items m
where m.price > (select avg(price)
from menu_items);  

--  3. List restaurant names and locations where the restaurant opened after the earliest hire date of
--  any manager.-- 

select r.restaurant_id, r.name, r.location, r.opened_date, m.manager_id, m.hire_date
from restaurants r
join managers m on r.manager_id = m.manager_id
where r.opened_date > (select max(m.hire_date) from managers );
 
-- Find the orders (order_id and order_date) where the quantity ordered is greater than the average
--  quantity for that same menu item.

select o.order_id, o.order_date, o.quantity, m.item_id
from orders o
join menu_items m on o.item_id = m.item_id 
where o.quantity > (select avg(o2.quantity) from orders o2
where o2.item_id = o.item_id)
order by o.quantity desc;

-- Retrieve the names of managers who manage a restaurant that has never sold a dessert

select distinct m.manager_id, 
m.name,
r.restaurant_id
from managers m
join restaurants r ON m.manager_id = r.manager_id
where not exists ( 
select 1
FROM orders o
join menu_items mi ON o.item_id = mi.item_id
where o.restaurant_id = r.restaurant_id
and mi.category = "dessert")
order by m.name;

-- or

select m.manager_id,
m.name 
from managers m
join restaurants r on r.manager_id = m.manager_id
left join orders o on r.restaurant_id = o.restaurant_id
left join menu_items mi on o.item_id = mi.item_id
group by m.manager_id, m.name
having count(mi.item_id) = 0
order by m.name; 


-- Question 1: Managers whose restaurants have never sold a Beverage
-- Question 2: Managers whose restaurants have never sold a Main Course

-- question 1

select distinct m.manager_id, m.name
from managers m
join restaurants r on m.manager_id = r.manager_id
where not exists(
select 1
from orders o
join menu_items mi on o.item_id = mi.item_id
where r.restaurant_id = o.restaurant_id
and mi.category = "beverage"
order by m.name);

-- or

select distinct m.manager_id, m.name
from managers m
join restaurants r on m.manager_id = r.manager_id
where not exists(
select 1
from orders o 
join menu_items mi on o.item_id = mi.item_id
join restaurants r2 on o.restaurant_id = r2.restaurant_id and r2.restaurant_id = r.restaurant_id
where mi.category = "beverage"
order by m.name);


-- or

select distinct m.manager_id, m.name
from managers m
join restaurants r on m.manager_id = r.manager_id
where not exists(
select 1
from orders o 
join menu_items mi on o.item_id = mi.item_id
join restaurants r2 on o.restaurant_id = r2.restaurant_id
where r2.restaurant_id = r.restaurant_id
and mi.category = "beverage")
order by m.name;

-- with left join

select distinct m.manager_id, m.name
from managers m
join restaurants r on m.manager_id =r.manager_id
left join  orders o on r.restaurant_id = o.restaurant_id
left join menu_items mi on o.item_id = mi.item_id
and mi.category = "beverage"
group by m.manager_id, m.name
having count(mi.item_id) = 0
order by m.name;


-- Question 2: Managers whose restaurants have never sold a Main Course
-- where r.restaurant_id = o.restaurant_id 

select distinct m.manager_id, m.name
from managers m
join restaurants r on m.manager_id 
where not exists(
select * from orders o
join menu_items mi on o.item_id = mi.item_id
join restaurants r2 on o.restaurant_id = r2.restaurant_id and r2.restaurant_id = r.restaurant_id
where mi.category = "main course")
order by m.name;

-- or 

select distinct m.manager_id, m.name
from managers m
join restaurants r on m.manager_id 
where not exists(
select * from orders o
join menu_items mi on o.item_id = mi.item_id
where r.restaurant_id = o.restaurant_id 
and mi.category = "main course")
order by m.name;


--  List all menu items that have never been ordered in any restaurant located in 'Chicago'.

select mi.item_id, mi.name
from menu_items mi
where not exists (
select 1
from orders oi
join orders o on o.order_id = oi.order_id
join restaurants r on o.restaurant_id = r.restaurant_id
where oi.item_id = mi.item_id
and r.location = "Chicago")
order by mi.name; 

-- select o.item_id, mi.name
-- from menu_items mi
-- left join orders o on mi.item_id = o.item_id
-- left join restaurants r on r.restaurant_id = o.restaurant_id
-- and r.location = "chicago"
-- where r.restaurant_id is NULL 
-- order by mi.name

-- select o.item_id, mi.name
-- from menu_items mi
-- right join orders o on mi.item_id = o.item_id
-- right join restaurants r on r.restaurant_id = o.restaurant_id
-- and r.location = "chicago"
-- where r.restaurant_id is NULL 
-- order by mi.name




-- select mi.item_id, mi.name
-- from menu_items mi
-- where not exists( 
-- select 1
-- from orders oi
-- join restaurants r on r.restaurant_id = oi.restaurant_id
-- where oi.item_id = mi.item_id
-- and r.location = "Chicago")
-- order by mi.name;



--  7. . Find the top 1 restaurant (name and total quantity sold) that has the highest total orders
--  compared to all other restaurants.

select r.name, sum(quantity) as total_quantity
from restaurants r
join orders o on r.restaurant_id = o.restaurant_id
group by r.name
order by total_quantity DESC
Limit 1;
 
-- or. Using a subquery

SELECT r.name, SUM(o.quantity) AS total_quantity
FROM restaurants r
JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.name
Having sum(o.quantity) = (
select max(total_quantity)
from (select sum(o2.quantity) as total_quantity
from restaurants r2
join orders o2 on r2.restaurant_id = o2.restaurant_id
group by r2.name
)sub
);

-- or using RANK()
select name, total_quantity
from (
select r.name, sum(o.quantity) AS total_quantity,
RANK() over(order by sum(o.quantity) desc) as rk
from restaurants r
join orders o on r.restaurant_id = o.restaurant_id
group by r.name) sub
where rk = 1;

-- Show restaurant names where all menu items sold have a price greater than the cheapest main course.

select name, category from menu_items;

-- select r.name , mi.item_id, order_id, quantity.
-- from restaurants r
-- join orders on r.restaurant_id = o.restaurant_id 
-- join menu_items mi on o.item_id = mi.item_id
-- where mi.item


select category, price from menu_items
group by category, price
order by category, price ;

-- . Show restaurant names where all menu items sold have a price greater than the cheapest main
--  course

-- select r.name as restaurant_name
-- from restaurants r
-- join orders o on r.restaurant_id = o.restaurant_id
-- JOIN Menu_Items mi ON o.item_id = mi.item_id
-- group by r.name
-- having min(mi.price) > (select min(price)
-- from menu_items
-- where category = 'main course');
 

-- with WHERE NOT EXISTS-- 


-- select min(price)
-- from menu_items
-- where category = "main course";


-- select r.name
-- from restaurants r
-- where not exists (select 1 from menu_items mi
-- join orders o on mi.item_id = o.item_id
-- where restaurant_id = r.restaurant_id 
-- and  mi.price <= ( select min(price)
-- from menu_items
-- where category = "main course")
-- );

-- Find the name(s) of manager(s) whose restaurant has generated a total sales value higher than
--  the average sales value of all restaurants.


select r.name ,r.restaurant_id, sum(quantity * price) as total_sales
from orders o
join restaurants r on o.restaurant_id = r.restaurant_id
join menu_items mi on o.item_id = mi.item_id
group by r.name, r.restaurant_id;


-- select r.name, r.restaurant_id, avg(quantity * price) as sales
-- from restaurants r 
-- join orders o on r.restaurant_id = o.restaurant_id
-- join menu_items mi on mi.item_id = o.item_id
-- group by r.name, r.restaurant_id 


select avg(total_sales)
from( select r.name ,r.restaurant_id, sum(quantity * price) as total_sales
from orders o
join restaurants r on o.restaurant_id = r.restaurant_id
join menu_items mi on o.item_id = mi.item_id
group by r.name, r.restaurant_id)
as sales_per_restaurant 
limit 1;





SELECT m.name AS manager_name
FROM (
    SELECT r.restaurant_id, r.manager_id, SUM(o.quantity * mi.price) AS total_sales
    FROM orders o
    JOIN restaurants r ON o.restaurant_id = r.restaurant_id
    JOIN menu_items mi ON o.item_id = mi.item_id
    GROUP BY r.restaurant_id, r.manager_id
) AS sales_per_restaurant
JOIN managers m ON sales_per_restaurant.manager_id = m.manager_id
WHERE total_sales > (
    SELECT AVG(total_sales)
    FROM (
        SELECT SUM(o.quantity * mi.price) AS total_sales
        FROM orders o
        JOIN restaurants r ON o.restaurant_id = r.restaurant_id
        JOIN menu_items mi ON o.item_id = mi.item_id
        GROUP BY r.restaurant_id
    ) AS avg_sales
);
 