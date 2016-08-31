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
  
  
  class func post(outgoingSoul: Soul, success:()->(), failure: (Int)->()) {
    request(.POST, serverURL + "/souls/", parameters: (outgoingSoul.toParams() as! [String : AnyObject])).responseString { response in
      switch response.result{
      case .Success:
        print("Outgoing Soul Post success!")
        
        
        success()
      case .Failure:
        print("Outgoing Soul Post Failure!")
        failure((response.response?.statusCode)!)
      }
    }
  }
}