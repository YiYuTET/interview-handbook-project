import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { AudioItemModel } from '../views/AudioInterviewComp'

class AudioDataManager {
  private store: relationalStore.RdbStore | null = null
  private dbName = 'AUDIO_INTERVIEW'

  async initDB() {
    const SQL_CREATE = `CREATE TABLE IF NOT EXISTS ${this.dbName} (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        USER_ID TEXT NOT NULL,
        NAME TEXT NOT NULL,
        PATH TEXT NOT NULL,
        TEXT TEXT NOT NULL,
        DURATION INTEGER NOT NULL,
        SIZE INTEGER NOT NULL
      )`
    if (!this.store) {
      this.store = await relationalStore.getRdbStore(getContext(), {
        name: `${this.dbName}.db`,
        securityLevel: relationalStore.SecurityLevel.S1
      })
    }
    if (this.store.version === 0) {
      this.store.executeSql(SQL_CREATE)
      this.store.version = 1
    }
  }

  async insert(item: AudioItemModel) {
    const valueBucket: ValuesBucket = {
      NAME: item.name,
      PATH: item.path,
      TEXT: item.text,
      DURATION: item.duration,
      SIZE: item.size,
      USER_ID: item.user_id
    }
    const rowId = await this.store?.insert(this.dbName, valueBucket)
    if (rowId === undefined || rowId === -1) return Promise.reject('insert fail')
    else return Promise.resolve()
  }

  async update(item: AudioItemModel) {
    const valueBucket: ValuesBucket = {
      NAME: item.name,
      PATH: item.path,
      TEXT: item.text,
      DURATION: item.duration,
      SIZE: item.size,
      USER_ID: item.user_id
    }
    const predicates = new relationalStore.RdbPredicates(this.dbName)
    predicates.equalTo('ID', item.id)
    const rowId = await this.store?.update(valueBucket, predicates)
    if (rowId === undefined || rowId === -1) return Promise.reject('update fail')
    else return Promise.resolve()
  }

  async delete(id: number) {
    const predicates = new relationalStore.RdbPredicates(this.dbName)
    predicates.equalTo('ID', id)
    const rowId = await this.store?.delete(predicates)
    if (rowId === undefined || rowId === -1) return Promise.reject('update fail')
    else return Promise.resolve()
  }

  async query(userId: string, id?: number) {
    const predicates = new relationalStore.RdbPredicates(this.dbName)
    predicates.equalTo('USER_ID', userId)
    if (id) {
      predicates.equalTo('ID', id)
    }
    const resultSet = await this.store?.query(predicates)
    if (!resultSet) return Promise.reject('query fail')
    const list: AudioItemModel[] = []
    while (resultSet.goToNextRow()) {
      list.push(new AudioItemModel({
        id: resultSet.getLong(resultSet.getColumnIndex('ID')),
        name: resultSet.getString(resultSet.getColumnIndex('NAME')),
        path: resultSet.getString(resultSet.getColumnIndex('PATH')),
        text: resultSet.getString(resultSet.getColumnIndex('TEXT')),
        duration: resultSet.getLong(resultSet.getColumnIndex('DURATION')),
        size: resultSet.getLong(resultSet.getColumnIndex('SIZE')),
        user_id: resultSet.getString(resultSet.getColumnIndex('USER_ID')),
      }))
    }
    resultSet.close()
    return Promise.resolve(list)
  }
}

export const audioDataManager = new AudioDataManager()