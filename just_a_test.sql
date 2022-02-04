drop table if exists A;
drop table if exists B;
drop table if exists MyTable;

create table MyTable
(
    id      serial      primary key,
    x       varchar(32)
);

create table A () inherits(MyTable);
create table B () inherits(MyTable);

insert into A(x) values ('a'), ('b'), ('c'), ('b');
insert into B(x) values ('b'), ('c'), ('c'), ('d');

select * from A left join B on A.x = B.x;


