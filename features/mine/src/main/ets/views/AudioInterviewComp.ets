import { HdNav, HdUser, logger } from '@itcast/basic/Index'
import { abilityAccessCtrl, common } from '@kit.AbilityKit'
import { audio } from '@kit.AudioKit'
import { fileIo as fs, WriteOptions } from '@kit.CoreFileKit'
import dayjs from 'dayjs'
import { AudioInterviewDetailComp } from '../components/AudioInterviewDetailComp'
import { audioDataManager } from '../manager/audioDataManager'


@Component
export struct AudioInterviewComp {
  @StorageProp('user')
  user: HdUser = {} as HdUser
  @State
  list: AudioItemModel[] = []
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @State
  recording: boolean = false
  @State
  dbList: number[] = []
  @State
  swipeOffset: number = 0
  @State
  showDetail: boolean = false
  @State
  opacityValue: number = 1
  @State
  activeItem: AudioItemModel | null = null

  aboutToAppear(): void {
    this.initPermissions()
    audioDataManager.initDB().then(async () => {
      this.list = await audioDataManager.query(this.user.id)
    })
  }

  aboutToDisappear(): void {
    this.releaseRecord()
  }

  initPermissions() {
    let atManager = abilityAccessCtrl.createAtManager();
    let context: Context = getContext(this) as common.UIAbilityContext;
    atManager.requestPermissionsFromUser(context, [
      "ohos.permission.MICROPHONE",
    ]).then((res) => {
      if (res.authResults.every(v => v === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)) {
        this.initAudioCapture()
      }
    })
  }

  audioCapture: audio.AudioCapturer | null = null

  async initAudioCapture() {
    try {
      const audioStreamInfo: audio.AudioStreamInfo = {
        samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000,
        channels: audio.AudioChannel.CHANNEL_1,
        sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
        encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
      }
      const audioCapturerInfo: audio.AudioCapturerInfo = {
        source: audio.SourceType.SOURCE_TYPE_MIC,
        capturerFlags: 0
      }
      const audioCapturerOptions: audio.AudioCapturerOptions = {
        streamInfo: audioStreamInfo,
        capturerInfo: audioCapturerInfo
      }
      this.audioCapture = await audio.createAudioCapturer(audioCapturerOptions)
      logger.info('initAudioCapture success');
    } catch (e) {
      logger.error('initAudioCapture error', e.message);
    }
  }

  fileTimestamp: number = 0

  async startRecord() {
    try {
      if (this.audioCapture) {
        const stateGroup = [audio.AudioState.STATE_PREPARED, audio.AudioState.STATE_PAUSED, audio.AudioState.STATE_STOPPED]
        if (stateGroup.includes(this.audioCapture.state)) {
          // let bufferSize = 0
          // const readDataCallback = (buffer: ArrayBuffer) => {
          //   const filePath = getContext(this).filesDir + `/${Date.now()}.wav`;
          //   const file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
          //   const options: WriteOptions = {
          //     offset: bufferSize,
          //     length: buffer.byteLength
          //   }
          //   fs.writeSync(file.fd, buffer, options);
          //   bufferSize += buffer.byteLength;
          // }
          // this.audioCapture.on('readData', readDataCallback)
          await this.audioCapture.start()
          let count = 0
          this.fileTimestamp = Date.now()
          const filePath = getContext(this).filesDir + `/${this.fileTimestamp}.wav`;
          const file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
          while (true) {
            let bufferSize = await this.audioCapture.getBufferSize();
            let buffer = await this.audioCapture.read(bufferSize, true);
            let options: WriteOptions = {
              offset: count * bufferSize,
              length: bufferSize
            };
            if (buffer) {
              let number = fs.writeSync(file.fd, buffer, options);
              this.dbList.push(this.calcDB(buffer))
              logger.info(`write data : ${number}`, buffer.byteLength.toString());
            }
            count++
          }
        } else {
          logger.error('startRecord error', 'state error');
        }
      }
    } catch (e) {
      logger.error('startRecord error', JSON.stringify(e));
    }
  }

  calcDB(pcm: ArrayBuffer) {
    let sum = 0;
    const pcmView = new DataView(pcm)
    const numSamples = pcm.byteLength / 2
    for (let i = 0; i < pcm.byteLength; i += 2) {
      const samples = pcmView.getInt16(i, true)
      sum += samples * samples
    }
    // 平均振幅
    const meanSquare = sum / numSamples
    // 计算RMS（均方根）振幅
    const rmsAmplitude = Math.sqrt(meanSquare);
    // 计算分贝
    const decibels = 20 * Math.log10(rmsAmplitude / 32767);
    const staticValue = 60
    if (decibels >= Infinity) {
      return staticValue;
    } else {
      return decibels + staticValue < 0 ? 0 : decibels + staticValue;
    }
  }

  // 停止采集
  async stopRecord() {
    if (this.audioCapture) {
      if (this.audioCapture.state === audio.AudioState.STATE_RUNNING
        || this.audioCapture.state === audio.AudioState.STATE_PAUSED) {
        try {
          await this.audioCapture.stop()
          const filePath = getContext(this).filesDir + `/${this.fileTimestamp}.wav`;
          const stat = fs.statSync(filePath)
          const item = new AudioItemModel({
            id: null,
            path: filePath,
            name: dayjs(this.fileTimestamp).format('YYYY年MM月DD日_HH时mm分ss秒'),
            duration: Date.now() - this.fileTimestamp,
            size: stat.size,
            text: '',
            user_id: this.user.id
          })
          await audioDataManager.insert(item)
          const list = await audioDataManager.query(this.user.id)
          this.list = list
          logger.info('stopRecord success');
          return Promise.resolve()
        } catch (e) {
          logger.error('stopRecord error', e.message);
        }
      } else {
        logger.error('stopRecord error', 'state error');
      }
    }
  }

