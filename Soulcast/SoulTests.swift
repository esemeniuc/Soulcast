

import Foundation

let tester = Tester()

class Tester {
  func testAllTheThings() {
    print("Test All The Things here!")
    let soulTester = SoulTester()
    soulTester.setup()
    soulTester.testRecording()
  }
}

class SoulTester: NSObject {

  let recorder = SoulRecorder()
  let soulPlayer = SoulPlayer()
  let soulCaster = SoulCaster()
  
  func setup() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SoulTester.uploadingFinished), name: "uploadingFinished", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SoulTester.soulDidFailToPlay(_:)), name: "soulDidFailToPlay", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SoulTester.soulDidFinishPlaying(_:)), name: "soulDidFinishPlaying", object: nil)
    
  }
  
  func testRecording(){
    recorder.delegate = self
    recorder.pleaseStartRecording()
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      self.recorder.pleaseStopRecording()
    }
  }
  
  func testPlay(thisSoul:Soul){
    soulPlayer.startPlaying(thisSoul)
    //expect the sound to be what was just recorded...
  }
  
  func testOutgoing(mockSoul:Soul){
    soulCaster.delegate = self
    soulCaster.upload(mockSoul)
    //generate a local file with junk data if it does not exist
    //make a soul with that file
    //soulcaster.cast(soul)
    
  }
  
  func mockSoul() -> Soul {
    let seed = Soul()
    //TODO: switch out localURL for a valid file
    seed.localURL = "/Users/june/Library/Developer/CoreSimulator/Devices/773EB184-EEE2-499F-AB97-F63AEF6FC7FB/data/Containers/Data/Application/549676D1-DB20-401E-8ED9-E67142EC5BE2/Documents/Recording494031955.70334.m4a"
    seed.s3Key = "1428104002"
    seed.epoch = 14932432
    seed.longitude = -93.2783
    seed.latitude = 44.9817
    seed.token = seedDevice().token
    return seed
  }
  
  func soulIncomingSeed() -> Soul {
    let seed = Soul()
    seed.s3Key = "1428283167"
    seed.epoch = 1428283167
    seed.longitude = -122.956074765067
    seed.latitude = 49.281255654105202
    seed.radius = 0.10652049519712301
    let incomingDevice = Device()
    incomingDevice.id = 1
    //    seed.device = incomingDevice
    return seed
  }
  
  func seedDevice() -> Device {
    let seed = Device()
    seed.token = "e35c22814ff6b5217ac3823403a59bdc958fc9e20ef865b322546b1afefd552a"
    seed.longitude = -93.2783
    seed.latitude = 44.9817
    seed.arn = "arn:aws:sns:us-east-1:503476828113:endpoint/APNS_SANDBOX/Soulcast_Development/a08b89b5-3015-3d4b-a14a-f0e657fffedb"
    return seed
  }
  
  
  func uploadingFinished() {
    print("soulTester uploadingFinished")
  }
  
  func testIncoming(userInfo:NSDictionary) {
    print("testIncoming userInfo: \(userInfo)")
    soulCatcher.catchSoul(userInfo)
    
  }
  
  func soulDidFailToPlay(notification:NSNotification) {
    //let failSoul = notification.object as! Soul
    print("soulDidFailToPlay")
  }
  
  func soulDidFinishPlaying(notification:NSNotification) {
    //let finishedSoul = notification.object as! Soul
    print("soulDidFinishPlaying")
  }
  
  //  func getObjectRequest() -> AWSS3GetObjectRequest {
  //    let request = AWSS3GetObjectRequest()
  //    request.bucket = S3BucketName
  //    request.key = soulIncomingSeed().s3Key! + ".mp3"
  //
  //    return request
  //  }
  
}

extension SoulTester: SoulRecorderDelegate {
  func soulDidStartRecording(){
    print("SoulTester soulDidStartRecording")
  }
  func soulDidFinishRecording(newSoul: Soul){
    print("SoulTester soulDidFinishRecording")
    testPlay(newSoul)
    newSoul.epoch = 123321
    newSoul.s3Key = "1428104002"
    testOutgoing(newSoul)
  }
  func soulDidFailToRecord(){
    print("SoulTester soulDidFailToRecord")
  }
  func soulDidReachMinimumDuration(){
    
  }
}

extension SoulTester: SoulCasterDelegate {
  func soulDidStartUploading() {
    
  }
  func soulIsUploading(progress:Float) {
    
  }
  func soulDidFinishUploading() {
    print("soulDidFinishUploading from delegate!")
  }
  func soulDidFailToUpload() {
    
  }
  func soulDidReachServer() {
    
  }
}
