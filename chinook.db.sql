-- using SQL to do some data exploration of chinook database

create view customers_artists AS
select 
artists.name AS band,
    customers.country AS cus_country,
    customers.customerid AS id
from customers,invoices,invoice_items,tracks,albums,artists
WHERE customers.customerid = invoices.customerid
AND invoices.invoiceid = invoice_items.invoiceid
and invoice_items.trackid = tracks.trackid
AND tracks.albumid = albums.albumid
AND albums.artistid = artists.artistid;

-- How many customers buy Metallica songs for each country?
SELECT band, cus_country,COUNT(cus_country) AS n  FROM customers_artists
WHERE  band = 'Metallica'
group BY 1,2
order by 3 DESC

-- Top 5 selling artists 
SELECT band, COUNT(id) AS n  FROM customers_artists
group BY 1
order by 2 DESC
LIMIT 5

-- which country has the most invoices?
select billingcountry, COUNT(customerid) AS n 
from invoices
GROUP BY 1 
ORDER BY 2 DESC
LImit 1

-- top 5 city has the most invoice
SELECT billingcity, billingcountry, sum(total) total_spent 
FROM invoices
GROUp BY 1 
ORDER BY 3 DESC 
LIMIT 5

-- the customers who has spent the most money.
SELECT 	customers.firstname,
	customers.lastname,
        invoices.billingcity,
        sum(invoices.total) total_spent 
FROM customers, invoices WHERE customers.customerid = invoices.customerid
GROUP BY 1,2 ORDER BY 4 DESC LIMIT 1

-- how many songs base on genre does customer 12 bought
SELECT 	customers.customerid id,
	count(tracks.name) n
FROM customers,invoices,invoice_items,tracks
where customers.customerid = invoices.customerid
AND invoices.invoiceid = invoice_items.invoiceid
and invoice_items.trackid = tracks.trackid
AND id = 13






