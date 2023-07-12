use bank_replica;

create table bank_user(
id int primary key auto_increment,
first_name varchar(10),
last_name varchar(10),
mobile_no bigint,
account_no varchar(10) unique,
user_password varchar(10),
balance float default 0);

desc bank_user;

create table acct_stmt(
ref_id int primary key auto_increment,
user_id int,
type_of_transaction varchar(10),
credit_amt float,
debit_amt float,
current_balance float,
date_of_transaction datetime,
foreign key (user_id) references bank_user(id)
on delete cascade);


desc bank_user;


create procedure insert_user(in first_name varchar(10),in last_name varchar(10),in mobile_no bigint,in account_no varchar(10),in user_password varchar(10))
insert into bank_user(first_name,last_name,mobile_no,account_no,user_password)values(first_name,last_name,mobile_no,account_no,user_password);

delimiter $$
create procedure depositing(in userId int,in credit_amt float)
begin
DECLARE  bal float;
set bal=(select balance from bank_user where id=userId)+credit_amt ;
insert into acct_stmt(user_id,credit_amt,current_balance,date_of_transaction)values(userId,credit_amt,bal,now());
update bank_user set balance=bal where id=userId;
end $$
delimiter ;

delimiter $$
create procedure withdrawal(in userId int,in withdraw_amt float)
begin
DECLARE  bal float;
set bal=(select balance from bank_user where id=userId)-withdraw_amt;
update bank_user set balance=bal where id=userId;
insert into acct_stmt(user_id,debit_amt,current_balance,date_of_transaction)values(userId,withdraw_amt,bal,now());

end $$
delimiter ;

DELIMITER $$
CREATE TRIGGER before_withdrawal
before update ON bank_user
FOR EACH ROW
BEGIN
 if new.balance<0 then signal sqlstate '45000'
 set message_text= "can't withdraw the money bcoz balance amount is not enough ";
 end if;
END $$
DELIMITER ;
drop trigger before_withdrawal;
 call withdrawal(3,1000);

create procedure check_valid_user(in userId int,in userPassword varchar(10) ,out checkFlag int)
select count(id) into checkFlag from bank_user where id= userId and user_password=userPassword;

call insert_user('mathew','jose',9738302023,'fdfg','mathew#');
call check_valid_user(1,'emilin#',@checkFlag);
select @checkFlag;
call depositing(1,2000);
call withdrawal(1,2000);


select * from bank_user;
select * from acct_stmt;


drop table bank_user;

drop procedure insert_user;
drop procedure check_valid_user;
drop procedure depositing;
drop procedure withdrawal;
truncate table bank_user;
truncate table acct_stmt;
SET foreign_key_checks = 0;

select pow(2,3);

