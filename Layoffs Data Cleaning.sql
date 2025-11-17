# DATA CLEANING PROJECT
# fixed issues in raw data (over 2,300 values) to standardize data for visualization

SELECT *
FROM layoffs;			# original data set

CREATE TABLE layoffs_staging
LIKE layoffs;			# create new data set to preserve original data

SELECT *
FROM layoffs_staging;	# display new table 

INSERT layoffs_staging	# insert all of the original data into new table
SELECT *
FROM layoffs; 


# 1) removed duplicates
-- added row numbers for easier identification
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`)  AS row_num
FROM layoffs_staging;

-- searched for duplicate rows (2) using CTE, OVER and PARTITION BY
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)  AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- verify duplicated data
SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

-- we only want to remove the duplicate, not the original row
-- create second table
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` bigint DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
	
SELECT *					# view second table
FROM layoffs_staging2
WHERE row_num > 1;

-- insert information into second table
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)  AS row_num
FROM layoffs_staging;

DELETE						# delete from second table
FROM layoffs_staging2
WHERE row_num > 1;			# now when viewing second table, data is deleted


# 2) standardized data
-- view working table
SELECT *					
FROM layoffs_staging2;

-- delete whitespaces from lhs and rhs of company column
UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry 	# view to determine changes needed
FROM layoffs_staging2
ORDER BY 1;

-- reformatted CryptoCurrency and Crypto Currency to Crypto for standardization
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- deleted trailing . to standardize United States in country column
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- change date into date format, then into date column
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


# 3) evaluate null/blank values to remove or populate
-- view working table
SELECT *					
FROM layoffs_staging2;

-- determine where blank or null values are
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

-- update company with null values to reflect information from known company information
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Bally's was the only one without another row to populate from
SElECT * 
FROM layoffs_staging2
WHERE company LIKE 'Bally%';


# 4) remove unnecessary columns or rows 
-- view working table
SELECT *					
FROM layoffs_staging2;

-- delete rows with NULL total laid off and percentage laid off because uncertain if any laying off occurred at companies at all
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- delete row_num, not needed anymore
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;