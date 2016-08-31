//
//  ServerFacade.swift
//  Soulcast
//
//  Created by June Kim on 2016-08-30.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import Alamofire

class ServerFacade {
  //
  
  
  class func post(outgoingSoul: Soul, success:()->(), failure: (String)->()) {
    request(.POST, serverURL + "/souls", parameters: (outgoingSoul.toParams(.Broadcast) as! [String : AnyObject])).responseJSON { response in
      switch response.result{
      case .Success:
        print("Outgoing Soul Post success!")
        success()
      case .Failure:
        print("Outgoing Soul Post Failure!")
        failure("error message")
      }
    }
  }
}