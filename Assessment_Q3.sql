SELECT 
    pp.id AS plan_id,
    pp.owner_id,
    -- Categorize the plan type based on boolean flags
    CASE 
        WHEN pp.is_regular_savings = 1 THEN 'Savings'
        WHEN pp.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    -- Find the most recent transaction date for each plan
    MAX(ss.transaction_date) AS last_transaction_date,
    -- Calculate days since last activity (current date - last transaction date)
    DATEDIFF(CURRENT_DATE, MAX(ss.transaction_date)) AS inactivity_days
FROM 
    plans_plan pp
-- Left join to include plans even if they have no transactions
LEFT JOIN 
    savings_savingsaccount ss ON pp.id = ss.plan_id
    -- Join conditions filter for successful, positive-amount transactions only
    AND ss.transaction_status = 'success'
    AND ss.confirmed_amount > 0
WHERE 
    pp.is_deleted = 0  -- Only non-deleted plans
    AND pp.is_archived = 0  -- Only non-archived plans
    -- Only include savings or investment plans (exclude 'Other' types)
    AND (pp.is_regular_savings = 1 OR pp.is_a_fund = 1)
GROUP BY 
    pp.id, pp.owner_id, pp.is_regular_savings, pp.is_a_fund
-- Filter for either:
-- 1. Plans with no transactions at all (last_transaction_date IS NULL)
-- 2. Plans inactive for more than 1 year (inactivity_days > 365)
HAVING 
    last_transaction_date IS NULL 
    OR inactivity_days > 365
-- Sort by inactivity duration (most inactive first)
ORDER BY 
    inactivity_days DESC;
