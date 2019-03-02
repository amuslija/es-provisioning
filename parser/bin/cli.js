#!/usr/bin/env node
const program = require('commander')

const { createIndices, parse, searchIndex } = require('../src')
const { indices } = require('../config')

program
  .command('initialize')
  .description('Initialize indices in the ElasticSearch cluster')
  .option('-u --url <url>', 'ElasticSearch cluster host url')
  .action(async opts => {
    try {
      createIndices(opts)
      process.stdout.write('Successfully initialized the DB')
    } catch (e) {
      process.stderr.write(e.message)
    }
  })

program
  .command('parse')
  .description(
    'Parse a CSV file and store the contents on an ElasticSearch cluster'
  )
  .option('-f --file <file>', 'Path to the file that has to be parsed')
  .option(
    '-i --index <index>',
    `Which index to use for storing the conents of the file. Available indices: ${Object.keys(
      indices
    )}`
  )
  .option('-u --url <url>', 'ElasticSearch cluster host url')
  .action(async opts => {
    try {
      await parse(opts)
    } catch (e) {
      process.stderr.write(e.message)
    }
  })

program
  .command('search')
  .description('Search the specified index')
  .option(
    '-i --index <index>',
    `Which index to use for storing the conents of the file. Available indices: ${Object.keys(
      indices
    )}`
  )
  .option('-k --key <key>', 'Which key to search for')
  .option('-v --value <value>', 'Value to search for')
  .option('-u --url <url>', 'ElasticSearch cluster host url')
  .action(async opts => {
    try {
      const result = await searchIndex(opts)
      process.stdout.write(JSON.stringify(result))
    } catch (e) {
      process.stderr.write(e.message)
    }
  })

program.version('0.0.1')
program.description(
  'Node.js CLI tool for parsing CSV/JSON files and storing their contents on an ElasticSearch cluster'
)

program.parse(process.argv)

if (!process.argv.slice(2).length) {
  program.outputHelp()
}
