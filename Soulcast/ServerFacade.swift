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
        if response.response?.statusCode == 502 {
          print("Outgoing Soul Post Failure!")
          failure((response.response?.statusCode)!)
        } else {
          print("Outgoing Soul Post success!")
          success()
        }
        
      case .Failure:
        print("Outgoing Soul Post Failure!")
        failure((response.response?.statusCode)!)
      }
    }
  }
  
  class func echo(outgoingSoul: Soul, success:()->(), failure: (Int)->()) {
    request(.POST, serverURL + "/echo/", parameters: (outgoingSoul.toParams() as! [String : AnyObject])).responseString { response in
      switch response.result{
      case .Success:
        if response.response?.statusCode == 502 {
          print("Echo Soul Failure!")
          failure((response.response?.statusCode)!)
        } else {
          print("Echo Soul success!")
          success()
        }
        
      case .Failure:
        print("Echo Soul Failure!")
        failure((response.response?.statusCode)!)
      }
    }
  }
  
  class func post(localDevice: Device, success:()->(), failure: (Int)->()) {
    request(.POST, serverURL + "/devices/", parameters: localDevice.toParams()).responseString { (response) in
      switch response.result {
      case .Success:
        if response.response?.statusCode == 502 {
          print("Register local device failure!")
          failure((response.response?.statusCode)!)
        } else {
          print("Register local device success!")
          success()
        }
      case .Failure :
        print("Register local device failure!")
        failure((response.response?.statusCode)!)
      }
    }
  }
  
  class func patch(localDevice: Device, success:()->(), failure: (Int)->()) {
    request(.PATCH, serverURL + "/devices/", parameters: localDevice.toParams()).responseString { (response) in
      switch response.result {
      case .Success:
        if response.response?.statusCode == 502 {
          print("Update local device failure!")
          failure((response.response?.statusCode)!)
        } else {
          print("Update local device success!")
          success()
        }
      case .Failure :
        print("Update local device failure!")
        failure((response.response?.statusCode)!)
      }
    }
  }
  
}