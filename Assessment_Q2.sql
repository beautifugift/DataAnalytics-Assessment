
/*
Question 2: Transaction Frequency Analysis
Categorizes customers by monthly transaction frequency
*/


-- First CTE: Calculates monthly transaction counts per user
WITH monthly_transactions AS (
    SELECT 
        u.id AS owner_id,
        -- Format transaction date as 'YYYY-MM' for monthly grouping
        DATE_FORMAT(ss.transaction_date, '%Y-%m') AS month,
        COUNT(*) AS transaction_count
    FROM 
        users_customuser u
    JOIN 
        savings_savingsaccount ss ON u.id = ss.owner_id
    WHERE 
        ss.transaction_status = 'success'  -- Only successful transactions
        AND ss.confirmed_amount > 0  -- Only transactions with positive amounts
    GROUP BY 
        u.id, DATE_FORMAT(ss.transaction_date, '%Y-%m')  -- Group by user and month
),

-- Second CTE: Categorizes users based on their average monthly transaction frequency
frequency_categories AS (
    SELECT 
        owner_id,
        AVG(transaction_count) AS avg_transactions,  -- Calculate average transactions per month
        CASE 
            WHEN AVG(transaction_count) >= 10 THEN 'High Frequency'
            WHEN AVG(transaction_count) >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category  -- Categorize users based on transaction frequency
    FROM 
        monthly_transactions
    GROUP BY 
        owner_id  -- Group by user to calculate their average
)

-- Main query: Aggregates results by frequency category
SELECT 
    frequency_category,
    COUNT(DISTINCT owner_id) AS customer_count,  -- Count unique users in each category
    ROUND(AVG(avg_transactions), 1) AS avg_transactions_per_month  -- Display average transactions with 1 decimal
FROM 
    frequency_categories
GROUP BY 
    frequency_category
ORDER BY 
    -- Custom ordering to display High Frequency first, then Medium, then Low
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        ELSE 3
    END;
