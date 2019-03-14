import * as fs from 'fs';
import * as yargs from 'yargs';

// TYPES

type Args = yargs.Arguments<{
  input: string;
  output: string;
  exposedModules: Array<string>;
}>;

type ElmJsonAppFragment = {
  dependencies: { direct: { [key: string]: string } };
};

type ElmJsonPkg = {
  type: 'package';
  name: string;
  summary: string;
  license: string;
  version: '1.0.0';
  'exposed-modules': Array<string>;
  'elm-version': string;
  dependencies: {
    [key: string]: string;
  };
  'test-dependencies': {};
};

// PARSE ARGS

yargs
  .option('input', { default: 'elm.json' })
  .option('output', { demand: true })
  .option('exposedModules', { demand: true, type: 'array' });

const args = yargs.argv as Args;

// UTIL

const nextMajorVersion = (version: string): string => {
  const deli = '.';
  const [major, minor, patch] = version
    .split(deli)
    .map(part => parseInt(part, 10));
  return [major + 1, 0, 0].join(deli);
};

const toPkgJson = ({
  exposedModules,
  frag,
}: {
  exposedModules: Array<string>;
  frag: ElmJsonAppFragment;
}): ElmJsonPkg => {
  const dependencies = Object.keys(frag.dependencies.direct).reduce(
    (memo, key) => {
      const value = frag.dependencies.direct[key];
      memo[key] = [value, '<=', 'v', '<', nextMajorVersion(value)].join(' ');
      return memo;
    },
    {} as { [key: string]: string },
  );
  return {
    type: 'package',
    name: 'author/name',
    summary: 'summary',
    license: 'BSD-3-Clause',
    version: '1.0.0',
    'exposed-modules': exposedModules,
    'elm-version': '0.19.0 <= v < 0.20.0',
    dependencies,
    'test-dependencies': {},
  };
};

// MAIN

const main = () => {
  const input = JSON.parse(
    fs.readFileSync(args.input).toString(),
  ) as ElmJsonAppFragment;

  fs.writeFileSync(
    args.output,
    JSON.stringify(
      toPkgJson({ exposedModules: args.exposedModules, frag: input }),
      null,
      2,
    ),
  );
};

main();
