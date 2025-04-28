select (
    select Person{}
    filter .nconst = <str>$nconst
) {
    name := .primaryName,
    birthYear,
    films := (
        select (
            select (
                group (
                    select .<person[is Principal]
                    filter .title.isAdult = false
                ) by .title
            )
            order by .key.title.startYear desc
            limit 10
        )
        {
            title := .key.title.primaryTitle,
            roles := .elements.category,
        }
    ),
}
;