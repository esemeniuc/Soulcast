

import Foundation

let tester = Tester()

class Tester {
  func testAllTheThings() {
    print("Test All The Things here!")
    let soulTester = SoulTester()
    soulTester.testRecording()
    soulTester.testIncoming()
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
  
}

