import { createClient } from "gel";
import { personPage } from "./queries/personPage.query.ts";
import { titlePage } from "./queries/titlePage.query.ts";

const client = createClient();
console.log(await personPage(client, { nconst: "nm0942367" }));
console.log(await titlePage(client, { tconst: "tt3890160" }));
await client.close();
