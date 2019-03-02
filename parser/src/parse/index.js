const { extname } = require('path')
const parseCsv = require('./parse_csv')
const parseJson = require('./parse_json')

const parse = (options = {}) => {
  const { file } = options
  const ext = extname(file)
  switch (ext) {
    case '.csv':
      return parseCsv(options)
    case '.json':
      return parseJson(options)
    default:
      return {}
  }
}

module.exports = parse
