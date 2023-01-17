CREATE TYPE Gender AS ENUM ('Female', 'Male');
CREATE TYPE MaritalStatus AS ENUM ('Married', 'Single', 'Divorced', 'Widow');
CREATE TYPE HouseType AS ENUM ('House', 'Apartment');



CREATE TABLE addresses
(
    id     serial primary key,
    city   varchar,
    region varchar,
    street varchar
);

CREATE TABLE agencies
(
    id           serial primary key,
    name         varchar,
    phone_number varchar,
    address_id   int references addresses (id)
);

CREATE TABLE owners
(
    id            serial primary key,
    first_name    varchar,
    last_name     varchar,
    email         varchar,
    date_of_birth date,
    gender        Gender
);

CREATE TABLE customers
(
    id            serial primary key,
    first_name    varchar,
    last_name     varchar,
    email         varchar,
    date_of_birth date,
    gender        Gender,
    nationality   varchar,
    family_status MaritalStatus
);

CREATE TABLE houses
(
    id          serial primary key,
    house_type  HouseType,
    price       numeric,
    rating      float,
    description text,
    room        int,
    furniture   boolean,
    address_id  int references addresses (id),
    owner_id    int references owners (id)
);

CREATE TABLE rent_info
(
    id          serial primary key,
    owner_id    int references owners (id),
    customer_id int references customers (id),
    agency_id   int references agencies (id),
    house_id    int references houses (id)
);

ALTER TABLE customers RENAME COLUMN family_status TO marital_status;
ALTER TABLE agencies
    ALTER COLUMN name SET NOT NULL;
ALTER TABLE agencies
    ADD CHECK ( phone_number = '+996%');
ALTER TABLE agencies drop column phone_number;
ALTER TABLE agencies
    add column phone_number varchar;

ALTER TABLE customers
    ADD UNIQUE (email);
ALTER TABLE owners
    ADD UNIQUE (email);
ALTER TABLE rent_info
    add column check_in date;
ALTER TABLE rent_info
    add column check_out date;


-- 1
SELECT first_name, h.house_type
FROM owners
         JOIN houses h on owners.id = h.owner_id
where length(first_name) = 4;

-- 2
SELECT COUNT()
FROM houses
WHERE price BETWEEN 1500 AND 2000;

-- 3
SELECT city, address_id, house_type
FROM houses
         join addresses a on a.id = houses.address_id
WHERE address_id IN (5, 6, 7, 8, 9, 10);


-- 4
SELECT *, customers.last_name, owners.last_name, name
FROM houses
         JOIN customers ON houses.id = customers.id
         JOIN owners on owners.id = houses.owner_id
         join agencies on houses.address_id = agencies.address_id;

-- 5
SELECT *
FROM customers
WHERE date_of_birth > '1999-12-31' LIMIT 15;

-- 6


SELECT house_type, rating, o.first_name
FROM houses
         join owners o on o.id = houses.owner_id
ORDER BY house_type;

-- 7
SELECT COUNT(*), SUM(price)
FROM houses
WHERE house_type = 'Apartment';


-- 8
SELECT *, name
from houses
         join agencies a on houses.address_id = a.address_id
WHERE name = 'My House';


-- 9
SELECT *, last_name, address_id
FROM houses
         JOIN owners o on o.id = houses.owner_id
WHERE furniture = true;

-- 10
SELECT DISTINCT house_type
FROM houses
         join rent_info ri on houses.id = ri.house_id
         join customers c on c.id = ri.customer_id
where ri.customer_id <> ri.house_id;

-- 11
SELECT nationality, COUNT(nationality)
FROM customers
GROUP BY nationality;


-- 12
SELECT max(rating), min(rating), avg(rating)
FROM houses;


-- 13
SELECT *
FROM houses
         join rent_info ri on houses.id = ri.house_id
         join customers c on c.id = ri.customer_id
         join rent_info ri1 on ri1.customer_id = ri.house_id
where ri1.customer_id <> ri.house_id;


-- 14
SELECT avg(price)
FROM houses;

-- 15
SELECT customers.first_name, o.first_name
FROM customers
         JOIN rent_info ri on customers.id = ri.customer_id
         join owners o on ri.owner_id = o.id
where o.first_name like ('A%')
   or customers.first_name like ('A%');

-- 17
SELECT *
FROM customers
WHERE nationality = 'Kyrgyz';

-- 20
SELECT DISTINCT gender
FROM customers;

-- 21
SELECT max(price)
from houses;