

import Foundation

let tester = Tester()

class Tester {
  func testAllTheThings() {
    print("Test All The Things here!")
    let soulTester = SoulTester()
//    soulTester.testPlaying()
//    soulTester.testRecording()
//    soulTester.testIncoming()
//    soulTester.testWavRainbow()
    soulTester.testJsonRainbow()
  }
}

class SoulTester: NSObject {

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
