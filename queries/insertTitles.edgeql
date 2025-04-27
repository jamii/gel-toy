for line in array_unpack(std::str_split(<str>$tsv, "\n")) union (
    with 
        row := std::str_split(line, "\t")
    insert Title {
        tconst := row[0],
        titleType := row[1],
        primaryTitle := row[2],
        originalTitle := row[3],
        isAdult := row[4] = "1",
        startYear := std::to_int16(filter_tsv_null(row[6])),
        endYear := std::to_int16(filter_tsv_null(row[6])),
        runtimeMinutes := std::to_int32(filter_tsv_null(row[7])),
        genres := array_unpack(std::str_split(filter_tsv_null(row[8]), ",")),
    }
);