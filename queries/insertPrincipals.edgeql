for line in array_unpack(std::str_split(<str>$tsv, "\n")) union (
    with 
        row := std::str_split(line, "\t"),
        title := (select Title{} filter .tconst = row[0]),
        person := (select Person{} filter .nconst = row[2])
        select if (count(title) = 1 and count(person) = 1) then
    (insert Principal {
        title := title,
        ordering := std::to_int16(row[1]),
        person := person,
        category := row[3],
        job := filter_tsv_null(row[4]),
        characters := <str>json_array_unpack(to_json(filter_tsv_null(row[5]))),
    }) else {}
);