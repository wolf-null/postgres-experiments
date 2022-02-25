/*PostgreSQL*/

drop table if exists Companies, Cities, Countries;

create table Countries
(
    id              serial,
    name            varchar,
    population      integer,
    gdp             integer,
    primary key (id)
);

create table Cities
(
    id              serial,
    name            varchar,
    population      integer,
    founded         date,
    country         integer,
    primary key (id),
    foreign key (country) references Countries(id)
);

create table Companies
(
    id              serial,
    name            varchar,
    city_id         integer,
    revenue         integer,
    labors          integer,
    primary key (id),
    check ( labors >= 0 ),
    foreign key (city_id) references Cities(id)
);

insert into Countries(name) values
('UK'),
('USA');

insert into Cities(name, country) values
('Brimingham',  1),
('Durham',      1),
('Sacramento',  2),
('Knobtown',    2);

insert into Companies(name, city_id, labors) values
('Foxes',        1, 10),    -- uk
('Wolves',       1, 1000),  -- uk   + 1000
('Wolverines',   2, 1010),  -- uk   + 1010
('Parrots',      2, 2020),  -- uk   + 2020
('Dogs',         3, 1001),  -- usa  + 1001
('Owls',         3, 1700),  -- usa  + 1700
('Snakes',       4, 2000),  -- usa  + 2000
('Wizards',      4, 10000); -- usa  + 10000

--- uk  = 1000 + 1010 + 2020         = 4030
--- usa = 1001 + 2000 + 10000 + 1700 = 14701


with companies_in_countries as
(
     select city.country as a_country, company.id as a_company, company.labors as n_labors
     from Companies company
              left join Cities city on company.city_id = city.id
     where company.labors >= 1000
)
select
    country.name,
    count(companies_in_countries.n_labors) as number_of_companies
from companies_in_countries
    left join Countries as country on companies_in_countries.a_country = country.id
group by country.name;



