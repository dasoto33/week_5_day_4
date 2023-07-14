-- CREATE (optional: OR REPLACE) FUNCTION <name of func>(<parameters> <param datatype>)
-- RETURNS <return data type> 
-- LANGUAGE plpgsql $$  (Procedureal Language Postgres Sql)  
-- 	BEGIN 
--	 <function body>;
-- END;
-- $$

-- Call function:
-- SELECT <name of function>(<required args>)


-- Function that doubles a number (multiplies by 2)
create function doubleNumber(num integer) returns integer
language plpgsql as $$
	begin
		return num * 2;
	end;
$$

select doubleNumber(10);

-- Function to square a number

create function squareNumb(num integer) returns integer
language plpgsql as $$
	begin
		return num ^ 2; -- ^ to square (** doesn't work in SQL)
	end;
$$

select squareNumb(10);

-- Another way to square using POWER

create or replace function squareNum(num integer) returns integer
language plpgsql as $$
	begin
		return power(num,2); -- POWER then num, power to be used
$$

select squareNum(10);

-- Create function to make a late fee

ALTER payment
ALTER COLUMN payment_date timestamp NULL;
DROP FUNCTION IF EXISTS payLateFee;
CREATE OR replace FUNCTION payLateFee(
	_rental_id INTEGER, 
	_customer_id INTEGER,
	_staff_id INTEGER
)
RETURNS INTEGER
LANGUAGE plpgsql AS $$
	BEGIN
		INSERT INTO payment(
			customer_id,
			staff_id,
			rental_id,
			amount,
			payment_date
		)VALUES(
			_customer_id,
			_staff_id,
			_rental_id,
			3.00,
--			CURRENT_TIMESTAMP()
			NOW()
		);
		RETURN _customer_id;
	END
$$
SELECT * FROM rental WHERE return_date IS null;
SELECT * FROM payment;

SELECT * FROM customer
WHERE customer_id = (SELECT payLateFee(11496, 155, 1));

SELECT * FROM payment 
WHERE customer_id = 155 AND rental_id = 11496;

-- Procedures:

-- CREATE (optional: OR REPLACE) <name of procedure>(<params> <datatype>)
-- AS $$
-- BEGIN
--	<procedure body>;
-- COMMIT;
-- END
-- $$
-- LANGUAGE as pgsql


-- Procedure that updates payment_date column in payment

CREATE OR REPLACE PROCEDURE updateReturnDate(
	rentalId INTEGER, 
	customerId INTEGER
) AS $$
BEGIN
	UPDATE rental
	SET return_date = current_timestamp
	WHERE rental_id = rentalId 
	AND customer_id = customerId;
	COMMIT;
END
$$
LANGUAGE plpgsql;

CALL updateReturnDate(11496,155);
SELECT * FROM rental
WHERE rental_id = 11496 AND customer_id = 155;

-- Procedure that updates customer email

CREATE or replace PROCEDURE updateEmail (
	_customer_id INTEGER,
	_email VARCHAR	
	) AS $$
		BEGIN
			UPDATE customer 
			SET email = _email
			WHERE customer_id = _customer_id;
			COMMIT;
		END
	$$
	LANGUAGE plpgsql
	
SELECT * FROM customer c WHERE customer_id = 524 
	
CALL updateEmail(524, 'j.ely@example.com');

-- Procedure to add new actor

create procedure addActor(
	firstName varchar, 
	lastName varchar
) language plpgsql as $$
	begin
		insert into actor(
			first_name,
			last_name,
			last_update 
		)values(
			firstName,
			lastName,
			now()
		);
		commit;
	end
$$

call addActor('Sean', 'Currie');

call addActor('Tom', 'Hardy');

select *
from actor
where first_name = 'Sean' and last_name = 'Currie'

select *z 
from actor
where first_name = 'Tom' and last_name = 'Hardy'












	