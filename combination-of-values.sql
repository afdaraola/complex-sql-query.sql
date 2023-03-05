



--write a query to get combiationn of values in table t1 and t2 

create table t1 (c1 varchar2(20) );
create table t2 (c1 varchar2(20) ); 

insert  into t1 values ('A');
insert  into t1 values ('B');
insert  into t1 values ('C');

insert  into t2 values ('D');
insert  into t2 values ('E');
insert  into t2 values ('F');

with k as (
    select *
    from t1
    union all
    select *
    from t2
)
select s1.c1||'-'||s.c1 as output from k s , k s1
where s.c1 > s1.c1
order by output ;


with k as (
    select *
    from t1
    union all
    select *
    from t2
)
select  distinct least(x.c1,x1.c1) ||'-'|| GREATEST(x.c1,x1.c1) as output
from k x, k x1
where x.c1<>x1.c1
order by  output
