const { Client } = require('elasticsearch')
const { map } = require('lodash')
const { enabledIndices } = require('../../config')

const createIndices = async ({ url }) => {
  const client = new Client({
    hosts: url || 'http://localhost:9200'
  })
  const createIndex = async index => {
    try {
      await client.indices.create({
        index
      })
    } catch (e) {
      if (!e.message.includes('resource_already_exists_exception')) {
        throw e
      }
    }
  }

  await Promise.all(map(enabledIndices, index => createIndex(index)))
}

module.exports = createIndices
