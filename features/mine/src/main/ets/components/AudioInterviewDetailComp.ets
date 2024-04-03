import { AudioItemModel } from '../views/AudioInterviewComp'
import { audio } from '@kit.AudioKit'
import { logger } from '@itcast/basic/Index'
import { fileIo as fs } from '@kit.CoreFileKit'

@Component
export struct AudioInterviewDetailComp {
  @State
  playing: boolean = false
  @Prop
  activeItem: AudioItemModel | null
  audioRenderer: audio.AudioRenderer | null = null
  @Prop total: number = 0
  @Prop value: number = 0

  aboutToAppear(): void {
    this.initAudioRenderer()
  }

  async initAudioRenderer() {
    try {
      let audioStreamInfo: audio.AudioStreamInfo = {
        samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000,
        channels: audio.AudioChannel.CHANNEL_1,
        sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
        encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
      }
      let audioRendererInfo: audio.AudioRendererInfo = {
        usage: audio.StreamUsage.STREAM_USAGE_MOVIE,
        rendererFlags: 0
      }

      let audioRendererOptions: audio.AudioRendererOptions = {
        streamInfo: audioStreamInfo,
        rendererInfo: audioRendererInfo
      }
      this.audioRenderer = await audio.createAudioRenderer(audioRendererOptions)
    } catch (e) {
      logger.error('initAudioRenderer', JSON.stringify(e))
    }
  }

  async play() {
    if (this.audioRenderer) {
      try {
        this.playing = true
        this.audioRenderer.on('stateChange', (state) => {
          logger.info('state change', state.toString())
        })
        await this.audioRenderer.start()
        const bufferSize = await this.audioRenderer.getBufferSize()
        const file = fs.openSync(this.activeItem?.path, fs.OpenMode.READ_ONLY);
        const stat = fs.statSync(this.activeItem?.path)
        const buf = new ArrayBuffer(bufferSize);
        const len = stat.size % bufferSize == 0 ? Math.floor(stat.size / bufferSize) : Math.floor(stat.size / bufferSize + 1);
        this.total = len
        for (let i = 0; i < len; i++) {
          fs.readSync(file.fd, buf, {
            offset: i * bufferSize,
            length: bufferSize
          })
          await this.audioRenderer?.write(buf)
          this.value = i
        }
        this.stop()
      } catch (e) {
        logger.error('audioRenderer play', JSON.stringify(e))
      }
    }
  }

  async stop() {
    if (this.audioRenderer) {
      await this.audioRenderer.stop()
      this.playing = false
    }
  }

  aboutToDisappear(): void {
    this.audioRenderer?.release()
  }

  build() {
    Column({ space: 20 }) {
      Image($r('app.media.ic_mine_audio'))
        .width(100)
        .aspectRatio(1)
        .geometryTransition(this.activeItem?.path)
        .transition(TransitionEffect.OPACITY)
      Text(this.activeItem?.name)
        .fontSize(18)
        .transition(TransitionEffect.asymmetric(
          TransitionEffect.OPACITY
            .combine(TransitionEffect.translate({ y: 100 })),
          TransitionEffect.OPACITY.animation({ duration: 0 })
        ))

      Row({ space: 20 }) {
        Image(!this.playing ? $r('sys.media.ohos_ic_public_play') : $r('sys.media.ohos_ic_public_pause'))
          .width(24)
          .aspectRatio(1)
          .onClick(() => {
            if (!this.playing) {
              this.play()
            } else {
              this.stop()
            }
          })
        Progress({ value: this.value, total: this.total })
          .layoutWeight(1)
          .margin({ top: 20, bottom: 20 })
      }
      .width('80%')
      .transition(TransitionEffect.asymmetric(
        TransitionEffect.OPACITY
          .combine(TransitionEffect.translate({ y: 100 })),
        TransitionEffect.OPACITY.animation({ duration: 0 })
      ))
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.white'))
  }
}