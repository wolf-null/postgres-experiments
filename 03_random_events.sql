-------------------------------------------------- GENERATE RANDOM EVENTS ----------------------------------------------

create or replace function bernulli_indicator(a int, b int, p float) returns integer as
$$
declare
    v float;
begin
    if random() > p then
        return a;
    else
        return b;
    end if;
end;
$$ language plpgsql;

delete from events;
alter sequence events_id_seq restart with 1;

create or replace procedure generate_random_events(number integer) language sql as
$$
    insert into events(event, node)
        (
            with nodes_count as (select count(*) as count from nodes),
                 nn as
                     (
                         select * from
                            generate_series(1, number) as x
                            cross join nodes_count as y
                     )
            select bernulli_indicator(1, 2, 0.8)   as event,
                   1 + floor(round(random() * (count - 1))) as node    --- Does not encapsulate into a function, IDK why
            from nn /*Oh, fuck...*/
    )
$$;

call generate_random_events(100);

select node, count(*) from events group by node order by node asc


----------------------------------------------------- EVENT STATISTICS -------------------------------------------------

