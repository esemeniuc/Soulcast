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
  
  class func block(soul:Soul, success:()->(), failure:(Int)->()) {
    //TODO: check interface with cwaffles
    assert(soul.token != nil, "This soul does not have a token! A Ronen Token")
    let localToken = Device.localDevice.token ?? "RONENTOKEN"
    post("blocks", parameters:[
      "block": soul.token!,
      "token": localToken,
      "blockedToken": soul.token! ])
      .responseJSON { response in
        switch response.result {
        case .Success(let JSON):
          print("block success!! \(JSON)")
          success()
        case .Failure(let error):
          print("Failed to get block! error: \(error)")
          if let failResponse = response.response {
            failure(failResponse.statusCode)
          } else {
            failure(error.code)
          }
        }
    }
  }
  
  class func getHistory(success:([Soul])->(), failure:(Int)->()) {
    let deviceID = Device.localDevice.id ?? 0
    get("history/" + String(deviceID)).responseJSON { (response) in
      switch response.result {
      case .Success(let JSON):
        print("Got history!\(JSON)")
        success([MockFactory.mockSoulOne()])
      case .Failure(let error):
        print("Failed to get history! error: \(error)")
        if let failResponse = response.response {
          failure(failResponse.statusCode)
        } else {
          failure(error.code)
        }
      }
    }
  }
  
  class func getLatest(success:([String : AnyObject])->(), failure:(Int)->()){
    //TODO: test.
    get("souls", parameters: Device.localDevice.toParams())
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
    post("souls", parameters: outgoingSoul.toParams())
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
    post("improves", parameters: feedbackSoul.toParams())
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
    post("echo", parameters: outgoingSoul.toParams())
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
    post("devices", parameters: localDevice.toParams())
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
    patch("devices" + deviceString, parameters: localDevice.toParams())
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
            serverURL + "report",
            parameters: soul.toParams(),
            encoding: .JSON,
            headers: ServerFacade.jsonHeader)
    
  }
  
  private class func get( route: String, parameters: [String: AnyObject]? = nil)
    -> Request {
      return request(.GET,
                     serverURL + route,
                     parameters: parameters,
                     encoding: .JSON,
                     headers: ServerFacade.jsonHeader).validate()
  }
  
  private class func post( route: String, parameters: [String: AnyObject]? = nil)
    -> Request {
      return request(.POST,
                     serverURL + route,
                     parameters: parameters,
                     encoding: .JSON,
                     headers: ServerFacade.jsonHeader).validate()
  }
  
  private class func patch( route: String, parameters: [String: AnyObject]? = nil)
    -> Request {
      return request(.PATCH,
                     serverURL + route,
                     parameters: parameters,
                     encoding: .JSON,
                     headers: ServerFacade.jsonHeader).validate()
  }
}


class MockServerFacade: ServerFacade {
  class override func getHistory(success:([Soul])->(), failure:(Int)->()) {
    success([
      MockFactory.mockSoulOne(),
      MockFactory.mockSoulTwo(),
      MockFactory.mockSoulThree(),
      MockFactory.mockSoulFour(),
      MockFactory.mockSoulFive(), ])
  }
  class override func block(soul:Soul, success:()->(), failure:(Int)->()) {
    success()
  }
}
