TYPE type_name IS TABLE OF element_type [NOT NULL] INDEX BY subscript_type; 
 
table_name type_name;






DECLARE
    cust_name varchar2(20) NOT NULL := 'tom jones';
    --same_name cust_name%TYPe;
    Type  tests is table of VARCHAR2(20);
    v_test tests;
begin 
    v_test:= tests('A','B','C');
    FOR i IN 1..v_test.count LOOP
          dbms_output.put_line('output: ' || v_test(i));
        END LOOP;
   
END;


DECLARE

    cust_name VARCHAR2(20) NOT NULL := 'tom jones';
    --same_name cust_name%TYPe;
    TYPE tests IS TABLE OF VARCHAR2(20) INDEX BY PLS_INTEGER;
    v_test    tests;
    outpt NUMBER;
    
BEGIN
    v_test(1) := 'A';
    v_test(2) := 'B';
    v_test(3) := 'C';
    v_test(4) := 'D';
   
    outpt:= v_test.first;
    
    while outpt is not null loop
        dbms_output.put_line('output: ' || outpt);
        outpt:= v_test.next(outpt);
        
    END LOOP;

END;
