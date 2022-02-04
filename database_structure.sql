------------------------------------------------------ CLEANUP ---------------------------------------------------------
drop table if exists domains;
drop table if exists subdomain_structure;
drop table if exists nodes;
drop table if exists nodes_in_domain;
drop table if exists projects;
drop table if exists projects_in_domain;

------------------------------------------------------ DOMAINS ---------------------------------------------------------
create table domains
(
    id                  serial,
    name                varchar(128),
    primary key (id)
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

