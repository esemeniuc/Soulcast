

import Foundation
import UIKit

class IntegrationTestButton: UIButton {

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func setup() {
//    backgroundColor = UIColor.cyanColor().colorWithAlphaComponent(0.7)
    addTarget(self, action: #selector(integrationTest), forControlEvents: .TouchUpInside)
//    setTitle("Integrate", forState: .Normal)
  }
  
  func integrationTest() {
    print("integrationTest()")
    UIApplication.sharedApplication().delegate?.application!(UIApplication.sharedApplication(), didReceiveRemoteNotification: SoulCatcherTests.mockUserInfo())
  }
  
}