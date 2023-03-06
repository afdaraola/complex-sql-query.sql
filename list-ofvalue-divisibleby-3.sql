--get the list of values divisible by 3 that are less than 100



--method 1

select listagg(r,',') within group ( order by r desc ) list from (
                                                                select rownum as r
                                                                from USER_TABLES
                                                                where rownum <= 100
                                                            ) where mod(r,3) = 0;
                                                            
                                                            
                                                            
--method 2

select listagg(r,'|') within group ( order by r desc ) as list from  (
select ROWNUM as r  from DUAL connect by level <=100
) where mod(r,3)=0;

--method 3
select listagg(r,',') within group ( order by r desc )
from (select ROWNUM*3 as r from DUAL  connect by level <= 100/3);
   
