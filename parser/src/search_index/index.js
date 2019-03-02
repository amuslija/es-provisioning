const { Client } = require('elasticsearch')
const { indices } = require('../../config')

const searchIndex = async ({ index, url, key, value }) => {
  if (!Object.keys(indices).includes(index)) {
    throw new Error('Index not allowed')
  }

  const { indexName, type } = indices[index]

  const client = new Client({
    hosts: url || 'http://localhost:9200'
  })
  const result = await client.search({
    index: indexName,
    type: type,
    body: {
      query: {
        match: {
          [key]: value
        }
      }
    }
  })
  console.log(JSON.stringify({ result: result.hits.hits[0] }))
  return result
}

module.exports = searchIndex
