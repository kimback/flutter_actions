// iOS 코드 - AppDelegate.swift
import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var eventSink: FlutterEventSink?
  private var timer: Timer?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let eventChannel = FlutterEventChannel(name: "com.example.event_channel",
                                           binaryMessenger: controller.binaryMessenger)

    eventChannel.setStreamHandler(self) //delegate 등록

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      
  }
}





//확장 구현
extension AppDelegate: FlutterStreamHandler {
  
    
    
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
      
        eventSink = events
        startFakeDataStream() //데이터 스트림 시작
      
        return nil
  }

    
    
    
  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    
    eventSink = nil
    stopFakeDataStream()
      
    return nil
  }

  private func startFakeDataStream() {
      
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      guard let self = self else { return }
      let fakeData = Int.random(in: 0...100) // 0부터 100 사이의 임의의 데이터 생성
     
        DispatchQueue.main.async { // Main Thread에서 전달해야 함
            self.eventSink?(fakeData) // 지속적인 데이터 전달
        }
        
    }
      
  }

  private func stopFakeDataStream() {
    timer?.invalidate()
    timer = nil
  }
}

