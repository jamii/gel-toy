select 
  primaryName as name,
  birthYear,
  (
    select jsonb_agg(film) from (
      select 
        primaryTitle as title,
        jsonb_agg(category) as roles
      from principal, title
      where principal.nconst = person.nconst
      and title.tconst = principal.tconst
      and isAdult = false
      group by title.tconst, primaryTitle, startYear
      order by startYear desc
      limit 10
    ) as film
  ) as films
from person
where nconst = 'nm0942367'