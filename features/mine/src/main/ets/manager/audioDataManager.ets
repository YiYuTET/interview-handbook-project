import { logger } from '@itcast/basic/Index'
import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { JSON } from '@kit.ArkTS'
import { AudioItemModel } from '../views/AudioInterviewComp'

class AudioDataManager {
  private store: relationalStore.RdbStore | null = null
  private dbName = 'AUDIO_INTERVIEW'

  async initDB() {
    try {
      const SQL_CREATE = `CREATE TABLE IF NOT EXISTS ${this.dbName} (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        USER_ID TEXT NOT NULL,
        NAME TEXT NOT NULL,
        PATH TEXT NOT NULL,
        TEXT TEXT NOT NULL,
        DURATION INTEGER NOT NULL,
        SIZE INTEGER NOT NULL
      )`
      const store = await relationalStore.getRdbStore(getContext(), {
        name: 'AudioInterview.db',
        securityLevel: relationalStore.SecurityLevel.S1
      })
      if (store.version === 0) {
        store.executeSql(SQL_CREATE)
        store.version = 1
      }
      this.store = store
    } catch (err) {
      logger.error('AudioDataManager initDB', JSON.stringify(err))
    }
  }

  insert(item: AudioItemModel) {
    return new Promise<void>(async (resolve, reject) => {
      if (this.store) {
        try {
          const valueBucket: ValuesBucket = {
            NAME: item.name,
            PATH: item.path,
            TEXT: item.text,
            DURATION: item.duration,
            SIZE: item.size,
            USER_ID: item.user_id
          }
          const rowId = await this.store.insert(this.dbName, valueBucket)
          if (rowId) {
            resolve()
          } else {
            reject('insert error')
          }
        } catch (err) {
          reject(err)
        }
      }
    })
  }

  update(item: AudioItemModel) {
    return new Promise<void>(async (resolve, reject) => {
      if (this.store && item.id) {
        try {
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
          const rowId = await this.store.update(valueBucket, predicates)
          if (rowId) {
            resolve()
          } else {
            reject('update error')
          }
        } catch (err) {
          reject(err)
        }
      }
    })
  }

  delete(id: number) {
    return new Promise<void>(async (resolve, reject) => {
      if (this.store) {
        try {
          const predicates = new relationalStore.RdbPredicates(this.dbName)
          predicates.equalTo('ID', id)
          const rowId = await this.store.delete(predicates)
          if (rowId) {
            resolve()
          } else {
            reject('update error')
          }
        } catch (err) {
          reject(err)
        }
      }
    })
  }

  query(userId: string, id?: number) {
    return new Promise<AudioItemModel[]>(async (resolve, reject) => {
      if (this.store) {
        try {
          const predicates = new relationalStore.RdbPredicates(this.dbName)
          predicates.equalTo('USER_ID', userId)
          if (id) {
            predicates.equalTo('ID', id)
          }
          const resultSet = await this.store.query(predicates)
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
          resolve(list)
        } catch (err) {
          reject(err)
        }
      }
    })
  }
}

export const audioDataManager = new AudioDataManager()