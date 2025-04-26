for person in json_array_unpack(<json>$persons) union (
    with 
    birthYear := <str>person[2],
    deathYear := <str>person[3],
    insert Person {
        nconst := <str>person[0],
        primaryName := <str>person[1],
        birthYear := std::to_int16(filter_tsv_null(<str>person[2])),
        deathYear := std::to_int16(filter_tsv_null(<str>person[3])),
        primaryProfession := array_unpack(std::str_split(filter_tsv_null(<str>person[4]), ",")),
        knownForTitles := array_unpack(std::str_split(filter_tsv_null(<str>person[5]), ",")),
    }
);