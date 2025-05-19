SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    -- Count distinct savings plans (where is_regular_savings = 1)
    COUNT(DISTINCT CASE WHEN pp.is_regular_savings = 1 THEN pp.id END) AS savings_count,
    -- Count distinct investment plans (where is_a_fund = 1)
    COUNT(DISTINCT CASE WHEN pp.is_a_fund = 1 THEN pp.id END) AS investment_count,
    -- Sum all confirmed deposits (converted from cents to dollars)
    ROUND(SUM(ss.confirmed_amount)/100, 2) AS total_deposits
FROM 
    users_customuser u
JOIN 
    plans_plan pp ON u.id = pp.owner_id
JOIN 
    savings_savingsaccount ss ON pp.id = ss.plan_id
WHERE 
    pp.is_deleted = 0  -- Only non-deleted plans
    AND pp.is_archived = 0  -- Only non-archived plans
    AND ss.transaction_status = 'success'  -- Only successful transactions
    AND (pp.is_regular_savings = 1 OR pp.is_a_fund = 1)  -- Only savings or investment plans
GROUP BY 
    u.id, u.first_name, u.last_name
HAVING 
    savings_count > 0  -- Must have at least one savings account
    AND investment_count > 0  -- Must have at least one investment account
ORDER BY 
    total_deposits DESC;  -- Sort by total deposits in descending order
