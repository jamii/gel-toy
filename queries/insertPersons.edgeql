for person in json_array_unpack(<json>$persons) union (
    insert Person {
        nconst := <str>person[0],
        primaryName := <str>person[1],
        birthYear := <int16>person[2],
        deathYear := <int16>person[3],
        primaryProfession := array_unpack(<array<str>>person[4]),
        knownForTitles := array_unpack(<array<str>>person[5]),
    }
);