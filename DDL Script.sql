CREATE SCHEMA mybank;
SET search_path TO mybank;

CREATE TABLE Pincodes(
PIN char(6),
city varchar(50),
district varchar(50),
state varchar(50),
primary key(PIN)
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Customer(
UUID char(12),
fname varchar(50) not null,
lname varchar(50) not null,
location text not null,
PIN char(6) not null,
mobile_no char(10) not null,
email varchar(100) not null,
DOB date not null,
primary key(UUID),
foreign key(PIN) references Pincodes(PIN) on update cascade on delete cascade
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Document(
UUID char(12),
document bytea,
primary key(UUID, document),
foreign key(UUID) references Customer(UUID) on update cascade on delete cascade
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Login_info(
username varchar(50),
password varchar(50) not null,
mpin char(6) not null,
UUID char(12) not null,
primary key(username),
foreign key(UUID) references Customer(UUID) on update cascade on delete cascade
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Acc_type(
type_name varchar(50),
interest_rate decimal(4,2) not null,
primary key(type_name)
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Branch(
branch_code varchar(7),
branch_name varchar(50) not null,
location text not null,
PIN char(6) not null,
primary key(branch_code)
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Account(
account_no varchar(13),
acc_type varchar(50) not null,
available_balance bigint not null,
branch_code varchar(7) not null,
UUID char(12) not null,
primary key(account_no),
foreign key(branch_code) references Branch(branch_code) on update cascade on delete cascade,
foreign key(UUID) references Customer(UUID) on update cascade on delete cascade,
foreign key(acc_type) references Acc_type(type_name) on update cascade on delete cascade
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Department(
dep_no varchar(7), 
dep_name varchar(50) not null,
primary key(dep_no)
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Employee(
emp_ID varchar(9),
emp_password varchar(50) not null,
fname varchar(50) not null,
lname varchar(50) not null,
join_date date not null,
email varchar(100) not null,
mobile_no char(10) not null,
salary bigint not null,
dep_no varchar(7) not null,
branch_code varchar(7) not null,
primary key(emp_ID),
foreign key (dep_no) references Department(dep_no) on update cascade on delete cascade,
foreign key (branch_code) references Branch(branch_code) on update cascade on delete cascade 
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Operates_in(
dep_no varchar(7), 
branch_code varchar(7) not null,
mgr_ID varchar(9) not null,
primary key(dep_no, branch_code),
foreign key(mgr_ID) references Employee(emp_ID) on update cascade on delete cascade
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Transaction(
transaction_ID varchar(30),
amount bigint not null,
transaction_type varchar(50) not null,
date timestamp not null,
mode varchar(50) not null,
account_no varchar(13) not null,
receiver_acc_no varchar(13),
primary key(transaction_ID),
foreign key(account_no) references Account(account_no) on update cascade on delete cascade,
foreign key(receiver_acc_no) references Account(account_no) on update cascade on delete cascade
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Loan_info(
loan_ID varchar(6),
min_term int not null,
max_term int not null,
delay_penalty bigint not null,
loan_type varchar(50) not null,
interest_rate decimal(4,2) not null,
min_amt bigint not null,
max_amt bigint,
eligibility_criteria text,
primary key(loan_ID)
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Loan_application(
loan_app_no varchar(8),
chosen_term int not null,
loan_amt bigint not null,
status varchar(20) not null,
closed_date timestamp,
approved_date timestamp,
applied_date timestamp not null,
account_no varchar(13) not null,
loan_ID varchar(6) not null,
primary key(loan_app_no),
foreign key(loan_ID) references Loan_info(loan_ID) on update cascade on delete cascade,
foreign key(account_no) references Account(account_no) on update cascade on delete cascade
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Loan_repayment(
loan_app_no varchar(8),
loan_installment_no int,
settlement_date timestamp,
due_date date not null,
due_amt bigint not null,
primary key(loan_app_no, loan_installment_no),
foreign key(loan_app_no) references Loan_application(loan_app_no) on delete cascade on update cascade
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Service(
service_ID varchar(5),
service_name varchar(50) not null,
primary key(service_ID)
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Service_Request(
req_ID varchar(30),
req_date timestamp not null,
status varchar(20) not null,
additional_notes text,
account_no varchar(13) not null,
service_ID varchar(5) not null,
primary key(req_ID),
foreign key(account_no) references Account(account_no) on update cascade on delete cascade,
foreign key(service_ID) references Service(service_ID) on update cascade on delete cascade
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE FD_info(
FD_ID varchar(8),
interest_rate decimal(4,2) not null,
tenure_yrs int not null,
min_amt bigint not null,
description text,
primary key(FD_ID)
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Fixed_deposit(
FD_no varchar(13),
dep_amt bigint not null,
maturity_date timestamp not null,
maturity_amt bigint not null,
opened_date timestamp not null,
account_no varchar(13) not null,
FD_ID varchar(8) not null,
primary key(FD_no),
foreign key(account_no) references Account(account_no) on update cascade on delete cascade,
foreign key(FD_ID) references FD_info(FD_ID) on update cascade on delete cascade
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Insurance_info(
ins_ID varchar(6),
annual_pay_period int not null,
ins_type varchar(50) not null,
delay_penalty bigint not null,
ins_term int not null,
premium_amt bigint not null,
coverage_amt bigint not null,
eligibility_criteria text,
primary key(ins_ID)
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Insurance_application(
ins_app_no varchar(12),
chosen_premium_amt bigint not null,
status varchar(20) not null,
approved_date timestamp,
end_date timestamp,
account_no varchar(13) not null,
ins_ID varchar(6) not null,
primary key(ins_app_no),
foreign key(ins_ID) references Insurance_info(ins_ID) on update cascade on delete cascade,
foreign key(account_no) references Account(account_no) on update cascade on delete cascade
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Insurance_record(
ins_app_no varchar(12),
ins_installment_no int,
due_date date not null,
due_amt bigint not null,
settlement_date timestamp,
primary key(ins_app_no, ins_installment_no),
foreign key(ins_app_no) references Insurance_application(ins_app_no) on update cascade on delete cascade
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Investment_info(
inv_ID varchar(6),
inv_type varchar(50) not null,
delay_penalty bigint not null,
primary key(inv_ID)
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Investment_application(
inv_app_no varchar(12),
annual_duration int not null,
inv_amt bigint not null,
status varchar(20) not null,
approved_date timestamp,
profit bigint,
account_no varchar(13) not null,
inv_ID varchar(6) not null,
primary key(inv_app_no),
foreign key(account_no) references Account(account_no) on update cascade on delete cascade,
foreign key(inv_ID) references Investment_info(inv_ID) on update cascade on delete cascade
);
---------------------------------------------------------------------------------------------------------
CREATE TABLE Investment_payment(
inv_app_no varchar(12),
inv_installment_no int,
due_date date not null,
due_amt bigint not null,
settlement_date timestamp,
primary key(inv_app_no, inv_installment_no),
foreign key(inv_app_no) references Investment_application(inv_app_no) on update cascade on delete cascade
);
--------------------------------------------------------------------------------------------------------