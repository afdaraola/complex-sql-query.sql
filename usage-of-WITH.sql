--what's usage of WITH clause in oracle 

select SUBSTR('WELCOME',1,LEVEL) AS R,
       SUBSTR('WELCOME', LEVEL) AS R2,
       SUBSTR('WELCOME', -LEVEL) AS R3
from dual  CONNECT BY LEVEL<= LENGTH('WELCOME');



with cte as (
select 'WELCOME' as d
FROM DUAL)

select SUBSTR(d,1,LEVEL) AS R,
    SUBSTR(d, LEVEL) AS R2,
       SUBSTR(d, -LEVEL) AS R3
from cte  CONNECT BY LEVEL<= LENGTH('WELCOME'); 
