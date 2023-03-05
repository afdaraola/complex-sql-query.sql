--Find the last two recharge amount for each customer



CREATE TABLE recharge_detail (
                                 recharge_date     DATE,
                                 cust_name         VARCHAR2(100),
                                 recharge_amount   NUMBER
);

insert into recharge_detail values( to_date('01/01/2019','DD/MM/YYYY'), 'Ragu',100);
insert into recharge_detail values( to_date('01/02/2019','DD/MM/YYYY'), 'Ragu',150);
insert into recharge_detail values( to_date('01/03/2019','DD/MM/YYYY'), 'Ragu',120);
insert into recharge_detail values( to_date('01/04/2019','DD/MM/YYYY'), 'Ragu',170);

insert into recharge_detail values( to_date('01/01/2019','DD/MM/YYYY'), 'Ravi',299);
insert into recharge_detail values( to_date('01/02/2019','DD/MM/YYYY'), 'Ravi',399);
insert into recharge_detail values( to_date('01/03/2019','DD/MM/YYYY'), 'Ravi',150);
insert into recharge_detail values( to_date('01/04/2019','DD/MM/YYYY'), 'Ravi',199);

insert into recharge_detail values( to_date('01/01/2019','DD/MM/YYYY'), 'Siva',100);
insert into recharge_detail values( to_date('01/02/2019','DD/MM/YYYY'), 'Siva',200);
insert into recharge_detail values( to_date('01/03/2019','DD/MM/YYYY'), 'Siva',400);
insert into recharge_detail values( to_date('01/04/2019','DD/MM/YYYY'), 'Siva',200);

commit;

select cust_name, max(laast_recharge) as recharge_amount, max(last_2ndrecharge) from (
                             select cust_name,
                                    recharge_date,
                                    decode(
                                            rank() over ( partition by cust_name order by recharge_date desc ),
                                            1,
                                            recharge_amount) as laast_recharge,
                                    decode(
                                            rank() over ( partition by cust_name order by recharge_date desc ),
                                            2,
                                            recharge_amount) as last_2ndrecharge
                             from recharge_detail
                         ) group by cust_name
