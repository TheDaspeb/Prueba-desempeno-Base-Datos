select * from mega_store.raw_data 


CREATE TABLE mega_store.raw_data (
    transaction_id VARCHAR(50) not null,
    transaction_date DATE not null,
    customer_name VARCHAR(120) not null,
    customer_email VARCHAR(150) not null,
    customer_address TEXT not null,
    customer_phone varchar (20) not null,
    product_category VARCHAR(100) not null,
    product_sku VARCHAR(50) not null,
    product_name VARCHAR(150) not null,
    unit_price NUMERIC(10,2) not null,
    quantity INT not null,
    total_line_value numeric (10,2) not null,
    supplier_name VARCHAR(120) not null,
    supplier_email VARCHAR(150) not null
);

-- TABLA DE CLIENTES

create table mega_store.customers (
    id_customer SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) UNIQUE NOT NULL,
    customer_address VARCHAR(150) NOT NULL,
    customer_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT now()
);

alter table mega_store.customers rename column customer_addres to customer_address;



-- TABLA DE PROVEEDORES

CREATE TABLE mega_store.suppliers (
    id_supplier SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    supplier_email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT now()
);

--TABLA DE PRODUCTOS 

CREATE TABLE mega_store.products (
    product_sku varchar(50) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    product_description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    id_supplier INT,
    created_at TIMESTAMP DEFAULT now(),
    CONSTRAINT fk_product_supplier
        FOREIGN KEY (id_supplier)
        REFERENCES  mega_store.suppliers(id_supplier)
        ON DELETE SET NULL
);

-- TABLA DE PEDIDOS 

drop table mega_store.orders cascade 

CREATE TABLE mega_store.orders (
    id_order SERIAL PRIMARY KEY,
    id_customer INT NOT NULL,
    order_date TIMESTAMP DEFAULT now(),
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT now(),
    transaction_id varchar (50) unique, 
    CONSTRAINT fk_orders_customer
        FOREIGN KEY(id_customer)
        REFERENCES mega_store.customers(id_customer)
        ON DELETE CASCADE
);

-- TABLA DE DETALLES DE PEDIDOS 

drop table mega_store.order_items cascade 

CREATE TABLE mega_store.order_items (
    id_order_item SERIAL PRIMARY KEY,
    id_order INT NOT NULL,
    product_sku varchar(50) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_order)
    REFERENCES mega_store.orders(id_order)
    ON DELETE CASCADE,
    FOREIGN KEY (product_sku)
    REFERENCES mega_store.products(product_sku)
    ON DELETE CASCADE
);

-- TABLA DE TRANSACCIONES 

CREATE TABLE transactions (
    id_transaction SERIAL PRIMARY KEY,
    transaction_code VARCHAR(30) NOT NULL,
    id_order INT NOT NULL,
    id_supplier INT,
    amount DECIMAL(12,2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT now(),
    FOREIGN KEY (id_order)
    REFERENCES mega_store.orders(id_order)
    ON DELETE CASCADE,
    FOREIGN KEY (id_supplier)
    REFERENCES mega_store.suppliers(id_supplier)
    ON DELETE SET NULL
);

--migrar info a las tablas creadas. 


insert into mega_store.suppliers  (supplier_name, supplier_email)
select distinct 
	supplier_name,
	supplier_email
from mega_store.raw_data rd 

insert into mega_store.customers (customer_name, customer_email, customer_address, customer_phone) 
select distinct 
	customer_name, 
	customer_email, 
	customer_address, 
	customer_phone
from mega_store.raw_data rd 

--se corrige serial por varchar por el id del producto o referencia 

alter table mega_store.products
alter column product_sku type varchar (50) primary key
using product_sku::varchar

drop table mega_store.products cascade; 

insert into mega_store.products (product_sku, product_name, price, id_supplier)
select distinct 
	rd.product_sku, 
	rd.product_name, 
	rd.unit_price, 
	s.id_supplier
from mega_store.raw_data rd
join mega_store.suppliers s
	on rd.supplier_email = s.supplier_email ;

insert into mega_store.orders (id_customer , order_date)
select distinct 
	c.id_customer,
	rd.transaction_date 
from mega_store.raw_data rd 
join mega_store.customers c 
	on rd.customer_email = c.customer_email 

	
insert into mega_store.order_items (id_order, product_sku, quantity, price)
select 
	o.id_order,
	p.product_sku,
	rd.product_sku,
	rd.unit_price
from mega_store.raw_data rd
join mega_store.orders o 
	on rd.transaction_id = o.transaction_id 
join mega_store.products p 
	on rd.product_sku = p.product_sku 

	
