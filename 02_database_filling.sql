delete from nodes_in_domain;
delete from nodes;
delete from projects_in_domain;
delete from projects;
delete from subdomain_structure;
delete from domains;

alter sequence nodes_id_seq restart with 1;
alter sequence projects_id_seq restart with 1;

/*
    TODO:
        [X] Domains
            [X] Add nodes
            [X] Add domain nodes
            [X] Add domains and attach the roles
            [X] 'Hierarchize' domains
        [X] Projects
            [X] Create projects and attach it to proper domains
            [X] Attach nodes to domains
        [X] Events
            [X] Event types
            [X] Events
                [X] Randomly generated
            [X] Number of events of the selected kind
            [ ] Report on event numbers
        [ ] Events +
            [ ] Timestamps (considering generation via a python script)

*/

insert into nodes(name, ip)
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

insert into domain_roles(domain_role)
    values
    ('datacenters'),
    ('networks'),
    ('network-groups');

insert into domains(name, domain_role)
    values
    ('ElephantAndCastle', role_by_name('datacenters')),
    ('Durham', role_by_name('datacenters')),
    ('Chertsey', role_by_name('datacenters')),
    ('Seaham', role_by_name('datacenters')),
    ('Channel-A', role_by_name('networks')),
    ('Channel-B', role_by_name('networks')),
    ('Channel-C', role_by_name('networks')),
    ('Channel-D', role_by_name('networks')),
    ('Services-for-Alice', role_by_name('network-groups')),
    ('Services-for-Bob',   role_by_name('network-groups'));

insert into subdomain_structure(parent_domain, child_domain)
    values
    (domain_by_name('Services-for-Alice'), domain_by_name('Channel-A')),
    (domain_by_name('Services-for-Alice'), domain_by_name('Channel-B')),
    (domain_by_name('Services-for-Alice'), domain_by_name('Channel-C')),
    (domain_by_name('Services-for-Bob'), domain_by_name('Channel-D'));


insert into projects(name, description)
    values
    ('AwooL3',    'VRF between Durham, Chertsey and Seaham'),
    ('TheCh',     'Pseudo-L2 Durham & Chertsey');

insert into projects_in_domain(project, domain)
    values
    (proj_by_name('AwooL3'), domain_by_name('Services-for-Alice')),
    (proj_by_name('TheCh'), domain_by_name('Services-for-Bob'));

insert into nodes_in_domain(node, domain)
(
    with new_nodes_in_domain(_node, _domain) as
    (
        values
            ('ElephantAndCastle-CCR1036', 'Channel-A'),
            ('ElephantAndCastle-CCR1036', 'Channel-B'),
            ('ElephantAndCastle-CCR1036', 'Channel-C'),
            ('Durham-RB3011', 'Channel-A'),
            ('Durham-RB3011', 'Channel-D'),
            ('Chertsey-RB2011', 'Channel-B'),
            ('Chertsey-RB2011', 'Channel-D'),
            ('Chertsey-RBLHGR', 'Channel-D'),
            ('Seaham', 'Channel-C')
    )
    select node_by_name(_node), domain_by_name(_domain) from new_nodes_in_domain
);

---------------------------------------------------------- EVENTS ------------------------------------------------------

insert into event_types(event_name, level) values
    ('err_fatal',   3),
    ('err',         2);
