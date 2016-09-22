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
      encoding: .JSON, headers: jsonHeader)
      .validate(statusCode:validStatusCodes)
      .responseJSON { (response) in
        switch response.result {
        case .Success(let JSON):
          print("Got Latest Soul!")
          success(JSON as! [String: AnyObject])
        case .Failure:
          failure(response.response!.statusCode)
        }
    }
  }
  
  class func post(outgoingSoul: Soul, success:()->(), failure: (Int)->()) {
    request(.POST,
      serverURL + "/souls/",
      parameters: (outgoingSoul.toParams() as! [String : AnyObject]))
      .validate(statusCode: validStatusCodes)
      .responseString { response in
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
  
  class func echo(outgoingSoul: Soul, success:(Soul)->(), failure: (Int)->()) {
    request(.POST,
      serverURL + "/echo/",
      parameters: (outgoingSoul.toParams() as! [String : AnyObject]),
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
        failure((response.response?.statusCode)!)
      }
    }
  }
  
  static let jsonHeader = ["Content-type":"application/json", "Accept":"application/json"]
  
  class func post(localDevice: Device, success:()->(), failure: (Int)->()) {
    request(.POST,
      serverURL + "/devices/",
      parameters: localDevice.toParams(),
      encoding: .JSON,
      headers: ServerFacade.jsonHeader)
      .validate(statusCode: validStatusCodes)
      .responseJSON {
        (response) in
      switch response.result {
      case .Success (let JSON):
        dump(JSON)
        
        let responseJSON = JSON as! NSDictionary
          let deviceID = responseJSON["id"]
        if deviceID is Int {
          
          deviceManager.updateLocalDeviceID(deviceID as! Int)
          
        }
        
        
        print("Register local device success!")
        success()
        
      case .Failure(let _) :
        print("Register local device failure!")
        failure((response.response?.statusCode)!)
        
        }
    }
  }
  
  class func patch(localDevice: Device, success:()->(), failure: (Int)->()) {
    let deviceID = localDevice.id!
    
    request(.PATCH,
      serverURL + "/devices/" + String(deviceID),
      parameters: localDevice.toParams(),
      encoding: .JSON,
      headers: ServerFacade.jsonHeader)
      .validate(statusCode: validStatusCodes)
      .responseString { (response) in
      switch response.result {
      case .Success (let jsonResponse):
        dump(jsonResponse)
        print("Update local device success!")
        success()
        
      case .Failure :
        print("Update local device failure!")
        failure((response.response?.statusCode)!)
      }
    }
  }
  
}