select 
  primaryTitle as title, 
  genres,
  (
    select jsonb_agg(actor) from (
      select
        (select primaryName from person where person.nconst = principal.nconst) as name, 
        characters
      from principal
      where principal.tconst = title.tconst 
      and characters is not null
      order by ordering 
      limit 10
    ) as actor
  ) as actors,
  (
    select jsonb_agg(primaryName)
    from principal, person
    where principal.tconst = title.tconst
    and person.nconst = principal.nconst
    and category = 'director'
  ) as director,
  (
    select jsonb_agg(primaryName)
    from principal, person
    where principal.tconst = title.tconst
    and person.nconst = principal.nconst
    and category = 'writer'
  ) as writer
from title
where tconst = 'tt3890160'