  // 销毁实例，释放资源
  async releaseRecord() {
    if (this.audioCapture) {
      if (this.audioCapture.state !== audio.AudioState.STATE_RELEASED
        && this.audioCapture.state !== audio.AudioState.STATE_NEW) {
        try {
          await this.audioCapture.release()
          logger.info('releaseRecord success');
        } catch (e) {
          logger.error('releaseRecord error', e.message);
        }
      } else {
        logger.error('releaseRecord error', 'state error');
      }
    }
  }

  @Builder
  DeleteBuilder(onEdit: () => void, onDelete: () => void) {
    Row() {
      Text('编辑')
        .width(80)
        .height(80)
        .backgroundColor($r('app.color.common_blue'))
        .fontColor($r('app.color.white'))
        .textAlign(TextAlign.End)
        .padding({ left: 20, right: 20 })
        .onClick(() => {
          onEdit()
        })
      Text('删除')
        .width(80)
        .height(80)
        .backgroundColor('#DD0033')
        .fontColor($r('app.color.white'))
        .textAlign(TextAlign.End)
        .padding({ left: 20, right: 20 })
        .onClick(() => {
          onDelete()
        })
    }
  }

  @Builder
  DetailBuilder() {
    Column() {
      AudioInterviewDetailComp({ activeItem: this.activeItem })
    }
    .transition(TransitionEffect.OPACITY)
  }

  build() {
    Column() {
      HdNav({
        title: '面试录音',
        hasBorder: true,
        showRightIcon: false
      })
      List() {
        ForEach(this.list, (item: AudioItemModel) => {
          ListItem() {
            AudioItemComp({ item: item })
              .onClick(() => {
                this.activeItem = item
                animateTo({ duration: 300 }, () => {
                  this.showDetail = true
                  this.opacityValue = 0
                })
              })
          }
          .transition({ type: TransitionType.Delete, opacity: 0 })
          .swipeAction({
            end: this.DeleteBuilder(() => {
              // 编辑
            }, async () => {
              // 删除
              await audioDataManager.delete(item.id)
              const list = await audioDataManager.query(this.user.id)
              fs.unlinkSync(item.path)
              animateTo({ duration: 300 }, () => {
                this.list = list
              })
            })
          })
        }, (item: AudioItemModel) => item.id?.toString())
      }
      .width('100%')
      .height('100%')
      .layoutWeight(1)
      .divider({
        strokeWidth: 0.5,
        color: $r('app.color.common_gray_bg'),
        startMargin: 15,
        endMargin: 15
      })

      Stack({ alignContent: Alignment.Center }) {
        Row() {
          ForEach(this.dbList.slice(-300), (db: number) => {
            Text()
              .width(1)
              .height(db * 1.6)
              .backgroundColor($r('app.color.common_blue'))
          })
        }
        .width(300)
        .height(100)

        Text()
          .height(0.5)
          .width(300)
          .backgroundColor($r('app.color.common_blue'))
      }
      .width('100%')
      .height(this.recording ? 100 : 0)
      .animation({ duration: 300 })
      .backgroundColor($r('app.color.common_gray_bg'))
      .clip(true)

      Row() {
        Row() {
          Image($r('sys.media.ohos_ic_public_voice'))
            .width(24)
            .aspectRatio(1)
            .fillColor($r('app.color.white'))
            .onClick(async () => {
              if (this.recording) {
                this.recording = false
                this.dbList = []
                await this.stopRecord()
              } else {
                this.recording = true
                await this.startRecord()
              }
            })
        }
        .justifyContent(FlexAlign.Center)
        .height(50)
        .width(50)
        .borderRadius(25)
        .backgroundColor(this.recording ? $r('app.color.common_blue') : $r('app.color.black'))
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .height(140)
      .backgroundColor($r('app.color.common_gray_bg'))
      .padding({ bottom: this.bottomHeight })
    }
    .width('100%')
    .height('100%')
    .bindContentCover(this.showDetail, this.DetailBuilder, {
      modalTransition: ModalTransition.NONE,
      onDisappear: () => {
        animateTo({ duration: 300 }, () => {
          this.showDetail = false
          this.opacityValue = 1
        })
      }
    })
    .opacity(this.opacityValue)
  }
}


export interface AudioItem {
  id: number | null
  user_id: string
  path: string
  name: string
  duration: number
  text: string
  size: number
}

@Observed
export class AudioItemModel implements AudioItem {
  id: number | null = null
  user_id: string = ''
  path: string = ''
  name: string = ''
  duration: number = 0
  text: string = ''
  size: number = 0

  constructor(model: AudioItem) {
    this.path = model.path
    this.name = model.name
    this.duration = model.duration
    this.text = model.text
    this.size = model.size
    this.id = model.id
    this.user_id = model.user_id
  }
}

@Component
struct AudioItemComp {
  @ObjectLink
  item: AudioItemModel

  build() {
    Row({ space: 15 }) {
      Image($r('app.media.ic_mine_audio'))
        .width(50)
        .aspectRatio(1)
        .geometryTransition(this.item.path, { follow: true })
        .transition(TransitionEffect.OPACITY.animation({ duration: 300 }))
      Column({ space: 10 }) {
        Text(this.item.name)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Row({ space: 20 }) {
          Text(`时长：${(this.item.duration / 1000).toFixed(2)} 秒`)
            .fontSize(14)
            .fontColor($r('app.color.common_gray_03'))
          Text(`大小：${(this.item.size / 1000)} KB`)
            .fontSize(14)
            .fontColor($r('app.color.common_gray_03'))
        }
        .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .alignSelf(ItemAlign.Start)
    }
    .padding(15)
    .height(80)
    .width('100%')
  }
}