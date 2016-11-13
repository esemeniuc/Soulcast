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
  static let validStatusCodes = 100..<400
  
  class func getLatest(success:([String : AnyObject])->(), failure:(Int)->()){
    //TODO: test.
    request(.GET,
      serverURL + "/souls",
      parameters: Device.localDevice.toParams(),
      encoding: .JSON,
      headers: jsonHeader)
      .validate(statusCode:validStatusCodes)
      .responseJSON { (response) in
        switch response.result {
        case .Success(let JSON):
          print("Got Latest Soul!")
          success(JSON as! [String: AnyObject])
        case .Failure:
          if let r = response.response {
            failure(r.statusCode)
          }
          
        }
    }
  }
  
  class func post(outgoingSoul: Soul, success:()->(), failure: (Int)->()) {
    
    request(.POST,
      serverURL + "/souls/",
      parameters: outgoingSoul.toParams(),
      encoding: .JSON,
      headers: jsonHeader)
      .validate(statusCode: validStatusCodes)
      .responseString { response in
        switch response.result{
        case .Success:
          print("Outgoing Soul Post success!")
          success()
        case .Failure:
          print("Outgoing Soul Post Failure!")
          if let r = response.response {
            failure(r.statusCode)
          }
        }
    }
  }

  class func improve(feedbackSoul: Soul, success:()->(), failure: (Int)->()) {
    request(.POST,
      serverURL + "/improves/",
      parameters: feedbackSoul.toParams(),
      encoding: .JSON,
      headers: jsonHeader)
      .validate(statusCode: validStatusCodes)
      .responseString { response in
        switch response.result{
        case .Success:
          print("Outgoing Soul Post success!")
          success()
        case .Failure:
          print("Outgoing Soul Post Failure!")
          if let r = response.response {
            failure(r.statusCode)
          }
        }
    }
  }
  
  class func echo(outgoingSoul: Soul, success:(Soul)->(), failure: (Int)->()) {
    request(.POST,
      serverURL + "/echo/",
      parameters: (outgoingSoul.toParams()),
      encoding: .JSON,
      headers: jsonHeader)
      .validate(statusCode: validStatusCodes)
      .responseJSON { response in
      switch response.result{
      case .Success(let JSON):
        print("Echo Soul success!")
        let soul = Soul.fromHash(JSON as! NSDictionary)
        dump(soul)
        
        success(soul)
        
        
      case .Failure:
        print("Echo Soul Failure!")
        if let r = response.response {
          failure(r.statusCode)
        }
      }
    }
  }
  
  static let jsonHeader = ["Content-type":"application/json", "Accept":"application/json"]
  
  class func post(localDevice: Device, success:()->(), failure: (Int)->()) {
    request(.POST,
      serverURL + "/devices/",
      parameters: localDevice.toParams(),
      encoding: .JSON,
      headers: jsonHeader)
      .validate(statusCode: validStatusCodes)
      .responseJSON {
        (response) in
      switch response.result {
      case .Success (let JSON):
        if let responseJSON = JSON as? NSDictionary {
          let deviceID = responseJSON["id"]
          if deviceID is Int {
            deviceManager.updateLocalDeviceID(deviceID as! Int)
          }
        }
        success()
        
      case .Failure:
        print("Register local device failure!")
        if let r = response.response {
          failure(r.statusCode)
        }
        
        }
    }
  }
  
  class func patch(localDevice: Device, success:()->(), failure: (Int)->()) {
    var deviceString = ""
    if let deviceInt = localDevice.id {
      deviceString = String(deviceInt)
    }
    request(.PATCH,
      serverURL + "/devices/" + deviceString,
      parameters: localDevice.toParams(),
      encoding: .JSON,
      headers: ServerFacade.jsonHeader)
      .validate(statusCode: validStatusCodes)
      .responseString { (response) in
      switch response.result {
      case .Success:
        success()
      case .Failure :
        if let r = response.response {
          failure(r.statusCode)
        }
        
      }
    }
  }
  
  class func report(soul:Soul) {
    request(.POST,
            serverURL + "/report",
            parameters: soul.toParams(),
            encoding: .JSON,
            headers: ServerFacade.jsonHeader)
    
  }
  
}
