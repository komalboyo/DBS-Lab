SET SERVEROUTPUT ON;

1. Write a procedure to display a message “Good Day to You”.

CREATE OR REPLACE PROCEDURE print_msg as
BEGIN 
	dbms_output.put_line('Good Day to You!');
END;
/

DECLARE
BEGIN 
	print_msg;
END;
/

2. Based on the University Database Schema in Lab 2, write a procedure which takes the dept_name as input parameter and lists all the instructors associated with the department as well as list all the courses offered by the department. Also, write an anonymous block with the procedure call.

CREATE OR REPLACE PROCEDURE instructor_courses(dept instructor.dept_name%TYPE) as
cursor inst is (select name from instructor where dept_name=dept);
cursor course is (select title from course where dept_name=dept);
BEGIN
	dbms_output.put_line('Instructors:	');
	for i in inst LOOP
		dbms_output.put_line(i.name);
	END LOOP;
	dbms_output.put_line('Courses:		');
	for i in course LOOP
		dbms_output.put_line(i.title);
	END LOOP;
END;
/

DECLARE
y instructor.dept_name%TYPE;
BEGIN
	y := '&Department_name';
	instructor_courses(y);
END;
/

3. Based on the University Database Schema in Lab 2, write a Pl/Sql block of code 
that lists the most popular course (highest number of students take it) for each of 
the departments. It should make use of a procedure course_popular which finds 
the most popular course in the given department.

CREATE OR REPLACE PROCEDURE popular_courses as
CURSOR c is with taken_by(dept_name, course_id, c) as (select dept_name, course_id,count(course_id) c from takes natural join course group by dept_name, course_id) 
select s.course_id, s.dept_name, s.c from taken_by s where s.c >=all(select t.c from taken_by t where t.dept_name=s.dept_name);
BEGIN
	for i in c LOOP
	dbms_output.put_line('Dept_name:	'||i.dept_name||'   Course:	'||i.course_id);
	END LOOP;
END;
/

DECLARE
BEGIN
	popular_courses;
END;
/

4. Based on the University Database Schema in Lab 2, write a procedure which takes the dept-name as input parameter and lists all the students associated with the department as well as list all the courses offered by the department. Also, write an anonymous block with the procedure call.

CREATE OR REPLACE PROCEDURE students_courses (d instructor.dept_name%TYPE) as
cursor c1 is (select name from student where dept_name=d);
cursor c2 is (select title from course where dept_name=d);
BEGIN
	dbms_output.put_line('Students:');
	for i in c1 LOOP
		dbms_output.put_line(i.name);
	END LOOP;
	dbms_output.put_line('Courses:');
	for i in c2 LOOP
		dbms_output.put_line(i.title);
	END LOOP;
END;
/

DECLARE
BEGIN
	students_courses('&Dept_name');
END;
/

5. Write a function to return the Square of a given number and call it from an anonymous block.

CREATE OR REPLACE FUNCTION square(n number) 
RETURN integer
as
s integer;
BEGIN
	s := n*n;
RETURN s;
END;
/

DECLARE 
BEGIN
	dbms_output.put_line(square('&Enter_number'));
END;
/

6. Based on the University Database Schema in Lab 2, write a Pl/Sql block of code 
that lists the highest paid Instructor in each of the Department. It should make use of a function department_highest which returns the highest paid Instructor for the given branch.

CREATE OR REPLACE FUNCTION dept_highest(d instructor.dept_name%TYPE)
RETURN instructor.name%TYPE
as
n instructor.name%TYPE;
BEGIN
	select i.name into n from instructor i where i.dept_name=d and i.salary >= all(select t.salary from instructor t where t.dept_name=d);
	RETURN n;
END;
/

DECLARE
CURSOR c is (select dept_name from department);
d instructor.dept_name%TYPE;
BEGIN
OPEN c;
	LOOP
		FETCH c into d;
		EXIT when c%NOTFOUND;
		dbms_output.put_line(d||'    '||dept_highest(d));
	END LOOP;
CLOSE c;
END;
/

7. Based on the University Database Schema in Lab 2, create a package to include 
the following:
 a) A named procedure to list the instructor_names of given department
 b) A function which returns the max salary for the given department
 c) Write a PL/SQL block to demonstrate the usage of above package components

create or replace package q7 as
procedure dept_inst(dname varchar);
function dept_highest(dname varchar) return number;
end q7;
/

create or replace package body q7 as
procedure dept_inst(dname varchar) is
cursor inst is (select name from instructor where dept_name=dname);
begin
	dbms_output.put_line('Instructors');
	for i in inst loop
		dbms_output.put_line(i.name);
	end loop;
end;
function dept_highest(dname varchar) 
return number as
inst_max number;
begin
	select max(salary) into inst_max from instructor where dept_name=dname;
	return inst_max;
end;
end q7;
/

declare
cursor c is (select dept_name from department);
begin
	for i in c loop
		q7.dept_inst(i.dept_name);
		dbms_output.put_line('Maximum Salary of '||i.dept_name||' is '||q7.dept_highest(i.dept_name));
	end loop;
end;
/

8. Write a PL/SQL procedure to return simple and compound interest (OUT 
parameters) along with the Total Sum (IN OUT) i.e. Sum of Principle and Interest 
taking as input the principle, rate of interest and number of years (IN parameters). Call this procedure from an anonymous block.

create or replace procedure simp_comp(principle in number,rate in number,years in number,times in number,SI out numeric,CI out numeric,tot_sum in out numeric) as
begin
	SI :=(principle*rate*years)/100;
	CI :=principle*power((1+rate/times),times*years);
	tot_sum := principle + SI + CI;
end;
/

declare
SI numeric(10,2);
CI numeric(10,2);
tot_sum numeric(10,2);
begin
	simp_comp(10000,5,2,3,SI,CI,tot_sum);
	dbms_output.put_line('Simple Interest '||SI);
	dbms_output.put_line('Compound Interest '||CI);
	dbms_output.put_line('Tot Sum '||tot_sum);
end;
/
