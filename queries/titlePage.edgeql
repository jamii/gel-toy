select (
    select Title{*}
    filter .tconst = <str>$tconst
) {
    title := .primaryTitle,
    genres,
    actors := (
        select .<title[is Principal]
        filter exists .characters
        order by .ordering
        limit 10
    )
    {
        name := .person.primaryName,
        characters := .characters,
    },
    director := (
        select .<title[is Principal]
        filter .category = "director"
    ).person.primaryName,
    writer := (
        select .<title[is Principal]
        filter .category = "writer"
    ).person.primaryName,
};