--Grade based on employee salary

--Grade based on employee salary(Subscriber Comments Reply Video 20 Grade based on employee salary)



CREATE TABLE emp_t (
    empno     number,
    ename     varchar2(100),
 sal       number
);

insert into emp_t values (1,'KING',100);
insert into emp_t values (2,'BLAKE',500);
insert into emp_t values (3,'CLARK',1200);
insert into emp_t values (4,'JONES',2500);
insert into emp_t values (5,'SCOTT',3000);
insert into emp_t values (6,'FORD',700);
insert into emp_t values (7,'SMITH',1700);
insert into emp_t values (8,'ALLEN',2600);
insert into emp_t values (9,'WARD',400);
insert into emp_t values (10,'MARTIN',1500);
commit;

----------------------------------------------------------------
select EMPNO, ENAME, SAL,
       case when sal >0 and sal <=1000 then 'A'
            when sal >1000 and sal <=2000 then 'B'
            else 'C' end grade
from emp_t;
----------------------------------------------------------------

select EMPNO, ENAME, SAL,
       decode(ceil(SAL/1000),1,'A',2,'B','C')
from emp_t;
----------------------------------------------------------------
select EMPNO, ENAME, SAL,r.g
from emp_t,(select 0 mi,1000 mx,'A' g from dual
union
select 1001 mi,2000 mx,'B' g from dual
union
select 2001 mi,999999 mx,'C' g from dual) R
where sal >=mi and sal <=mx
order by 1;
----------------------------------------------------------------
