CREATE TABLE sales_data (
    order_number INT,
    quantity_ordered INT,
    price_each NUMERIC(10,2),
    order_line_number INT,
    sales NUMERIC(10,2),
    order_date TIMESTAMP,
    status VARCHAR(20),
    qtr_id INT,
    month_id INT,
    year_id INT,
    product_line VARCHAR(50),
    msrp NUMERIC(10,2),
    product_code VARCHAR(20),
    customer_name VARCHAR(100),
    phone VARCHAR(30),
    address_line1 VARCHAR(100),
    address_line2 VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50),
    territory VARCHAR(50),
    contact_last_name VARCHAR(50),
    contact_first_name VARCHAR(50),
    deal_size VARCHAR(20)
);

SELECT*FROM sales_data LIMIT 10;

SELECT COUNT(*)FROM sales_data;

SELECT order_number, customer_name, sales, order_date
FROM sales_data
WHERE sales > 5000
ORDER BY sales DESC;

SELECT product_line, SUM(sales) AS total_revenue
FROM sales_data
GROUP BY product_line
ORDER BY total_revenue DESC;

SELECT product_line, AVG(sales) AS avg_sale
FROM sales_data
GROUP BY product_line
HAVING AVG(sales) > 3500
ORDER BY avg_sale DESC;

SELECT order_number, customer_name, sales
FROM sales_data
WHERE sales > (SELECT AVG(sales) FROM sales_data)
ORDER BY sales DESC;

SELECT *
FROM (
    SELECT 
        product_line,
        order_number,
        customer_name,
        sales,
        ROW_NUMBER() OVER (PARTITION BY product_line ORDER BY sales DESC) AS rank
    FROM sales_data
) ranked
WHERE rank <= 3
ORDER BY product_line, rank;

SELECT customer_name, SUM(sales) AS total_spent
FROM sales_data
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 5;

SELECT year_id, month_id, SUM(sales) AS monthly_revenue
FROM sales_data
GROUP BY year_id, month_id
ORDER BY year_id, month_id;

SELECT 
    customer_name,
    COUNT(order_number) AS number_of_orders,
    SUM(sales) AS total_spent,
    ROUND(AVG(sales), 2) AS avg_order_value
FROM sales_data
GROUP BY customer_name
ORDER BY number_of_orders DESC;

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'sales_data';

CREATE INDEX idx_salesdata_customer ON sales_data(customer_name);

EXPLAIN ANALYZE
SELECT * FROM sales_data WHERE customer_name = 'Euro Shopping Channel';