const { Client } = require('elasticsearch')
const { indices } = require('../../config')
const { flatten, map } = require('lodash')

const createBulkRequest = ({ index, type, documents }) => {
  return flatten(
    map(documents, doc => [
      { index: { _index: index, _type: type, _id: doc.id } },
      { ...doc }
    ])
  )
}

const storeDocuments = async ({ index, documents, url }) => {
  if (!Object.keys(indices).includes(index)) {
    throw new Error('Index not allowed')
  }
  const { indexName, type } = indices[index]
  const client = new Client({
    hosts: url || 'http://localhost:9200'
  })

  try {
    const bulkRequest = createBulkRequest({
      index: indexName,
      type: type,
      documents
    })
    const result = await client.bulk({ body: bulkRequest })
    return result
  } catch (e) {
    process.stderr.write(e.message)
  }
}

module.exports = storeDocuments
