1) create table salary_raise( Instructor_ID varchar(5),
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
