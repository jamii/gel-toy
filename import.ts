import { createClient } from "gel";
import { TextLineStream } from "jsr:@std/streams@0.223.0/text-line-stream";
import { insertPersons } from "./queries/insertPersons.query.ts";
import { insertTitles } from "./queries/insertTitles.query.ts";
import { insertPrincipals } from "./queries/insertPrincipals.query.ts";

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

async function insertFromTsv(
  filename: string,
  insert: (tx: any, args: { tsv: string }) => Promise<any>,
): Promise<void> {
  client.transaction(async (tx) => {
    for await (const chunk of readTsv(filename)) {
      console.log("chunk");
      await insert(tx, {
        tsv: chunk,
      });
    }
  });
}

insertFromTsv("./data/name.basics.tsv", insertPersons);
insertFromTsv("./data/title.basics.tsv", insertTitles);
insertFromTsv("./data/title.principals.tsv", insertPrincipals);

await client.close();
