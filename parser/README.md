# CSV Parser

## Description

This is a simple Node.js CLI tool that reads a CSV file and puts its content to an ElasticSearch cluster.

## Installation

Download required dependencies by running

```bash
npm i
```

Afterwards, link the cli tool `parser`:

```bash
npm link
```

This will link `parser` CLI tool your path

## Usage

To see available commands:
```bash
$ parser
Usage: parser [options] [command]

Node.js CLI tool for parsing CSV/JSON files and storing their contents on an ElasticSearch cluster

Options:
  -V, --version         output the version number
  -h, --help            output usage information

Commands:
  initialize [options]  Initialize indices in the ElasticSearch cluster
  parse [options]       Parse a CSV file and store the contents on an ElasticSearch cluster
  search [options]      Search the specified index
```

Before parsing any files, create required indices by running

```bash
$ parser initialize
```

To parse file and populate an index, run:

```bash
$ parser parse -f examples/googleplaystore.csv -i GooglePlayStore
```

To search the cluster for a `Key:Value` pair:

```bash
$ parser search -i GooglePlayStore -k App -v RadPad
{"result":{"_index":"google_play_store","_type":"app","_id":"1501","_score":7.0359497,"_source":{"App":"RadPad: Apartment Finder App","Category":"HOUSE_AND_HOME","Rating":"4.4","Reviews":"6896","Size":"35M","Installs":"500,000+","Type":"Free","Price":"0","Content Rating":"Everyone","Genres":"House & Home","Last Updated":"August 30, 2017","Current Ver":"1.7.3","Android Ver":"4.1 and up","id":1501}}}
{"took":17,"timed_out":false,"_shards":{"total":5,"successful":5,"skipped":0,"failed":0},"hits":{"total":1,"max_score":7.0359497,"hits":[{"_index":"google_play_store","_type":"app","_id":"1501","_score":7.0359497,"_source":{"App":"RadPad: Apartment Finder App","Category":"HOUSE_AND_HOME","Rating":"4.4","Reviews":"6896","Size":"35M","Installs":"500,000+","Type":"Free","Price":"0","Content Rating":"Everyone","Genres":"House & Home","Last Updated":"August 30, 2017","Current Ver":"1.7.3","Android Ver":"4.1 and up","id":1501}}]}}
```

