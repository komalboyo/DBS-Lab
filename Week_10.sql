//To delete triggers---- drop trigger name;
//select current_date from dual;
// The trigger inserts intot he new table all the rows affected by updation operation

Row Triggers

1. Based on the University database Schema in Lab 2, write a row trigger that records along with the time any change made in the 
  Takes (ID, course-id, sec-id, semester, year, grade) table in log_change_Takes (Time_Of_Change, ID, courseid,sec-id, semester, 
  year, grade).

create table log_change_takes(
	Time_Of_Change date,
	ID			varchar(5), 
	 course_id		varchar(8),
	 sec_id		varchar(8), 
	 semester		varchar(6),
	 year			numeric(4,0),
	 grade		varchar(2),
	 primary key (ID, course_id, sec_id, semester, year),
	 foreign key (course_id,sec_id, semester, year) references section on delete cascade,
	 foreign key (ID) references student on delete cascade
	);
	
create or replace trigger log_takes
BEFORE insert or UPDATE 
OR DELETE on takes
for each row
begin
case
	when inserting then
	  insert into log_change_takes values (current_date, :NEW.ID, :NEW.course_id, :NEW.sec_id, :NEW.semester, :NEW.year, :NEW.grade);
	when updating then
	  insert into log_change_takes values (current_date,:NEW.ID,:NEW.course_id,:NEW.sec_id,:NEW.semester,:NEW.year,:NEW.grade);
  when deleting then
	  insert into log_change_takes values(current_date,:OLD.ID,:OLD.course_id,:OLD.sec_id,:OLD.semester,:OLD.year,:OLD.grade);
end case;
end;
/

insert into takes values ('00128', 'CS-190', '2', 'Spring', '2009', 'A');
delete from takes where id='23121';
update takes set grade ='D' where id ='19991';

2. Based on the University database schema in Lab 2, write a row trigger to insert the existing values of the Instructor 
  (ID, name, dept-name, salary) table into a new table Old_ Data_Instructor (ID, name, dept-name, salary) when the salary table 
  is updated.

create table old_data_instructor
	(ID			varchar(5), 
	 name			varchar(20) not null, 
	 dept_name		varchar(20), 
	 salary	numeric(8,2) check (salary > 29000),
	 primary key (ID),
	 foreign key (dept_name) references department
		on delete set null
	);

create or replace trigger log_instructor_salary_update
before update of salary on instructor
for each row
begin
	insert into old_data_instructor values(:OLD.ID,:OLD.name,:OLD.dept_name,:OLD.salary);
end;
/

UPDATE instructor  SET salary ='30000' where id='15151'; 
UPDATE instructor  SET salary ='30000' where dept_name='Physics'; 


Database Triggers

3. Based on the University Schema, write a database trigger on Instructor that checks the following:
 The name of the instructor is a valid name containing only alphabets.
 The salary of an instructor is not zero and is positive
 The salary does not exceed the budget of the department to which the instructor belongs.

create or replace trigger log_instructor_check
before insert or update of salary on instructor
for each row
declare
sal instructor.salary%TYPE;
budg department.budget%TYPE;
begin
	IF NOT REGEXP_LIKE(:NEW.name, '^[A-Za-z ]+$') THEN
		RAISE_APPLICATION_ERROR(-20100,'Name must contain only alphabets');
ELSE
    IF :NEW.salary < 1 THEN
        RAISE_APPLICATION_ERROR(-20100,'Salary must be greater than 0');
    ELSE
        SELECT SUM(salary) INTO sal FROM instructor WHERE dept_name = :NEW.dept_name;
        SELECT budget INTO budg FROM department WHERE dept_name = :NEW.dept_name;
        IF sal + :NEW.salary > budg THEN
            RAISE_APPLICATION_ERROR(-20100,'Not enough department budget');
        END IF;
    END IF;
END IF;
end;
/

insert into instructor values ('15151', 'Mt', 'Music', '90000');

4. Create a transparent audit system for a table Client_master (client_no, name, address, Bal_due). The system must keep track 
  of the records that are being deleted or updated. The functionality being when a record is deleted or modified the original 
  record details and the date of operation are stored in the auditclient (client_no, name, bal_due, operation, userid, opdate) table,
  then the delete or update is allowed to go through.

create table client_master
	(
		client_no numeric(5,0),
		name varchar(30),
		address varchar(50),
		bal_due numeric(10,2)
	);
	
create table auditclient
	(
		client_no numeric(5,0),
		name varchar(30),
		bal_due numeric(10,2),
		operation varchar(10),
		userid numeric(5,0),
		opdate date
	);
	
create or replace trigger log_client
before update or delete on client_master
for each row
begin
	case
	when updating then
	insert into auditclient values(:OLD.client_no,:OLD.name,:OLD.bal_due,'UPDATE',1,current_date);
	when deleting then
	insert into auditclient values(:OLD.client_no,:OLD.name,:OLD.bal_due,'DELETE',1,current_date);
	end case;
end;
/
  
Instead of Triggers

5. Based on the University database Schema in Lab 2, create a view Advisor_Student which is a natural join on Advisor, Student and 
  Instructor tables. Create an INSTEAD OF trigger on Advisor_Student to enable the user to delete the corresponding entries in 
  Advisor table.

CREATE VIEW Advisor_Student AS 
SELECT Advisor.S_ID, Advisor.I_ID, Student.name S_NAME, Instructor.name I_NAME
FROM Advisor, Student, Instructor WHERE Advisor.S_ID = Student.ID AND Advisor.I_ID = Instructor.ID;
  



