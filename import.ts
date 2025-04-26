import { createClient } from "gel";
import { TextLineStream } from "jsr:@std/streams@0.223.0/text-line-stream";
import { insertPersons } from "./queries/insertPersons.query.ts";

async function readTsv(filename: string): Promise<string[][]> {
  const lines = (await Deno.open(filename)).readable
    .pipeThrough(new TextDecoderStream())
    .pipeThrough(new TextLineStream());
  const rows = [];
  let isFirstLine = true;
  for await (const line of lines) {
    if (isFirstLine) {
      isFirstLine = false;
      continue;
    }
    rows.push(line.split("\t"));
  }
  return rows;
}

const persons = await readTsv("./data/name.basics.tsv");
console.log(persons[0]);
const client = createClient();
const chunk_size = 1_000_000;
await client.transaction(async (tx) => {
  for (let i = 0; i < persons.length; i += chunk_size) {
    console.log(i);
    await insertPersons(tx, { persons: persons.slice(i, i + chunk_size) });
  }
});
await client.close();
