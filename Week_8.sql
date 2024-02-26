1. The HRD manager has decided to raise the salary of all the Instructors in a given department number by 5%. Whenever, any such raise is given to the instructor, a record for the same is maintained in the salary_raise table. It includes the Instuctor Id, the date when the raise was given and the actual raise amount. Write a PL/SQL block to update the salary of each Instructor and insert a record in the salary_raise table.
salary_raise(Instructor_Id, Raise_date, Raise_amt)

create table salary_raise( Instructor_ID varchar(5),
Raise_date Date,
Raise_amt numeric(8,2),
foreign key (Instructor_ID) references instructor);

DECLARE
cur_date DATE;
dname CONSTANT instructor.dept_name%type := 'History';
temp_id instructor.ID%TYPE;
Old_sal instructor.salary%TYPE;
New_sal instructor.salary%TYPE;
Cursor C1 is select ID from Instructor where dept_name = dname; 

BEGIN
Open c1;
Loop
Fetch C1 into temp_id;
if c1%found then
select salary into old_sal from instructor where ID=temp_id;
new_sal:= old_sal*1.05;
update instructor set salary=new_sal where ID=temp_id;
dbms_output.put_line(new_sal);
select sysdate into cur_date from dual;
insert into salary_raise values(temp_id,cur_date,new_sal-old_sal);
else EXIT;
end if;
end loop;
close c1;

END;   
/
   
2. Write a PL/SQL block that will display the ID, name, dept_name and tot_cred of 
the first 10 students with lowest total credit.

set serveroutput on
declare
cursor c is select * from student order by tot_cred;
begin
	for i in c loop
		if c%ROWCOUNT>10 then exit;
		end if;
		dbms_output.put_line('ID : '||i.ID||'  Name : '||i.name||'  Department Name : '||i.dept_name||'  Total Credits : '||i.tot_cred);
	end loop;
end;
/

3. Print the Course details and the total number of students registered for each course along with the course details - (Course-id, title, dept-name, credits, 
instructor_name, building, room-number, time-slot-id, tot_student_no )

set serveroutput on;
declare
cursor c is (select course_id,title,dept_name,credits,name,building,room_number,time_slot_id,count from(select course_id,title,dept_name,credits,name,sec_id,semester,year,count from (select ID,name,course_id,sec_id,semester,year,count from (select course_id,sec_id,semester,year,tt.ID,count(distinct t.ID) count from takes t join teaches tt using(course_id,sec_id,semester,year) group by course_id,sec_id,semester,year,tt.ID) join instructor using(ID)) join course using(course_id)) join section using(course_id,sec_id,semester,year));
begin
	for i in c loop
		dbms_output.put_line('-----------------------------------------------------------------------------');
		dbms_output.put_line(i.course_id||'|'||i.title||'|'||i.dept_name||'|'||i.credits||'|'||i.name||'|'||i.building||'|'||i.room_number||'|'||i.time_slot_id||'|'||i.count);
		dbms_output.put_line('-----------------------------------------------------------------------------');
	end loop;
end;
/

4. Find all students who take the course with Course-id: CS101 and if he/ she has 
less than 30 total credit (tot-cred), deregister the student from that course. (Delete the entry in Takes table)

set serveroutput on;
declare
cursor c is (select * from student natural join takes where course_id='CS101' and tot_cred<30);
begin
	for i in c loop
		delete from takes where id=i.id and course_id=i.course_id;
		dbms_output.put_line(c%ROWCOUNT||' rows affected');
	end loop;
end;
/

5. Alter StudentTable(refer Lab No. 8 Exercise) by resetting column LetterGrade to F. Then write a PL/SQL block to update the table by mapping GPA to the 
corresponding letter grade for each student.

set serveroutput on;
declare
cursor c is (select * from studenttable) for update;
grade studenttable.lettergrade%TYPE;
begin
	for i in c loop
		update studenttable
		set lettergrade='F'
		where current of c;
	end loop;
	for i in c loop
		if i.gpa between 0 and 4 then grade :='F';
		elsif i.gpa between 4 and 5 then grade :='E';
		elsif i.gpa between 5 and 6 then grade :='D';
		elsif i.gpa between 6 and 7 then grade :='C';
		elsif i.gpa between 7 and 8 then grade :='B';
		elsif i.gpa between 8 and 9 then grade :='A';
		else grade :='A+';
		end if;
		update studenttable
		set lettergrade=grade
		where current of c;
	end loop;
end;
/

6. Write a PL/SQL block to print the list of Instructors teaching a specified course. 

set serveroutput on;
declare
cid teaches.course_id%TYPE;
cursor c(dname instructor.dept_name%TYPE) is (select * from teaches natural join instructor where course_id=cid);
begin
	cid :='&Course_Id';
	for i in c('Comp. Sci.') loop
		dbms_output.put_line(i.ID||'   '||i.name);
	end loop;
end;
/

7. Write a PL/SQL block to list the students who have registered for a course taught by his/her advisor.

set serveroutput on;
declare
cursor c is (select distinct name from (select t.id from takes t,advisor a,teaches tt where a.s_id=t.id and a.i_id=tt.id) join student using (id));
begin
	for i in c loop
		dbms_output.put_line(i.name);
	end loop;
end;
/




