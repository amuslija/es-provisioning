const csv = require('fast-csv')
const { createReadStream } = require('fs')
const storeDocuments = require('../../store_documents')

const { bulkSize } = require('../../../config')

const parseCsv = async ({ file, index, url }) => {
  const fileStream = createReadStream(file)

  let documents = []
  let id = 0
  const csvStream = csv({ headers: true })
    .on('data', async document => {
      if (documents.length >= bulkSize) {
        storeDocuments({ index, url, documents })
        documents = []
      }
      documents.push({ ...document, id })
      id++
    })
    .on('end', () => process.stdout.write(`Finished parsing ${file}`))
  fileStream.pipe(csvStream)
}

module.exports = parseCsv
