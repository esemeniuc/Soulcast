

import Foundation
import UIKit

let tester = SoulTester()

class SoulTester: NSObject {

  func testAllTheThings() {
    print("Test All The Things here!")
    
//    testPlaying()
//    testRecording()
    testIncoming(["":""])
//    testWavRainbow()
//    testJsonRainbow()
  }
  
  let soulRecorderTests = SoulRecorderTests()
  let soulPlayerTests = SoulPlayerTests()
  let soulCasterTests = SoulCasterTests()
  let soulCatcherTests = SoulCatcherTests()
  
  func testRecording() {
    soulRecorderTests.testRecording()
  }
  
  func testOutgoing() {
    soulCasterTests.testOutgoing()
  }
  
  func testIncoming() {
    soulCatcherTests.testIncoming()
  }
  
  func testIncoming(_ userInfo: [AnyHashable: Any]){
    let mockInfo = SoulCatcherTests.mockUserInfo()
    soulCatcherTests.testIncoming(mockInfo["soulObject"] as! [String: AnyObject])
    return
//    soulCatcherTests.testIncoming(userInfo)
  }
  
  func testPlaying() {
    soulPlayerTests.testPlay()
  }
  
  func testWavRainbow() {
    //record, upload, download, play
    let recorder = SoulRecorder()
    recorder.delegate = self
    recorder.pleaseStartRecording()
  }
  
  func testJsonRainbow() {
    soulCasterTests.testOutgoingJson()
    
  }
  
}

//wav rainbow
extension SoulTester: SoulRecorderDelegate {
  internal func recorderDidFinishRecording(_ localURL: String) {
    let newSoul = Soul(voice:Voice(
      epoch: 1234567890,
      s3Key: "fabulousTest",
      localURL: localURL))

    let soulCaster = SoulCaster()
    soulCaster.delegate = self
    soulCaster.cast(newSoul)
  }

  func soulDidStartRecording(){
    
  }
    
    func soulIsRecording(_ progress: CGFloat) {
        //
    }
  
  func soulDidFailToRecord(){
    
  }
  func soulDidReachMinimumDuration(){
    
  }
}
//wav rainbow
extension SoulTester: SoulCasterDelegate {
  func soulDidStartUploading(){
    
  }
  func soulIsUploading(_ progress:Float){
    
  }
  func soulDidFinishUploading(_ soul:Soul){
    //download
    soul.type = .Broadcast
    let soulCatcher = SoulCatcher(soul:soul)
    soulCatcher.delegate = self
  }
  func soulDidFailToUpload(){
    
  }
  func soulDidReachServer(){
    
  }
}

extension SoulTester: SoulCatcherDelegate {
  func soulDidStartToDownload(_ catcher: SoulCatcher, soul:Soul){
    
  }
  func soulIsDownloading(_ catcher: SoulCatcher, progress:Float){
    
  }
  func soulDidFinishDownloading(_ catcher: SoulCatcher, soul:Soul){
    //play
    let soulPlayer = SoulPlayer()
    soulPlayer.startPlaying(soul)
  }
  func soulDidFailToDownload(_ catcher: SoulCatcher){
    
  }
}
