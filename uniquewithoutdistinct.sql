


create table studentList(idno number, name varchar2(20));

insert into  studentList values (1,'festus');
insert into  studentList values (1,'festus');
insert into  studentList values (2,'alvin');
insert into  studentList values (2,'alvin');
insert into  studentList values (3,'mum');
insert into  studentList values (4,'momore');

select distinct idno, name from studentList;

select unique idno, name from studentList;

select unique idno, name from studentList
group by  idno, name;

select  idno, name from studentList
union
select  idno, name from studentList;

--improve performance
select  idno, name from studentList
union
select  null, null from DUAL where 1=2;

select  idno, name from studentList
minus
select  null, null from DUAL;

select  idno, name from studentList
intersect
select  idno, name from studentList;   

select idno,name from (
 select  idno, name , row_number() over (partition by idno,name order by  idno,name desc ) rnk
 from studentList)
 where rnk = 1;

select  idno, name from studentList a
where 1 = (select count(1)
           from studentList b
           where a.idno = b.idno
             and a.name = b.name
             and a.ROWID >= b.ROWID
)
