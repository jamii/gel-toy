insert Person {
    nconst := <str>$nconst,
    primaryName := <str>$primaryName,
    birthYear := <int16>$birthYear,
    deathYear := <int16>$deathYear,
    primaryProfession := array_unpack(<array<str>>$primaryProfession),
    knownForTitles := array_unpack(<array<str>>$knownForTitles),
}