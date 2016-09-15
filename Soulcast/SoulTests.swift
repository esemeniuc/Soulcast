

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
  
  func testIncoming(userInfo: [NSObject : AnyObject]){
    //TODO: mock user info...
    let mockInfo = soulCatcherTests.mockUserInfo()
    soulCatcherTests.testIncoming(mockInfo)
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
  func soulDidStartRecording(){
    
  }
    
    func soulIsRecording(progress: CGFloat) {
        //
    }
  func soulDidFinishRecording(newSoul: Soul){
    newSoul.epoch = 1234567890
    newSoul.s3Key = "fabulousTest"
    //upload
    let soulCaster = SoulCaster()
    soulCaster.delegate = self
    soulCaster.cast(newSoul)
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
  func soulIsUploading(progress:Float){
    
  }
  func soulDidFinishUploading(soul:Soul){
    //download
    soul.type = .Broadcast
    let soulCatcher = SoulCatcher()
    soulCatcher.delegate = self
    soulCatcher.catchSoulObject(soul)
  }
  func soulDidFailToUpload(){
    
  }
  func soulDidReachServer(){
    
  }
}

extension SoulTester: SoulCatcherDelegate {
  func soulDidStartToDownload(soul:Soul){
    
  }
  func soulIsDownloading(progress:Float){
    
  }
  func soulDidFinishDownloading(soul:Soul){
    //play
    let soulPlayer = SoulPlayer()
    soulPlayer.startPlaying(soul)
  }
  func soulDidFailToDownload(){
    
  }
}
