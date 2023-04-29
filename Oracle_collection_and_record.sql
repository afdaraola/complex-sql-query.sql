/*Collection Types

 * PL/SQL has three collection types— 
  
            1. associative array (or index-by table) 
                   --Number of Elements
                       Unspecified
                    - Index Type 
                       1. String or 
                       2. PLS_INTEGER
                Where to Defined
                    - In PL/SQL block or package
                  
            2. VARRAY (variable-size array) 
                    --Number of Elements
                       specified
                    - Index Type 
                       1. Integer
                Where to Defined
                    - In PL/SQL block or package or at schema level
            3. nested table.
                     --Number of Elements
                       Unspecified
                    - Index Type 
                       1. Integer
                Where to Defined
                    - In PL/SQL block or package or at schema level

 ** Translating Non-PL/SQL Composite Types to PL/SQL Composite Types
 
      Non-PL/SQL Composite Type	  |       Equivalent PL/SQL Composite Type
      ----------------------------|----------------------------------------
     1. Hash table                |           Associative array
     2. Unordered table           |           Associative array
     3. Set                       |           Nested table
     4. Bag                       |           Nested table
     5. Array                     |           VARRAY
     
     
*** Associative Arrays
        An associative array (formerly called PL/SQL table or index-by table) is a set of key-value pairs. 
         Each key is a unique index, used to locate the associated value with the syntax variable_name(index).
         Indexes are stored in sort order, not creation order.
         
**** Appropriate Uses for Associative Arrays
    
    An associative array is appropriate for:
    
       1.  A relatively small lookup table, which can be constructed in memory each time you invoke the subprogram or initialize the package that declares it
        
       2.  Passing collections to and from the database server

    
    example 1 -- Associative array indexed by string:
    
*/ 


 set SERVEROUTPUT ON
 
DECLARE
    TYPE assoc_type IS TABLE OF NUMBER              -- Associative array type
     INDEX BY VARCHAR2(200);                        --  indexed by string
    l_assoctype assoc_type;                          -- Associative array variable
    i           VARCHAR2(200);                      -- Scalar variable
BEGIN
 -- Add elements (key-value pairs) to associative array:
    l_assoctype('Festus') := 39;
    l_assoctype('Enitan') := 38;
    l_assoctype('Alvin') := 5;
    l_assoctype('Momore') := 3;
    
     -- Add elements (key-value pairs) to associative array:
       l_assoctype('Festus') := 37;
     
     -- Print associative array:
     
    i := l_assoctype.first;                     -- Get first element of array
    
    WHILE i IS NOT NULL LOOP
        dbms_output.put_line(i
                             || ' is '
                             || l_assoctype(i)
                             || ' years old');
    i:=l_assoctype.next(i);                       -- Get next element of array
    END LOOP;

END;


--Function Returns Associative Array Indexed by PLS_INTEGER

DECLARE
    TYPE sum_multiple IS
        TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
    n  PLS_INTEGER := 5;  ---- number of multiples to sum for display
    sn PLS_INTEGER := 10; -- number of multiples to sum
    m  PLS_INTEGER := 3;  -- multiple

    FUNCTION get_smm_multiples (
        multiple PLS_INTEGER,
        num      PLS_INTEGER
    ) RETURN sum_multiple IS
        s sum_multiple;
    BEGIN
    dbms_output.put_line('multiple -> '||multiple || ' num -> '||num);
        FOR i IN 1..num LOOP
            s(i) := multiple * ( ( i * ( i + 1 ) ) / 2 );  ---- sum of multiples

            dbms_output.put_line(s(i));
        END LOOP;

        RETURN s;
    END get_smm_multiples;

BEGIN
    dbms_output.put_line('Sum of the first '
                         || to_char(n)
                         || ' multiples of '
                         || to_char(m)
                         || ' is '
                         || to_char(get_smm_multiples(m, sn)(n)));
                         
END;


/*

 * Varrays (Variable-Size Arrays)
        A varray (variable-size array) is an array whose number of elements can vary from zero (empty) to the declared maximum size.
        To access an element of a varray variable, use the syntax variable_name(index)

*/ 

--Example 5-4 Varray (Variable-Size Array)
DECLARE
    TYPE foursome IS
        VARRAY(10) OF VARCHAR2(1000);
    team foursome := foursome('Chelsea', 'Arsenal', 'Man Utd', 'Liverpool');

    PROCEDURE print_team (
        heading VARCHAR2
    ) AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(heading);
        FOR i IN 1..4 LOOP
            DBMS_OUTPUT.PUT_LINE(i
                                   || ' '
                                   || team(i));
        END LOOP;

       DBMS_OUTPUT.PUT_LINE('--------');
    END;

