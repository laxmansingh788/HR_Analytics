CREATE DATABASE HR_ANALYTICS

USE HR_ANALYTICS

-- Create 'departments' table
CREATE TABLE departments (
 id INT IDENTITY(1,1) PRIMARY KEY,
 name VARCHAR(50),
 manager_id INT
);
-- Create 'employees' table
CREATE TABLE employees (
 id INT IDENTITY(1,1) PRIMARY KEY,
 name VARCHAR(50),
 hire_date DATE,
 job_title VARCHAR(50),
 department_id INT REFERENCES departments(id)
);
-- Create 'projects' table
CREATE TABLE projects (
 id INT IDENTITY(1,1) PRIMARY KEY,
 name VARCHAR(50),
 start_date DATE,
 end_date DATE,
 department_id INT REFERENCES departments(id)
);

-- Insert data into 'departments'
INSERT INTO departments (name, manager_id)
VALUES ('HR', 1), ('IT', 2), ('Sales', 3);

-- Insert data into 'employees'
INSERT INTO employees (name, hire_date, job_title, department_id)
VALUES ('John Doe', '2018-06-20', 'HR Manager', 1),
 ('Jane Smith', '2019-07-15', 'IT Manager', 2),
 ('Alice Johnson', '2020-01-10', 'Sales Manager', 3),
 ('Bob Miller', '2021-04-30', 'HR Associate', 1),
 ('Charlie Brown', '2022-10-01', 'IT Associate', 2),
 ('Dave Davis', '2023-03-15', 'Sales Associate', 3);

-- Insert data into 'projects'
INSERT INTO projects (name, start_date, end_date, department_id)
VALUES ('HR Project 1', '2023-01-01', '2023-06-30', 1),
 ('IT Project 1', '2023-02-01', '2023-07-31', 2),
 ('Sales Project 1', '2023-03-01', '2023-08-31', 3);
 INSERT INTO projects (name, start_date, end_date, department_id)
VALUES ('HR Project 2', '2023-01-01', '2023-08-30', 1) 
 
SELECT * FROM departments
SELECT * FROM employees
SELECT * FROM projects

-- SQL Challenge Questions

--1. Find the longest ongoing project for each department.

SELECT * FROM (
SELECT departments.id, departments.name 'Department_name', projects.name 'Project_name', start_date, end_date,  
DATEDIFF(DAY, start_date, end_date) 'Project_duration', 
ROW_NUMBER() OVER(PARTITION BY departments.name ORDER BY DATEDIFF(DAY, start_date, end_date) DESC) 'Ranks' FROM departments
INNER JOIN projects
ON departments.id = projects.department_id
) A
WHERE Ranks = 1


--2. Find all employees who are not managers.
SELECT * FROM employees
LEFT JOIN departments
ON employees.department_id = departments.id
WHERE employees.id NOT IN (manager_id)


--3. Find all employees who have been hired after the start of a project in 
-- their department.

SELECT * FROM employees
LEFT JOIN projects
ON employees.department_id = projects.department_id
WHERE hire_date > start_date


--4. Rank employees within each department based on their hire date (earliest 
-- hire gets the highest rank).SELECT *, ROW_NUMBER() OVER(PARTITION BY departments.name ORDER BY hire_date) 'Ranks' FROM employeesLEFT JOIN departmentsON employees.department_id = departments.id--5. Find the duration between the hire date of each employee and the hire date 
-- of the next employee hired in the same department.SELECT *, DATEDIFF(DAY, new_date, hire_date) 'Duration' FROM (SELECT employees.id, employees.name, hire_date, job_title, department_id, departments.name 'Department_name', LAG(hire_date, 1) OVER(PARTITION BY departments.name ORDER BY hire_date) 'new_date' FROM employeesLEFT JOIN departmentsON employees.department_id = departments.id) B