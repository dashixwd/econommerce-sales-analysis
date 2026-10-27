-- ==========================================
-- SQL-анализ продаж интернет-магазина
-- Таблица: sales (Order ID, Product, Quantity Ordered, Price Each, Order Date, City, Sales)
-- ==========================================

-- 1. Общая выручка и количество заказов
SELECT 
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM("Sales"), 2) AS total_revenue,
    ROUND(AVG("Sales"), 2) AS average_check
FROM sales;

-- 2. Выручка по городам (Топ-5)
SELECT 
    "City",
    ROUND(SUM("Sales"), 2) AS city_revenue,
    COUNT(DISTINCT "Order ID") AS orders_count
FROM sales
GROUP BY "City"
ORDER BY city_revenue DESC
LIMIT 5;

-- 3. Динамика продаж по месяцам
SELECT 
    EXTRACT(MONTH FROM "Order Date"::DATE) AS month_number,
    ROUND(SUM("Sales"), 2) AS monthly_revenue
FROM sales
GROUP BY month_number
HAVING SUM("Sales") > 1000000
ORDER BY month_number;

-- 4. Топ-3 товара по выручке в каждом месяце
WITH monthly_product_sales AS (
    SELECT 
        EXTRACT(MONTH FROM "Order Date"::DATE) AS month_number,
        "Product",
        SUM("Sales") AS product_revenue
    FROM sales
    GROUP BY month_number, "Product"
)
SELECT 
    month_number,
    "Product",
    product_revenue,
    RANK() OVER(PARTITION BY month_number ORDER BY product_revenue DESC) AS rank_in_month
FROM monthly_product_sales
WHERE rank_in_month <= 3
ORDER BY month_number, rank_in_month;
