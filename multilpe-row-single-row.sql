--get value from multiple row to single row

create table t (c1 varchar2(20),c2 varchar2(20),c3 varchar2(20),c4 varchar2(20),c5 varchar2(20),
                c6 varchar2(20));

select * from t;
insert into t values ('A3','A2','A3','A4','A5','A6');
insert into t values ('B3','B2','B3','B4','B5','B6');
insert into t values ('C3','C2','C3','C4','C5','C6');
insert into t values ('D3','D2','D3','D4','D5','D6');
insert into t values ('E3','E2','E3','E4','E5','E6');
insert into t values ('F3','F2','F3','F4','F5','F6');


select
       max(decode(mod(ROWNUM,3),1,c1)) as c1, max(decode(mod(ROWNUM,3),1,c2)) as c2,
       max(decode(mod(ROWNUM,3),2,c3)) as c3,  max(decode(mod(ROWNUM,3),2,c4)) as c4,
           max(decode(mod(ROWNUM,3),0,c5)) as c5, max(decode(mod(ROWNUM,3),0,c6)) as c6
       from t  a group by ceil(ROWNUM/3)
