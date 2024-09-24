-- Criação do banco de dados e uso do mesmo

USE myDB2;

-- Criação da tabela employees
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    hourly_pay DECIMAL(5, 2) CHECK (hourly_pay >= 10.00),
    hire_date DATE
);
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    hourly_pay DECIMAL(5, 2) CHECK (hourly_pay >= 10.00),
    hire_date DATE
);
-- Remover a adição de coluna aqui, pois já foi criada na tabela
-- ALTER TABLE employees ADD first_name VARCHAR(50); -- Esta linha é desnecessária

-- Inserção de dados na tabela employees
INSERT INTO employees (first_name, last_name, hourly_pay, hire_date)
VALUES
    ('Carlos', 'Krabs', 25.50, '2023-01-02'),
    ('Squidward', 'Tentacles', 15.00, '2023-01-03'),
    ('Spongebob', 'Squarepants', 12.50, '2023-01-04'),
    ('Patrick', 'Star', 12.50, '2023-01-05'),
    ('Sandy', 'Cheeks', 17.25, '2023-01-06');

-- Seleção inicial
SELECT * FROM employees;

-- Renomear a tabela employees para workers
RENAME TABLE employees TO workers;

-- Adicionar nova coluna phone_number à tabela workers
ALTER TABLE workers 
ADD phone_number VARCHAR(15);

-- Alterar phone_number para email
ALTER TABLE workers 
CHANGE phone_number email VARCHAR(255);

-- Modificar o tamanho da coluna email
ALTER TABLE workers 
MODIFY email VARCHAR(100) AFTER last_name;

-- Alterar posição da coluna email para ser a primeira
ALTER TABLE workers 
MODIFY email VARCHAR(100) FIRST;

-- Remover a coluna email
ALTER TABLE workers 
DROP COLUMN email;

-- Inserir novo funcionário na tabela
INSERT INTO workers (first_name, last_name, hourly_pay, hire_date)
VALUES ('Sheldon', 'Plankton', 10.25, '2023-01-07');

-- Seleção final da tabela workers
SELECT * FROM workers;

-- Criar tabela products com restrição UNIQUE em product_name
CREATE TABLE products ( 
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(25) UNIQUE,
    price DECIMAL(4, 2) NOT NULL DEFAULT 0
);

-- Inserção de dados na tabela products
INSERT INTO products (product_name, price)
VALUES 
    ('hamburger', 3.99),
    ('fries', 1.89),
    ('soda', 1.00),
    ('ice cream', 1.49),
    ('cookie', 0);

-- Seleção da tabela products
SELECT * FROM products;

-- Criar tabela customers (movido para antes das transações para evitar erros de referência)
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

-- Criar tabela transactions com PRIMARY KEY e AUTO_INCREMENT
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(5, 2),
    customer_id INT,
    transaction_date DATETIME DEFAULT NOW(),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- Inserir transações na tabela
INSERT INTO transactions (amount, customer_id)
VALUES 
    (4.99, 1),
    (2.89, 2),
    (3.38, 3),
    (4.99, 1);

-- Seleção da tabela transactions
SELECT * FROM transactions;

-- Seleção com JOIN entre transactions e customers
SELECT transaction_id, amount, c.first_name, c.last_name
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id;

-- Funções agregadas em transactions
SELECT 
    COUNT(amount) AS 'Total Transactions',
    MAX(amount) AS 'Maximum',
    MIN(amount) AS 'Minimum',
    AVG(amount) AS 'Average',
    SUM(amount) AS 'Total'
FROM transactions;

-- Concatenar nome completo em workers
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM workers;

-- Alterar tabela workers para adicionar coluna job
ALTER TABLE workers 
ADD job VARCHAR(25) AFTER hourly_pay;

-- Atualizar job de um funcionário
UPDATE workers
SET job = 'manager'
WHERE employee_id = 1;

-- Consultas com condições
SELECT * FROM workers WHERE hire_date < '2023-01-05' AND job = 'cook';

SELECT * FROM workers WHERE job = 'cook' OR job = 'cashier';

-- Outras consultas baseadas em padrões e condições
SELECT * FROM workers WHERE hire_date LIKE '2023%';

-- Exibir a estrutura da tabela customers
DESCRIBE customers;

-- Exibir a estrutura da tabela employees
DESCRIBE workers;

-- Exibir status do mecanismo InnoDB
SHOW ENGINE INNODB STATUS;

-- Exibir todas as tabelas do banco de dados
SHOW TABLES;

-- Consultar informações sobre colunas no esquema de dados
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, COLUMN_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'myDB2';

-- Ordenação
SELECT * FROM workers ORDER BY last_name ASC;

SELECT * FROM workers ORDER BY last_name DESC;

SELECT * FROM workers ORDER BY hire_date DESC;

SELECT * FROM transactions ORDER BY amount;

SELECT * FROM transactions ORDER BY amount, customer_id;

SELECT * FROM transactions ORDER BY amount ASC, customer_id DESC;

SELECT * FROM customers LIMIT 1; -- colocar 2, 3, 4

SELECT * FROM customers ORDER BY last_name DESC LIMIT 1;

SELECT * FROM customers LIMIT 1, 1; -- colocar 2, 3 no primeiro valor antes da vírgula

SELECT * FROM customers LIMIT 1;

SELECT * FROM customers
LIMIT 10, 10; -- 20,30,40 no primeiro que se refere ao deslocamento

INSERT INTO customers
values(5,"sheldon","plankton");

SELECT first_name, last_name FROM employees
UNION
SELECT first_name, last_name FROM customers;

SELECT first_name, last_name FROM employees
UNION ALL
SELECT first_name, last_name FROM customers;

DELETE FROM customers
where customer_id = 5;

-- Desabilitar o modo de segurança
SET SQL_SAFE_UPDATES = 0;

-- Adicionar a coluna referral_id
ALTER TABLE customers
ADD referal_id INT;

-- Atualizar a coluna referral_id com valores em ordem crescente
SET @row_number = 0;

UPDATE customers
SET referal_id = (@row_number := @row_number + 1);

-- Reabilitar o modo de segurança (opcional)
SET SQL_SAFE_UPDATES = 1;


UPDATE customers
SET referal_id = 1 
WHERE customer_id = 2;

SELECT * FROM customers AS a INNER JOIN customers AS b
ON a.referal_id = b.customer_id;

SELECT a.customer_id, a.first_name, a.last_name, 
       b.first_name AS referal_first_name, b.last_name AS referal_last_name 
FROM customers AS a 
INNER JOIN customers AS b ON a.referal_id = b.customer_id 
LIMIT 0, 1000;


describe customers;
