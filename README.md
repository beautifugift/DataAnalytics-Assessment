# Data Analytics SQL Assessment Submission

The above files contains the SQL query and below provides explanations for each SQL query solution and discusses the challenges encountered during their development.

## Query 1: Customer Savings and Investment Analysis

**Approach:**
- This query identifies customers who have both savings and investment accounts
- Used conditional counting with `CASE WHEN` to separate savings vs investment plans
- Calculated total deposits by summing confirmed amounts
- Filtered for active, non-deleted plans with successful transactions
- Grouped by customer and ordered by total deposits (highest first)

**Challenges:**
- Initially struggled with the conditional counting syntax
- Had to ensure the JOIN conditions properly filtered for successful transactions only
- The HAVING clause required careful testing to verify it correctly identified customers with both account types

## Query 2: Transaction Frequency Analysis

**Approach:**
- Created a CTE to calculate monthly transaction counts per user
- Built a second CTE to categorize users by average transaction frequency
- Used a CASE statement to create the frequency buckets
- Final query aggregated results by frequency category with custom ordering

**Challenges:**
- Determining appropriate thresholds for frequency categories required business understanding
- The DATE_FORMAT function had syntax issues initially
- The custom ordering in the final query needed multiple iterations to get right

## Query 3: Inactive Account Identification

**Approach:**
- Categorized plans by type using CASE statement
- Calculated inactivity duration using DATEDIFF
- Used LEFT JOIN to include plans with no transactions
- Filtered for either no transactions or >365 days inactivity
- Ordered by longest inactive first

**Challenges:**
- The LEFT JOIN behavior with aggregate functions was tricky
- Handling NULL values in the HAVING clause required careful consideration
- The DATEDIFF calculation needed verification against sample data

## Query 4: Customer Lifetime Value Estimation

**Approach:**
- Created CTE with basic customer metrics (tenure, transaction counts, averages)
- Calculated CLV using a formula based on transaction frequency and average amount
- Incorporated NULLIF and COALESCE for safe calculations
- Filtered for active customers with transaction history
- Ordered by highest estimated CLV

**Challenges:**
- The CLV formula required several iterations to get right
- Handling division by zero for new customers was initially overlooked
- The scaling factor (0.001) needed explanation for business context
- Verifying the formula against known customer patterns took time

