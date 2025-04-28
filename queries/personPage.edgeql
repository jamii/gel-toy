select (
    select Person{}
    filter .nconst = <str>$nconst
) {
    name := .primaryName,
    birthYear,
    films := (
        select (
            group (
                select .<person[is Principal]
                filter .title.isAdult = false
            ) by .title
        ) {
            title := .key.title.primaryTitle,
            roles := .elements.category,
        }
        limit 10
    ),
}
;