BEGIN
    print_team('Team 2005: ');
    team(3) := 'Man City';
    team(4) := 'Totenham';
    print_team('Team 2007: ');
    team := foursome('Aston Villa', 'noteham Forest', 'Lead', 'Everton');
     print_team('Team 2022: ');
END;


/*
 Nested Tables
In the database, a nested table is a column type that stores an unspecified number of rows in no particular order.
The syntax is variable_name(index)

The amount of memory that a nested table variable occupies can increase or decrease dynamically, as you add or delete elements.

*/


--Example 5-6 Nested Table of Standalone Type

CREATE OR REPLACE TYPE nt_type IS
    TABLE OF NUMBER;

CREATE OR REPLACE PROCEDURE print_nt (
    nametyp nt_type
) IS
i number;
BEGIN
    i := nametyp.first;
    IF ( i IS NULL ) THEN
        dbms_output.put_line('the collection is empty');
    ELSE
        WHILE i IS NOT NULL LOOP
            dbms_output.put('nt.('
                            || i
                            || ') = ');
            dbms_output.put_line(nvl(to_char(nametyp(i)), 'Null'));
            i := nametyp.next(i);
        END LOOP;
    END IF;

END print_nt;


DECLARE
    nt nt_type := nt_type();
BEGIN
    print_nt(nt);
    
    nt:= nt_type(11, 22, 33, 44, 55, 66);
    
    print_nt(nt);
END;
  

/*

*  5.4.1 Important Differences Between Nested Tables and Arrays

    Conceptually, a nested table is like a one-dimensional array with an arbitrary number of elements. 
    
            However, a nested table differs from an array in these important ways:
    
               1. An array has a declared number of elements, but a nested table does not. The size of a nested table can increase dynamically.
                
               2. An array is always dense. A nested array is dense initially, but it can become sparse, because you can delete elements from it.

** Appropriate Uses for Nested Tables
    A nested table is appropriate when:
    
    1. The number of elements is not set.
    
    2. Index values are not consecutive.
    
    3. You must delete or update some elements, but not all elements simultaneously.
    
    Nested table data is stored in a separate store table, a system-generated database table. When you access a nested table,
    the database joins the nested table with its store table. This makes nested tables suitable for queries and updates that affect 
    only some elements of the collection.
    
   4. You would create a separate lookup table, with multiple entries for each row of the main table, and access it through join queries.
   
   
   
*** Record Variables
    You can create a record variable in any of these ways:
    
       1. Define a RECORD type and then declare a variable of that type.
        
       2. Use %ROWTYPE to declare a record variable that represents either a full or partial row of a database table or view.
        
       3. Use %TYPE to declare a record variable of the same type as a previously declared record variable.
       
*/


--reccord type
DECLARE
    TYPE rectype IS RECORD (
        firstname VARCHAR2(200),
        lastname  VARCHAR2(200)
    );
    friendnames rectype;
BEGIN
    friendnames.firstname := 'Ayo';
    friendnames.lastname := 'Oguns';
    
       
    dbms_output.put_line('first->'
                         || friendnames.firstname
                         || ' last ->'
                         || friendnames.lastname);
    
    friendnames.firstname := 'akin';
    friendnames.lastname := 'ojo';
    
   
    dbms_output.put_line('first->'
                         || friendnames.firstname
                         || ' last ->'
                         || friendnames.lastname);
 
END;





-- varray 
DECLARE
    TYPE v_array_type IS
        VARRAY(7) OF VARCHAR2(20);
    v_array v_array_type := v_array_type(null,null,null);
BEGIN
  --  v_array.extend(2);
    v_array(1) := 'Monday';
     v_array(2) := 'Tuesday';
      v_array(3) := 'Wednesday';
     
     --dbms_output.put_line('v_array(1) -> ' || v_array(1));
     --dbms_output.put_line('v_array(1) -> ' || v_array(2));
     
      dbms_output.put_line('v_array.limit -> ' || v_array.limit);  -- limit declare 
      dbms_output.put_line('v_array.count before -> ' || v_array.count);  -- number of initialize
      dbms_output.put_line('v_array.first -> ' || v_array.first); 
       dbms_output.put_line('v_array.last -> ' || v_array.last); 
       v_array.trim(2);
        dbms_output.put_line('v_array.count after trim -> ' || v_array.count); 
        v_array.delete; --not allow to delete specific element 
        
       dbms_output.put_line('v_array.count after dleete -> ' || v_array.count); 
        v_array.extend(3);
        dbms_output.put_line('v_array.count after extend -> ' || v_array.count); 
          dbms_output.put_line('v_array.count after prior 2 -> ' || v_array.prior(2)); 
          dbms_output.put_line('v_array.count after next 2 ->  ' || v_array.next(2)); 
