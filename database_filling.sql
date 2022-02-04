delete from nodes;
delete from projects_in_domain;
delete from projects;
delete from subdomain_structure;
delete from domains;

alter sequence nodes_id_seq restart with 1;
alter sequence projects_id_seq restart with 1;

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

/*insert into nodes_in_domain(node, domain)*/

    /*with channels_readable(ar, br, chr) as
    (
        values
        ('ElephantAndCastle-CCR1036',   'Durham-RB3011',    'Channel-A'),
        ('ElephantAndCastle-CCR1036',   'Chertsey-RB2011',  'Channel-B'),
        ('ElephantAndCastle-CCR1036',   'Seaham',           'Channel-C'),
        ('Durham-RB3011',               'Chertsey-RBLHGR',  'Channel-D'),
        ('Chertsey-RBLHGR',             'Chertsey-RB2011',  'Channel-D')
    ),
     */


    /*
     first_row as (select ar as nd from channels_readable),
    second_row as (select br as nd from channels_readable),
    both_rows as (select * from first_row union select * from second_row),
    nodes_used(node) as (select distinct nd from both_rows)
     */





/*
select domains.name from
    domains left join domain_roles
    on domains.domain_role = domain_roles.id where domain_roles.domain_role='networks';
*/
/*Now, assume, some particukla*/

