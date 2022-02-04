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

--insert into Items(name) values ('awoo');

insert into Projects(name, description)
    values
    ('AwooL3', 'VRF between Durham, Chertsey and Seaham'),
    ('Ch',     'Pseudo-L2 Durham & Chertsey');

reindex schema public;

insert into DomainStructure(parent, child) values
    (8,1);
    --((select id from Items where id=8), ((select id from Items where id=1)));

