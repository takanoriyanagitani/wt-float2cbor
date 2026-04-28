import { readFile } from "node:fs/promises";

(async () => {
  /** @type {string} */
  const wasm = "./float2cbor.wasm";

  const pbytes = readFile(wasm);
  const pwasm = pbytes.then(WebAssembly.instantiate);

  const { module, instance } = await pwasm;
  const { exports } = instance;
  const { cbor2single } = exports;

  /** @type {string[]} */
  const args = process.argv.slice(2);

  /** @type {string} */
  const sarg = args[0] ?? "0";

  const ibuf = Buffer.from(sarg, "hex");

  const ibig = ibuf.readBigInt64BE();

  const converted = cbor2single(ibig);
  console.info(converted);

})();
