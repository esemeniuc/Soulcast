

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
    backgroundColor = UIColor.cyan.withAlphaComponent(0.7)
    addTarget(self, action: #selector(integrationTest), for: .touchUpInside)
    setTitle("Push Soul", for: UIControlState())
  }
  
  func integrationTest() {
    print("integrationTest()")
//    ServerFacade.getHistory({ (souls) in
//      //
//      }) { (code) in
//        print("Server error \(code)")
//    }
    UIApplication.shared.delegate?.application!(UIApplication.shared, didReceiveRemoteNotification: SoulCatcherTests.mockUserInfo())
  }
  
}
