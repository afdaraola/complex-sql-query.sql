--get diagonal data from input table 
--make in sigle line

select  max(decode(mod(rownum,3),1, id)) as id, 
       max(decode(mod(rownum,3), 2, email )) as email  
       from person
