# SQL Layoffs Dataset: Data Cleaning & Exploratory Data Analysis
Overview

This project performs full SQL-based data cleaning and exploratory data analysis (EDA) on a global layoffs dataset containing ~2,300 rows.
The workflow includes duplicate removal, string standardization, date formatting, null value handling, and structured analysis using MySQL.
The goal is to produce a clean, analysis-ready dataset and uncover trends across industries, companies, countries, and time.

## Data Cleaning Overview

All work is done in MySQL using staging tables to preserve the raw data and maintain a clean workflow.

### Cleaning Steps Performed
1. Create Staging Tables
- Copied the original dataset into layoffs_staging
- Created layoffs_staging2 with an added row_num column for duplicate tracking
2. Duplicate Removal
- Used ROW_NUMBER() OVER(PARTITION BY ...) to isolate true duplicates
- Verified and deleted duplicates while keeping the correct original rows
3. Standardization
- Trimmed leading/trailing whitespace in company names
- Unified industry labels (e.g., CryptoCurrency → Crypto)
- Standardized country names by removing trailing punctuation
- Converted text-based dates into SQL DATE format
4. Null / Blank Value Handling
- Replaced empty strings with NULL
- Forward-filled missing industries using company-based relational joins
- Identified companies lacking secondary rows for filling (e.g., Bally’s)
5. Row & Column Cleanup
- Removed rows where both total_laid_off and percentage_laid_off were NULL
- Dropped the temporary row_num column after duplicate removal

## Exploratory Data Analysis (EDA)

After cleaning, EDA was performed on the finalized table layoffs_staging2 to identify patterns, trends, and insights.

### EDA Components
1. Shutdown Companies
- Identified companies with percentage_laid_off = 1, indicating a complete workforce layoff.
2. Layoffs by Company
- Calculated total employees laid off per company and ranked highest to lowest.
3. Layoffs by Industry
- Grouped layoffs by industry to determine which sectors were most affected.
4. Layoffs by Country
- Analyzed layoffs by country, highlighting geographic impact.
5. Layoffs by Year
- Summed layoffs by year to observe high-level layoff trends.
6. Layoffs by Funding Stage
- Grouped layoffs by funding stage (e.g., Series A, Series B, Post-IPO).
7. Monthly Trend Analysis
- Used SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) to analyze month-by-month layoffs.
8. Rolling Monthly Total
- Computed cumulative layoffs using window functions to visualize growth over time.
9. Top Companies per Year
- Used CTE + DENSE_RANK() to identify the top 5 companies with the largest layoffs for each year.
10. Industries by Year
- Ranked industries by layoffs per year for deeper sector-level insight.
11. Peak Layoff Month
- Identified the single month with the highest total layoffs across the dataset.

## Key Insights
🔹 Peak Month for Layoffs
January 2023 saw the highest layoffs across all companies with 84,714 employees laid off.

🔹 Industries Hit the Hardest
Consumer, Retail, Other, and Transportation all saw between 33,000 and 45,200 employees laid off over ~3 years.

🔹 Countries with the Highest Layoff Totals
The United States has laid off the highest amount of workers with over six times more than the second-leading country, India. 

🔹 Companies with the Most Layoffs
Amazon, Google, and Meta laid off the most employees with other 11,000 total.

🔹 Trend Over Time
Layoffs increased significantly between 2022 and 2023.

## Files Included
layoffs.csv — raw dataset 

layoffs_staging_table.csv — cleaned dataset 

Layoffs Data Cleaning.sql — complete cleaning script

Layoffs Exploratory Data Analysis.sql — EDA queries

Project Background

This project is part of a SQL course which features beginner, intermediate and advanced SQL, put into practice with the Data Cleaning and Exploratory Data Analysis projects found in this GitHub repository. 

📞 Contact If you'd like to learn more about this project or view similar work, feel free to reach out or explore additional repositories on www.jimeahclariz.com or www.github.com/jimeahcb
