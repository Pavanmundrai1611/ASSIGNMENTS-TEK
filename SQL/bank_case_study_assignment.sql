SELECT * FROM BANK;

-- give the maximum , mean , min age of the average targeted customer
-- check the quality of customers by checking average balance, median balance of customers
-- check if age matters in marketing subscription for deposit
-- check if marital status mattered for a subscription to deposit
-- check if age and marital status together mattered for a subscription to deposit scheme
-- Do feature engineering for the bank and find the right age effect on the campaign.

alter table bank ADD COLUMN AGE_GROUP VARCHAR(20);  
set sql_safe_updates=0;
UPDATE BANK 
SET AGE_GROUP = IF (AGE <= 25, '<25', IF (AGE>40,'40+', '25-40'));

-- 1. GIVE THE MAXIMUM MEAN AND MINIMUM AGE OF THE AVERAGE TARGETED CUSTOMER

select max(targeted_customer) as max_age,min(targeted_customer) as min_age,avg(targeted_customer) as avg_age from (select age as targeted_customer from bank) as nt;

-- 2. Check the quality of customers by checking averBALANCE balance, median balance of customers
SET @rowindex := -1;
SELECT AVG(BALANCE), (
					SELECT
					   AVG(d.BALANCE) as Median 
					FROM
					   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
							   BANK.BALANCE AS BALANCE
						FROM BANK
						ORDER BY BANK.BALANCE) AS d
					WHERE
					d.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2))
) AS MEDIAN FROM BANK;


-- 3. Check if age matters in marketing subscrpition for deposit
select age_group,y from bank where y='yes' group by age_group;

-- 4. Check if marital status mattered for a subscription to deposit
SELECT MARITAL, COUNT(Y) as success
FROM bank
WHERE Y = 'YES'
GROUP BY MARITAL;

-- 5. Check if age and marital status together matterted for a subscription to deposit scheme.
select age_group,marital,count(y) as success from bank where y='yes' group by age_group,marital;

-- 6. Do feature engineering for the bank and find the right age effect on the campaign.
SELECT AGE_GROUP, COUNT(Y) AS success
FROM BANK
WHERE Y = 'YES'
GROUP BY AGE_GROUP
ORDER BY success DESC;