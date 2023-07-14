-- Using E-commerce Database

-- Funtion that finds total number of customers:

CREATE FUNCTION








-- Procedure to add a new product to product table:

CREATE OR REPLACE PROCEDURE newProduct(
	newName varchar,
	aDescription varchar
) LANGUAGE plpgsql AS  $$
	BEGIN
		INSERT INTO product(
			name,
			description
		)values(
			newName,
			aDescription
		);
		COMMIT;
	END
$$	

call newProduct('Humidifier', 'Purifies and humidifies air');

select *
from product
where name = 'Humidifier'