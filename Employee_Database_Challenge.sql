-- D E L I V E R A B L E   1 
-- The Number of Retiring Employees by Title

SELECT 
	e.emp_no,
	e.first_name, 
	e.last_name, 
	ti.title, 
	ti.from_date, 
	ti.to_date	
INTO retirement_titles
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
-- between January 1, 1952 and December 31, 1955
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;
-- Check table
SELECT * FROM retirement_titles;


-- remove duplicate employees and only keep
-- the most recent title of each employee
SELECT DISTINCT ON 
	(rt.emp_no) rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title
INTO unique_titles
FROM retirement_titles as rt
WHERE rt.to_date ='9999-01-01'
ORDER BY rt.emp_no, rt.to_date DESC;
-- Check results
SELECT * FROM unique_titles;


-- retrieve the number of employees by their 
-- most recent job title who are about to retire
SELECT COUNT(ut.title), ut.title
INTO retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title
ORDER BY COUNT(ut.title) DESC;
-- Check table
SELECT * FROM retiring_titles;



-- D E L I V E R A B L E   2
-- Employees Eligible for the Mentorship Program

-- create a table holds the current employees who were 
-- born between January 1, 1965 and December 31, 1965.

-- use 'SELECT DISTINCT ON' to avoid duplicates
SELECT DISTINCT ON 
	(e.emp_no) e.emp_no,
	e.first_name,
    e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
INTO mentorship_eligibilty
FROM employees as e
INNER JOIN dept_emp as de
	ON (e.emp_no = de.emp_no)
INNER JOIN titles as ti
	ON (e.emp_no = ti.emp_no)
WHERE 
	(e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	 -- include only current employees
	 AND (de.to_date = '9999-01-01')
ORDER BY 
	e.emp_no, ti.from_date DESC;
-- check table
SELECT * FROM mentorship_eligibilty;




-- A D D I T I O N A L  Q U E R I E S (NONs)
-- The Number of Non Retiring Employees by Title

SELECT 
	e.emp_no,
	e.first_name, 
	e.last_name, 
	ti.title, 
	ti.from_date, 
	ti.to_date	
-- INTO non_retirement_titles
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
-- not between January 1, 1952 and December 31, 1955
WHERE (e.birth_date NOT BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;
-- Check table
SELECT * FROM non_retirement_titles;


-- remove duplicate employees and only keep
-- the most recent title of each employee
SELECT DISTINCT ON 
	(nrt.emp_no) nrt.emp_no,
	nrt.first_name,
	nrt.last_name,
	nrt.title
INTO non_unique_titles
FROM non_retirement_titles as nrt
WHERE nrt.to_date ='9999-01-01'
ORDER BY nrt.emp_no, nrt.to_date DESC;
-- Check results
SELECT * FROM non_unique_titles;


-- retrieve the number of employees by their 
-- most recent job title who are about to retire
SELECT COUNT(ut.title), ut.title
INTO non_retiring_titles
FROM non_unique_titles AS ut
GROUP BY ut.title
ORDER BY COUNT(ut.title) DESC;
-- Check table
SELECT * FROM non_retiring_titles;


