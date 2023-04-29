CREATE OR REPLACE TRIGGER test_trgr AFTER
    UPDATE OF weight ON bricks
    for each ROW
BEGIN
    dbms_output.put_line('Old value of weight column: ' || :old.weight);
    dbms_output.put_line('Proposed new value of weight column: ' || :new.weight);
    insert into log_table values ('old.weight -> '||:old.weight ||' -:new.weight-> '||:new.weight , sysdate);
    
END;


create table log_table (val varchar2(3000), tdate date);

update bricks SET weight  =1  where brick_id in (1,2,4,5);

select * from log_table;
select * from bricks;
truncate table log_table;
--rollback;
--drop trigger test_compound_trig;


update bricks SET weight  = 10  where brick_id = 2;

--compound trigger 
CREATE OR REPLACE TRIGGER test_compound_trig FOR
    UPDATE ON bricks
COMPOUND TRIGGER
    TYPE log_table_typ IS
        TABLE OF log_table%rowtype;
    l_log_table_typ log_table_typ := log_table_typ();
    
    AFTER EACH ROW IS
        l_log_row log_table%rowtype;
    BEGIN
        l_log_row.tdate := sysdate;
        l_log_row.val := 'old.weight -> '
                         || :old.weight
                         || ' -:new.weight-> '
                         || :new.weight;

        l_log_table_typ.extend;
        l_log_table_typ(l_log_table_typ.last) := l_log_row;
    END AFTER EACH ROW;
    
    AFTER STATEMENT IS BEGIN
        FORALL i IN 1..l_log_table_typ.count
            INSERT INTO log_table VALUES l_log_table_typ ( i );

    END AFTER STATEMENT;
    
END test_compound_trig;


--resolvig mutating trigger error

CREATE OR REPLACE TRIGGER comp_mut_resolve_trig FOR
    UPDATE ON bricks
COMPOUND TRIGGER
    lv_weight number;
    BEFORE STATEMENT IS 
    BEGIN
        SELECT  weight
        INTO lv_weight
        FROM bricks
        WHERE lower(colour) = 'green';

    END BEFORE STATEMENT;
    
    BEFORE EACH ROW IS
    BEGIN
        IF (:new.weight < lv_weight and lower(:old.colour) <> 'green') or (lower(:old.colour) = 'green') THEN
            INSERT INTO log_table VALUES (
                'Updated Successfully - old.weight -> '
                || :old.weight
                || ' -:new.weight-> '
                || :new.weight,
                sysdate
            );

        ELSE
            :new.weight := :old.weight;
            
            INSERT INTO log_table VALUES (
                'Updated Not successfuul - old.weight -> '
                || :old.weight
                || ' - cannot greater than -> '
                || lv_weight,
                sysdate
            );

        END IF;
    END BEFORE EACH ROW;
END comp_mut_resolve_trig;


SELECT  weight FROM bricks WHERE lower(colour) = 'green';
 

select * from SYS.user_triggers;


