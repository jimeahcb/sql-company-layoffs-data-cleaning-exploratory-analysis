# EXPLORATORY DATA ANALYSIS FOR LAYOFFS DATASET
-- Author: Jimeah Buyao
-- Cleaned dataset: layoffs_staging2 from world_layoffs
-- Purpose: Generate insights for visualization and reporting.

# view working table
SELECT *
FROM layoffs_staging2;

# looking at the cleaned dataset
SELECT *									# view companies who went under and laid off all employees
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)			# total number of employees laid off per company
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)				# find the date range of when these layoffs occurred 
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)		# total number of layoffs per industry
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)			# total number of layoffs per country
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)	# total number of layoffs per year
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)			# total number of layoffs per stage
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)		# viewing all the layoffs in each month since dataset started
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_Total AS												# rolling total so next month's total is added onto the previous month's total and so on
(																	# shows us a month by month progression of total layoffs across all months in dataset
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER (ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT company, YEAR(`date`),  SUM(total_laid_off)					# viewing the largest totals of people laid off sorted by company and year 
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year (company, years, total_laid_off) AS				# looks at top 5 companies with largest laid off total per year with CTEs 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5;

SELECT industry, YEAR(`date`) AS yr, SUM(total_laid_off) AS total_off			# industry layoff totals per year
FROM layoffs_staging2
GROUP BY industry, yr
ORDER BY yr DESC, total_off DESC;

SELECT DATE_FORMAT(`date`, '%Y-%m') AS month, SUM(total_laid_off) AS total_off	# isolating the month with the most layoffs across all companies
FROM layoffs_staging2
GROUP BY month
ORDER BY total_off DESC
LIMIT 1;


