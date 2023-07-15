create or replace package mypackage is
type mytype is record(
a number
);
function myfunction return mytype;
end mypackage;
/

create or replace package body mypackage is
function myfunction return mytype
is
l_record mytype;
begin
l_record.a := 69;
return l_record;
end myfunction;
end mypackage;
/


begin
dbms_output.put_line(mypackage.myfunction().a);
end;
/
