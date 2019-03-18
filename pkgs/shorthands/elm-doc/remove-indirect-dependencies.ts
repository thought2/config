import * as fs from 'fs';
import * as yargs from 'yargs';

// TYPES

type Args = yargs.Arguments<{
  elmJson: string;
  searchJson: string;
  output: string;
}>;

type ElmJson = {
  dependencies: { indirect: { [packageName: string]: string } };
};

type SearchJson = Array<{ name: string }>;

// PARSE ARGS

yargs
  .option('elmJson', { default: 'elm.json' })
  .option('searchJson', { required: true })
  .option('output', { required: true });

const args = yargs.argv as Args;

// LIB

const filterSearchJson = (
  elmJson: ElmJson,
  searchJson: SearchJson,
): SearchJson => {
  return searchJson.filter(({ name }) => !elmJson.dependencies.indirect[name]);
};

// MAIN

const main = () => {
  const elmJson = JSON.parse(
    fs.readFileSync(args.elmJson).toString(),
  ) as ElmJson;
  const searchJson = JSON.parse(
    fs.readFileSync(args.searchJson).toString(),
  ) as SearchJson;

  const result = filterSearchJson(elmJson, searchJson);

  fs.writeFileSync(args.output, JSON.stringify(result));
};

main();
