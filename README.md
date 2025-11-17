# SQL Layoffs Dataset: Data Cleaning & Exploratory Data Analysis

Data Cleaning Overview


This project performs full SQL-based data cleaning on a global layoffs dataset containing ~2,300 rows.
The workflow includes duplicate removal, string standardization, date formatting, null value handling, and data validation.
All work is done using MySQL with staging tables to preserve raw data.

Cleaning Steps Performed
1. Create Staging Tables
- Copied the original dataset into layoffs_staging
- Created layoffs_staging2 with an added row_num column for duplicate tracking
2. Duplicate Removal
- Used ROW_NUMBER() OVER(PARTITION BY …) to isolate true duplicates
- Verified and deleted duplicates while keeping the correct original rows
- Ref: Casper duplicates example
3. Standardization
- Trimmed leading/trailing whitespace in company names
- Unified industry labels (e.g., CryptoCurrency → Crypto)
- Standardized country values by removing trailing punctuation
- Converted text-based dates to proper DATE format
4. Null / Blank Value Handling
- Replaced empty strings with NULL
- Forward-filled missing industry values using company-based joins
- Identified companies without a second row (e.g., Bally’s)
5. Row & Column Cleanup
- Deleted rows where both total_laid_off AND percentage_laid_off were NULL
- Dropped the temporary row_num column
- All cleaning queries are located in /sql/full_cleaning_script.sql.

Files Included
- layoffs.csv — raw dataset
- layoffs_staging_table.csv - cleaned dataset
- layoffs data cleaning.sql — complete cleaning script

Next steps:
An exploratory data analysis will be included soon.
