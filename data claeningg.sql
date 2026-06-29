-- data cleaning

select * from layoffs;
/*remove duplicates
standardizes the data
null values or blank values
remove any coulmns */

-- create new table with same dataset by the fallowing way because we need to keep our rwa data for strong basic data

create table layoffs_staging 
like layoffs;

select * from layoffs_staging;

-- insert all the data into new table 

insert into layoffs_staging
select * from layoffs; 

select *,row_number() over(partition by company,location,industry,total_laid_off,
percentage_laid_off,date,stage,country,funds_raised_millions) as row_num
from layoffs_staging order by company;

select company from layoffs_staging;

-- by this we find the duplicate data

with duplicate_cte as
(
select *,row_number() over(partition by company,location,industry,total_laid_off,
percentage_laid_off,date,stage,country,funds_raised_millions) as row_num
from layoffs_staging order by company) 
delete from duplicate_cte where row_num>1;

-- delete the duplicate data
with duplicate_cte1 as
(
select *,row_number() over(partition by company,location,industry,total_laid_off,
percentage_laid_off,date,stage,country,funds_raised_millions) as row_num
from layoffs_staging order by company) 
delete from duplicate_cte1 where row_num>1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs_staging2;

insert into layoffs_staging2 
select  *,row_number() over(partition by company,location,industry,total_laid_off,
percentage_laid_off,date,stage,country,funds_raised_millions) as row_num
from layoffs_staging order by company;

select * from layoffs_staging2 where row_num=2;

delete from layoffs_staging2 where row_num>1;

SET SQL_SAFE_UPDATES = 0;

select * from layoffs_staging2;

-- standardize the data
select company,trim(company) from layoffs_staging2;

update layoffs_staging2 set company=trim(company);

select distinct company from layoffs_staging2;

select distinct country from layoffs_staging2;

-- this we perfrom to remove the last . from countryy
update layoffs_staging2 set country=trim(trailing '.' from country);
 
select distinct industry from layoffs_staging2;

select * from layoffs_staging2 where industry like 'crypto%';
-- to modify industry name correctly
update layoffs_staging2
set industry='crypto'
where industry like 'crypto%';

select distinct location from layoffs_staging2;

select * from layoffs_staging2;

select `date`,
str_to_date(`date`,'%m/%d/%Y') from layoffs_staging2;

update layoffs_staging2 
set `date`= str_to_date(`date`,'%m/%d/%Y');
 
select * from layoffs_staging2 where industry is null or industry='';

update layoffs_staging2 set industry= null where industry='';

select * from layoffs_staging2 where company is null or company='';
select * from layoffs_staging2 where location is null or location='';

select * from layoffs_staging2;

select * from layoffs_staging2 where company='Airbnb';

update layoffs_staging2 set industry='travel'
where company='Airbnb';

select * from layoffs_staging2 where company='Carvana';

select t1.industry,t2.industry
    from layoffs_staging2 t1
    join layoffs_staging2 t2
      on t1.company=t2.company
where (t1.industry is null or t1.industry='')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
      on t1.company=t2.company
      set t1.industry=t2.industry
where (t1.industry is null or t1.industry='')
and t2.industry is not null;

select * from layoffs_staging2 where company="Bally's Interactive";


-- remove nulll values
 
select * from layoffs_staging2 where total_laid_off is null
 and percentage_laid_off is null; 
 
delete from layoffs_staging2 where total_laid_off is null
 and percentage_laid_off is null;
 
select * from layoffs_staging2;

alter table layoffs_staging2 drop column row_num;
