#1 select database
Use  please;

#2 display all tablesnames
show tables;

#3 show customer table
select * from customer;

#4 print names of customers from customer table
select firstname ,lastname  from customer;

#5show details of customer from berlin
select * from customer where city='berlin';


#6 print number of customers
select count(*) as numberofcustomers from customer;

#7 print number of customers from different countries
select country,count(*) as numberofcutomers from customer group by country;

#8 print country with maximum customers (if there are multiple countries with maximum customers then sort by country)
select country,count(*) as numberofcustomers from customer group by country order by numberofcustomers desc,country limit 1;

#9 print details of order along with details of customers
select * from customer c join orderdetails od on c.id=od.customerid order by c.id; 

#10 print details of 'PAUL' from  item ,customer and orderdetails tables 
select * from customer c join orderdetails od on c.id=od.customerid  join item i on i.orderid=od.id WHERE FIRSTNAME='PAUL'; 

#11 PRINT DETAILS OF PRODUCT/PRODUCTS FROM ORDER  WHERE ORDER ID =1
select * from PRODUCT P   join item i on P.id=i.productid where i.orderid=1;

#12 print full name of customer who bought tofu
select concat(d.firstname," ",d.lastname) as fullname from 
(select productname, firstname,lastname from customer c join orderdetails od on c.id=od.customerid join item i on od.id=i.orderid join
 product p on i.productid=p.id group by productname)d where d.productname ='tofus';
 
#13 name all the supplier details of products which are not discontinued
select s.*,p.productname  from supplier s   join product p on s.id=p.supplierId where p.isdiscontinued=0s;

#14  print spending of  order per item

select od.id,od.totalamount/sum(i.quantity) as spendperitem from customer c join orderdetails od on c.id=od.customerid join item i  on od.id=i.orderid group by od.id  order by  od.id ;

#15   print data from customer and supplier tables

 select * from customer cross join supplier;
 
 #16   print data where customer is from germany and supplier is from france
  select * from customer c cross join supplier s where c.country ='germany' and s.country ='france';

#17 PRINT FIRST NAMES AND COMPANY NAMES FROM SAME COUNTRY
SELECT c.firstname,s.companyname FROM customer c join
orderdetails od on c.id=od.customerid  join
item i on od.id=i.orderid join
product p on i.productid=p.id join
supplier s on s.id= p.supplierid
where c.country=s.country; 
  
#18  give phone number of supplier in case fax is not given
 SELECT companyname,contactname,COALESCE(fax,phone)as fax  FROm supplier ;
 
#19 print country if id<40 else print city
select id,if(id>40, city,country)as output from customer ;

#20 suppose owner wants to CATEGORIZE ITEMS  AS CHEAP IF UNITPRICE <40 ,REASONABLE IF BETWEEN (40,100) AND EXPENSIVE IF UNITPRICE>100 
select  unitprice,(case
when unitprice>100  then 'EXPENSIVE'
when unitprice>40  then 'REASONABLE'
else  'CHEAP'
end)selection
from item order by unitprice;
 
 #21 PRINT DETAILS OF CUSTOMER HAVING SAME COUNTRY BUT DIFFERENT CITY
 SELECT * FROM CUSTOMER C1 JOIN  CUSTOMER C2 ON C1.COUNTRY=C2.COUNTRY AND C1.CITY <> C2.CITY;#SELF JOIN IS USED
  
#22 CREATE A PROCEDURE WHICH ASKS FOR CUSTOMER ID AND GIVES FIRSTNAME OF CUSTOMER
DELIMITER $$
CREATE PROCEDURE CUSTOMERINFO(IN p_custid integer,OUT p_firstname varchar(255))

BEGIN
SELECT c.firstname  INTO p_firstname FROM customer c WHERE
c.id = p_custid ;
END$$

DELIMITER 

#23 create a function that takes first and last name of customer and give total amount spend by customer
DELIMITER $$
CREATE FUNCTION task(p_first_name varchar(255), p_last_name varchar(255)) RETURNS int 
DETERMINISTIC NO SQL READS SQL DATA
BEGIN
DECLARE v_totalamount int;
SELECT    sum(od.totalamount)
INTO v_totalamount FROM
    customer c
        JOIN
    orderdetails od ON  c.id=od.customerid
WHERE    c.firstname = p_first_name
        AND c.lastname = p_last_name;
  Return v_totalamount ;
END$$

DELIMITER ;

#24  SELECT CUSTOMER NAME  WHO SPENT THE MOST AMOUNT OF MONEY,ROUND THE FIGURE TO NEAREST INTEGER

SELECT    C.FIRSTNAME,ROUND(sum(od.totalamount)) AS TOTALCUTOMEREXPENDITURE FROM
customer c
JOIN
orderdetails od ON  c.id=od.customerid
GROUP BY C.FIRSTNAME ORDER BY TOTALCUTOMEREXPENDITURE DESC LIMIT 1;
 
#25 CREATE A TRIGGER THAT CHECK WHETEHER UNIT PRICE OF AN ITEM IS NEGATIVE AND IF TRUE ITS SETS THE UNIT PRICE AS O 
task DELIMITER $$
CREATE TRIGGER trig_UP  
BEFORE INSERT ON ITEM
FOR EACH ROW  
BEGIN  
IF NEW.UNITPRICE <0 
THEN           SET NEW.UNITPRICE = 0 ;     
			    END IF;  
                END $$  
DELIMITER ;  
 INSERT INTO item  VALUES(2156,504,26,-12,12);		
 select * from item where id =2156;
 
 #26. rank  the customer according to their overallexpenditure(totalscores of all the orders)
 
SELECT    C.FIRSTNAME,ROUND(sum(od.totalamount)) AS TOTALCUTOMEREXPENDITURE,
rank() over(order by ROUND(sum(od.totalamount))) as ranknumber FROM
customer c
JOIN
orderdetails od ON  c.id=od.customerid
GROUP BY C.FIRSTNAME ORDER BY TOTALCUTOMEREXPENDITURE ;

 #27. PRINT THE SUM OF TOTAL AMOUNT OF 3 ORDERS(ONE ABOVE ,ITSELF AND ONE BELOW) OR 3CONSECUTIVE ORDER SUM 
 
SELECT id,totalamount,sum(totalamount)OVER(order by id ROWs BETWEEN 1 PRECEDING AND 1 FOLLOWING)threeentrysum from orderdetails ;

#28. print the running sum for totalamount  according to  ids
SELECT id,totalamount,sum(totalamount)OVER(order by id ROWs BETWEEN  unbounded PRECEDING AND current row)threeentrysum from orderdetails;

#29.PRINT THE MOVING AVERAGE FOR TOTALAMOUNT

SELECT id,totalamount,AVG(totalamount)OVER(order by id ROWs BETWEEN  unbounded PRECEDING AND current row)threeentrysum from orderdetails;

#30 PRINT  PRODUCTNAME  AND THEIR QUANTITIES IN A SINGLE ROW LIKE A SUMMARY FOR FIRST 5 ITEM IDS
SELECT GROUP_CONCAT(CONCAT(P.PRODUCTNAME,'-',I.QUANTITY) ,' ')AS SUMMARY FROM PRODUCT P  JOIN
ITEM I ON P.ID=I.PRODUCTID 
 WHERE I.ID<6 ;
 


