import { createClient } from "gel";
import { TextLineStream } from "jsr:@std/streams@0.223.0/text-line-stream";
import { insertPersons } from "./queries/insertPersons.query.ts";

async function* readTsv(filename: string): AsyncGenerator<string, void, void> {
  const lines = (await Deno.open(filename)).readable
    .pipeThrough(new TextDecoderStream())
    .pipeThrough(new TextLineStream());
  let rows = [];
  let isFirstLine = true;
  for await (const line of lines) {
    if (isFirstLine) {
      isFirstLine = false;
      continue;
    }
    rows.push(line);
    if (rows.length >= 1_000_000) {
      yield rows.join("\n");
      rows = [];
    }
  }
  yield rows.join("\n");
}

const client = createClient();
client.transaction(async (tx) => {
  for await (const chunk of readTsv("./data/name.basics.tsv")) {
    console.log("chunk");
    await insertPersons(tx, {
      tsv: chunk,
    });
  }
});
await client.close();