END;



--Nested Table 

DECLARE
    TYPE v_nested_type IS TABLE OF VARCHAR2(20); 
    
    v_nested v_nested_type := v_nested_type(null,null,null);
BEGIN
  --  v_nested.extend(2);
    v_nested(1) := 'Monday';
     v_nested(2) := 'Tuesday';
      v_nested(3) := 'Wednesday';
     
     --dbms_output.put_line('v_nested(1) -> ' || v_nested(1));
     --dbms_output.put_line('v_nested(1) -> ' || v_nested(2));
     
      dbms_output.put_line('v_nested.limit -> ' || v_nested.limit);  -- not applicable in nested table (always null)
      dbms_output.put_line('v_nested.count before -> ' || v_nested.count);  -- number of initialize
      dbms_output.put_line('v_nested.first -> ' || v_nested.first); 
       dbms_output.put_line('v_nested.last -> ' || v_nested.last); 
       v_nested.trim(2);
        dbms_output.put_line('v_nested.count after trim -> ' || v_nested.count); 
      
        --   dbms_output.put_line('v_nested.count after delete index 2 -> ' || v_nested.count); 
      --  v_nested.delete; --everything

       dbms_output.put_line('v_nested.count after dleete -> ' || v_nested.count); 
        v_nested.extend(3);
        dbms_output.put_line('v_nested.count after extend -> ' || v_nested.count); 
          dbms_output.put_line('v_nested.count after prior 2 -> ' || v_nested.prior(2)); 
          dbms_output.put_line('v_nested.count after next 2 ->  ' || v_nested.next(2)); 
          
            v_nested.delete(2);
            
          if v_nested.exists(2) then 
           dbms_output.put_line('v_nested.exists->  ' || v_nested(2));
           else 
            dbms_output.put_line('-----element 2 is empty---');
        end if;
END;




--associative array 
DECLARE
    TYPE v_ass_type IS
        TABLE OF VARCHAR2(20) INDEX BY VARCHAR2(20);
    v_assoc v_ass_type;

    PROCEDURE pr_print_weeks (
        ass v_ass_type
    ) AS
    BEGIN
        FOR i IN ass.first..ass.last LOOP
            dbms_output.put_line(i);
        END LOOP;
    END pr_print_weeks;

BEGIN
  --  v_nested.extend(2);
    v_assoc('Monday') := '11';
    v_assoc('Tuesday') := '22';
    v_assoc('Wednesday') := '33';
    v_assoc('Wednesday') := '33';
    v_assoc('Thursday') := '44';
    v_assoc('Friday') := '55';
    v_assoc('Saturday') := '66';
    v_assoc('Sunday') := '77';
    
  --  dbms_output.put_line('v_assoc('-----print all the collection----');
   -- pr_print_weeks(v_assoc);
    dbms_output.put_line('v_assoc(Monday) -> ' || v_assoc('Monday'));
    dbms_output.put_line('v_assoc(Thursday) -> ' || v_assoc('Thursday'));
     
    --  dbms_output.put_line('v_assoc.limit -> ' || v_assoc.limit);  -- assoiative array doesnt have limit
    dbms_output.put_line('v_assoc.count before -> ' || v_assoc.count);
    dbms_output.put_line('v_assoc.first -> ' || v_assoc.first);
    dbms_output.put_line('v_assoc.last -> ' || v_assoc.last); 
        --    v_assoc.trim(2); -- no trim in associative array
        -- v_nested.extend(3); -- no extend in associative array

    dbms_output.put_line('v_assoc.count after prior Wednesday -> ' || v_assoc.PRIOR('Wednesday'));
    dbms_output.put_line('v_assoc.count after next Monday ->  ' || v_assoc.next('Monday'));
    v_assoc.DELETE(2);
    IF v_assoc.EXISTS('Sat') THEN
        dbms_output.put_line('Sunday does not exists->  ' || v_assoc('Sunday'));
    ELSE
        dbms_output.put_line('-----element Sunday is empty---');
    END IF;

    v_assoc.DELETE;
    dbms_output.put_line('v_assoc.count before -> ' || v_assoc.count);
END;
