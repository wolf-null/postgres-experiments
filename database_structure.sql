------------------------------------------------------ CLEANUP ---------------------------------------------------------
drop table if exists domains cascade ;
drop table if exists subdomain_structure cascade ;
drop table if exists nodes cascade ;
drop table if exists nodes_in_domain;
drop table if exists projects cascade ;
drop table if exists projects_in_domain cascade ;
drop table if exists domain_roles cascade ;
drop table if exists domains;
------------------------------------------------------ DOMAINS ---------------------------------------------------------
create table domain_roles
(
    id                  serial,
    domain_role         varchar(32),

    primary key (id)
);

create table domains
(
    id                  serial,
    name                varchar(128),
    domain_role         integer,

    primary key (id),
    foreign key (domain_role) references domain_roles(id)
);

/*Domains might have subdomains*/
create table subdomain_structure
(
    id                  serial,
    parent_domain       integer,
    child_domain        integer,

    primary key (id),
    foreign key (parent_domain) references domains(id),
    foreign key (child_domain) references domains(id)
);

------------------------------------------------------- NODES ----------------------------------------------------------

create table nodes
(
    id              serial,
    name            varchar(64),
    description     varchar(256),
    ip              inet,
    mac             macaddr,

    primary key (id)
);

create table nodes_in_domain
(
    id                  serial,
    node                integer,
    domain              integer,

    primary key (id),
    foreign key (node) references nodes(id),
    foreign key (domain) references domains(id)
);

----------------------------------------------------- PROJECTS ---------------------------------------------------------

create table projects
(
    id                  serial,
    name                varchar(64),
    description         varchar(128),
    income              decimal,

    primary key (id)
);

create table projects_in_domain
(
    id                  serial,
    project             integer,
    domain              integer,

    primary key (id),
    foreign key (project) references projects(id),
    foreign key (domain) references domains(id)
);

---------------------------------------------------- FUNCTIONS ---------------------------------------------------------

create or replace function node_by_name(varchar) returns integer as
$$
    select id from nodes where nodes.name = $1 fetch first row only
$$ language sql;

create or replace function proj_by_name(varchar) returns integer as
$$
    select id from projects where projects.name = $1 fetch first row only
$$ language sql;

create or replace function role_by_name(varchar) returns integer as
$$
    select id from domain_roles where domain_roles.domain_role = $1 fetch first row only
$$ language sql;

create or replace function domain_by_name(varchar) returns integer as
$$
    select id from domains where domains.name = $1 fetch first row only
$$ language sql;