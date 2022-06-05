-- Determine Retirement Eligibility
-- Anyone born between 1952 and 1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';



-- look only at how many employees were born in 1952
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';



-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


-- CREATE NEW TABLE
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check data from new table
SELECT * FROM retirement_info;

-- Drop the current retirement_info table.
-- Because we originally created this table from a query, 
-- we haven’t formed any connections to other tables and the CASCADE constraint isn’t needed.
DROP TABLE retirement_info;



-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;



-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;



-- Joining retirement_info and dept_emp tables
-- and create new table to hold current employees
SELECT 
	ri.emp_no,
    ri.first_name,
	ri.last_name,
    de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');
-- Check new table:
SELECT * FROM current_emp;



-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;



-- Create a new table: 
    -- Employee count by department number
    -- organized by the department number
-- then export it as a CSV
SELECT COUNT(ce.emp_no), de.dept_no
INTO dept_current_emp
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
-- Check new table: dept_current_emp
SELECT * FROM dept_current_emp;



--- List 1: Employee Information
SELECT 
    e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date 
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1955-01-01' AND '1955-12-31') 
	AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND (de.to_date = '9999-01-01');
-- Check new table:
SELECT * FROM emp_info;



-- List 2: Managers per department
SELECT 
    dm.dept_no,
    d.dept_name,
    dm.emp_no,
    ce.last_name,
    ce.first_name,
    dm.from_date,
    dm.to_date
INTO manager_info
FROM dept_manager AS dm
	INNER JOIN departments AS d
		ON (dm.dept_no = d.dept_no)
	INNER JOIN current_emp AS ce
		ON (dm.emp_no = ce.emp_no);
-- Check new table
SELECT * FROM manager_info;



-- List 3: Department Retirees
SELECT 
    ce.emp_no,
    ce.first_name,
    ce.last_name,
    d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp as de
	ON (ce.emp_no = de.emp_no)
INNER JOIN departments as d
	ON (de.dept_no = d.dept_no);



-- Skill Drill: New query to create table displaying current employees, eligible for retirement, in "Sales"
SELECT 
    ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
INTO sales_retirement_info
FROM retirement_info as ri
INNER JOIN dept_emp as de 
	ON (ri.emp_no = de.emp_no)
INNER JOIN departments as d
	ON (de.dept_no = d.dept_no)
WHERE (de.to_date = '9999-01-01')
AND (d.dept_name = 'Sales');



-- Skill Drill: New query to create table displaying current employees, eligible for retirement, in "Sales" or "Development" 
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
INTO sales_dev_ri_info
FROM retirement_info as ri
INNER JOIN dept_emp as de
	ON (ri.emp_no = de.emp_no)
INNER JOIN departments as d
	ON (de.dept_no = d.dept_no)
WHERE (de.to_date = '9999-01-01')
AND (d.dept_name IN ('Sales', 'Development'))
ORDER BY (d.dept_name, ri.emp_no);
-- Check new table:
SELECT * FROM sales_dev_ri_info;