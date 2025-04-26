import { createClient } from "gel";
import { TextLineStream } from "jsr:@std/streams@0.223.0/text-line-stream";
import { insertPerson } from "./queries/insertPerson.query.ts";

async function* readTsv(
  filename: string,
): AsyncGenerator<string[], void, void> {
  const lines = (await Deno.open(filename)).readable
    .pipeThrough(new TextDecoderStream())
    .pipeThrough(new TextLineStream());
  var isFirstLine = true;
  for await (const line of lines) {
    if (isFirstLine) {
      isFirstLine = false;
      continue;
    }
    yield line.split("\t");
  }
}

const client = createClient();
for await (const row of readTsv("./data/name.basics.tsv")) {
  const [
    nconst,
    primaryName,
    birthYear,
    deathYear,
    primaryProfession,
    knownForTitles,
  ] = row;
  await insertPerson(client, {
    nconst,
    primaryName,
    birthYear: parseInt(birthYear, 10),
    deathYear: parseInt(deathYear, 10),
    primaryProfession: primaryProfession.split(","),
    knownForTitles: knownForTitles.split(","),
  });
}

console.log(await client.querySingle("SELECT 1 + <int64>$num", { num: 2 }));

await client.close();
