for line in array_unpack(std::str_split(<str>$tsv, "\n")) union (
    with 
      row := std::str_split(line, "\t")
    insert Person {
        nconst := row[0],
        primaryName := row[1],
        birthYear := std::to_int16(filter_tsv_null(row[2])),
        deathYear := std::to_int16(filter_tsv_null(row[3])),
        primaryProfession := array_unpack(std::str_split(filter_tsv_null(row[4]), ",")),
        knownForTitles := array_unpack(std::str_split(filter_tsv_null(row[5]), ",")),
    }
);