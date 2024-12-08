package com.example.my_appppp

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import java.util.Timer
import java.util.TimerTask

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.example.event_channel"
    private var eventSink: EventChannel.EventSink? = null
    private var timer: Timer? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        //이벤트 채널 생성
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {

                //Flutter의 구독 -> OnListen
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    startFakeDataStream();
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    stopFakeDataStream();
                }
            }
        )
    }




    private fun startFakeDataStream() {
        timer = Timer()
        timer?.schedule(object: TimerTask(){
            override fun run() {
                val fakeData = (0..100).random() // 0부터 100 사이의 임의의 데이터 생성

                runOnUiThread { //Main Thread에서 전달해야한다.
                    eventSink?.success(fakeData) //지속적인 데이터 전달...
                }

            }

        }, 0, 1000)
    }

    private fun stopFakeDataStream() {
        timer?.cancel()
        timer = null
    }
}

