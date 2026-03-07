SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    s.product_name,
    s.quantity,
    s.sale_date
FROM
    customers c
JOIN
    sales s ON c.customer_id = s.customer_id;