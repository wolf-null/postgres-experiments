------------------------------------------------------ CLEANUP ---------------------------------------------------------
drop table if exists Items;
drop table if exists Domains;
drop table if exists DomainStructure;
drop table if exists Nodes;
------------------------------------------------------ DATABASE --------------------------------------------------------
create table Items
(
    id      serial      primary key
);

create table Domains
(
    name    varchar(64)
)   inherits (Items);

create table DomainStructure
(
    id          serial      primary key,
    parent      integer     references Domains(id)      not null,
    child       integer     references Items(id)        not null
);

create table Nodes
(

)   inherits(Items);

