# Retail Banking Transaction Analytics (SQL)

A relational database project that models retail banking operations and uses SQL to answer real business questions: where the money sits, who is most active, which accounts are dormant, and which transactions look suspicious.

*Tech:* MySQL 8 | *Dataset:* synthetic (30 customers, 36 accounts, 303 transactions, 16 loans, 5 branches) | *Period:* Jan to Jun 2025

---

## Database Design


branches (1) ──< customers (1) ──< accounts (1) ──< transactions
                       │
                       └──< loans


| Table | Purpose | Key columns |
|---|---|---|
| branches | Bank branches | branch_id (PK), city, manager |
| customers | Customer profiles | customer_id (PK), city, join_date, branch_id (FK) |
| accounts | Savings, Current and Salary accounts | account_id (PK), customer_id (FK), account_type, balance |
| transactions | Credits and debits across UPI, ATM, NEFT, POS | txn_id (PK), account_id (FK), txn_type, amount, txn_date, channel |
| loans | Home, Personal, Auto and Education loans | loan_id (PK), customer_id (FK), loan_type, amount, status |

*Data integrity:* primary and foreign keys, CHECK constraints (valid account types, positive amounts, non-negative balances) and NOT NULL rules.
*Performance:* indexes on accounts(customer_id), transactions(account_id, txn_date) and loans(customer_id) to speed up joins and date filters.

---

## Business Questions Answered

| # | Question | SQL concepts |
|---|---|---|
| 1 | What is the total and average balance per account type? | GROUP BY, aggregates |
| 2 | Who are the top 5 customers by transaction value? | Multi-table JOIN, ORDER BY, LIMIT |
| 3 | Which accounts have more than 10 transactions in a month? | HAVING, DATE_FORMAT |
| 4 | What are the monthly credit vs debit totals and net cash flow? | CASE WHEN (conditional aggregation) |
| 5 | Which accounts have been dormant for 90 days? | LEFT JOIN ... IS NULL (anti-join), DATE_SUB |
| 6 | Which loans are above the average loan amount? | Subquery |
| 7 | How do customers rank by balance within each city? | Window function RANK() OVER (PARTITION BY ...) |
| 8 | Which debits look suspicious (above 3x the account's average)? | CTE, derived-table join |
| 9 | What is the loan exposure and overdue count per branch? | Multi-join, conditional aggregation |

---

## Sample Insights

- *Current accounts hold the most money:* about ₹44.1 lakh across 12 accounts, versus ₹26.8 lakh for Salary and ₹25.9 lakh for Savings accounts.
- *Top customer by activity:* Sneha Joshi (Delhi), with about ₹6.99 lakh transacted across 22 transactions.
- *Dormant accounts:* 7 of 36 accounts had no transactions in the 90 days before 30 June 2025, a re-engagement list for the bank.
- *High activity:* three accounts crossed 10 transactions in May 2025, which could be flagged for monitoring.
- *Fraud-style flag:* one NEFT debit of ₹2.4 lakh was 6.5x the account's average debit, so it was flagged for review.

---

## How to Run

*Option 1: Online (no install)*
1. Open [db-fiddle.com](https://www.db-fiddle.com) and select *MySQL 8.0*.
2. Paste the schema and INSERT statements (everything above the "ANALYSIS QUERIES" comment in banking_analytics.sql) into the left panel.
3. Paste the queries into the right panel and click *Run*.

*Option 2: Local MySQL*
bash
mysql -u root -p < banking_analytics.sql


---

## Skills Demonstrated

Relational schema design | Joins | Aggregation | Subqueries | CTEs | Window functions | Indexing | Constraints | Data analysis

---

All data is synthetic and created for learning and portfolio purposes.
