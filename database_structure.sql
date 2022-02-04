------------------------------------------------------ CLEANUP ---------------------------------------------------------
drop table if exists Domains;
drop table if exists DomainStructure;
drop table if exists Nodes;
drop table if exists Projects;
drop table if exists Items;

------------------------------------------------------ DATABASE --------------------------------------------------------
create table Items
(
    "id"          serial          primary key  unique,
    "name"        varchar(64)
);

create table DomainStructure
(
    "id"          serial,
    "parent"      integer not null,
    "child"       integer not null,

    primary key ("id"),
    foreign key ("parent") references Items("id"),
    foreign key ("child") references Items("id")
);

create table Projects
(
----"id"          serial          [::Items]
----"name"        varchar(64)     [::Items]
    "description" varchar(256)
)
inherits(Items);

create table Nodes
(
----"id"          serial          [::Items]
----"name"        varchar(64)     [::Items]
    "ip"          inet,
    "mac"         macaddr,
    "location"    varchar(256)
) inherits(Items);

create or replace function GetNodeID(inet) returns integer as
$$
    select id from Nodes where Nodes.ip = $1 fetch first row only;
$$ language SQL;

create or replace function GetProjectID(varchar) returns integer as
$$
    select id from Projects where Projects.name = $1 fetch first row only;
$$ language SQL;

