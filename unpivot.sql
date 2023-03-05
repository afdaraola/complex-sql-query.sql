

select  * from t
unpivot ( mark for column_name in (c1,c2,c3,c4,c5,c6) )
