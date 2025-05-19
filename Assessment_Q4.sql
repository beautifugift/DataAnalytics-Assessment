/*
Question 4: Customer Lifetime Value
Estimates CLV based on transaction history
*/

-- CTE to calculate basic customer statistics
WITH customer_stats AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        -- Calculate customer tenure in months (current date minus join date)
        TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) AS tenure_months,
        -- Count all successful transactions for each customer
        COUNT(ss.id) AS total_transactions,
        -- Calculate average transaction amount (converted from cents to dollars)
        AVG(ss.confirmed_amount)/100 AS avg_transaction_amount
    FROM 
        users_customuser u
    -- Left join to include customers even if they have no transactions
    LEFT JOIN 
        savings_savingsaccount ss ON u.id = ss.owner_id
        -- Filter for successful transactions with positive amounts
        AND ss.transaction_status = 'success'
        AND ss.confirmed_amount > 0
    WHERE 
        u.is_active = 1  -- Only active customers
    GROUP BY 
        u.id, u.first_name, u.last_name, u.date_joined
)

-- Main query to calculate estimated Customer Lifetime Value (CLV)
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    -- Complex CLV calculation:
    -- 1. (transactions/month) * 12 months = annual transactions
    -- 2. Multiply by (avg transaction * 0.001) as a simple value factor
    -- 3. NULLIF prevents division by zero for new customers
    -- 4. ROUND to 2 decimal places for currency formatting
    ROUND(
        (total_transactions / NULLIF(tenure_months, 0)) * 12 * 
        (0.001 * COALESCE(avg_transaction_amount, 0)),
    2
    ) AS estimated_clv
FROM 
    customer_stats
WHERE 
    tenure_months > 0  -- Exclude customers who joined this month
    AND total_transactions > 0  -- Only customers with transactions
ORDER BY 
    estimated_clv DESC;  -- Sort by highest value customers first
