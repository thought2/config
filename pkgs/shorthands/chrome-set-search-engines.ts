import * as fs from 'fs';
import * as path from 'path';
import * as yargs from 'yargs';
import * as child_process from 'child_process';

// TYPES

type Data = Array<{ short_name: string; keyword: string; url: string }>;

type Args = yargs.Arguments<{
  dbFile: string;
  dataFile: string;
  sqliteCmd: string;
}>;

// PARSE ARGS

const home = process.env['HOME'];

if (home) {
  yargs.option('db-file', {
    default: path.join(home, '.config/chromium/Default/Web Data'),
  });
} else {
  yargs.option('db-file', { demand: true });
}

yargs.option('data-file', { demand: true });
yargs.option('sqliteCmd', { default: 'sqlite3' });

const args = yargs.argv as Args;

// READ DATA

const data = JSON.parse(fs.readFileSync(args.dataFile).toString()) as Data;

// SQL

const buildDelete = `delete from keywords`;

const buildInsert = ({
  short_name,
  keyword,
  url,
}: {
  short_name: string;
  keyword: string;
  url: string;
}) => `
insert into keywords (
  short_name,
  keyword,
  favicon_url,
  url
)
  values ("${short_name}", "${keyword}", "", "${url}")
`;

const runSql = (sql: string) =>
  child_process.execSync(`${args.sqliteCmd} "${args.dbFile}"`, { input: sql });

// MAIN

const main = () => {
  runSql(buildDelete);

  data.forEach(({ short_name, keyword, url }) => {
    runSql(buildInsert({ short_name, keyword, url }));
  });
};

main();
