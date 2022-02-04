delete from Items;
delete from Projects;
delete from DomainStructure;

alter sequence items_id_seq restart with 1;
alter sequence domainstructure_id_seq restart with 1;

insert into Nodes(name, ip)
(
    /*The trick is not to add the already existed elements (not by id)*/
    /*Conflict isn't used since Nodes.id might differ*/
    with New(name, ip) as
    (
        values
        ('ElephantAndCastle-CCR1036', inet('10.10.10.201')),
        ('ElephantAndCastle-DLink-3420', inet('10.10.10.202')),
        ('ElephantAndCastle-DLink-3120', inet('10.10.10.203')),
        ('Durham-RB3011', inet('10.10.11.101')),
        ('Chertsey-RB2011', inet('10.10.12.101')),
        ('Chertsey-RBLHGR', inet('10.10.12.101')),
        ('Seaham', inet('10.10.13.1'))
    )
    select New.name, New.ip from New left join Nodes on New.name = Nodes.name where Nodes.name is null
);

insert into Projects(name, description)
    values
    ('AwooL3', 'VRF between Durham, Chertsey and Seaham'),
    ('Ch',     'Pseudo-L2 Durham & Chertsey');



-------------------------------------------------- TEST FUNCTIONS ------------------------------------------------------
drop table if exists TestProject;
create table TestProject
(
    id      serial      primary key,
    parent  integer,
    child   integer
);
insert into TestProject(parent, child) values
    (GetProjectID('AwooL3'), GetNodeID(inet('10.10.10.201')));
select * from TestProject;



/*A dumb way to delete everything. One can use 'delete from Projects' but...
delete from Projects where exists
(
    select 1 from Projects
);
*/

