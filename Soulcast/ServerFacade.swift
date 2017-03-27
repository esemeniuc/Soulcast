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
  
  class func block(_ soul:Soul, success:@escaping ()->(), failure:@escaping (Int)->()) {
    //TODO: check interface with cwaffles
    assert(soul.token != nil, "This soul does not have a token! A Ronen Token")
    let localToken = Device.token ?? ""
    post("blocks", parameters:[
      "blockee_token": soul.token! as AnyObject,
      "blocker_token": localToken as AnyObject ])
      .responseJSON { response in
        switch response.result {
        case .success(let JSON):
          print("block success!! \(JSON)")
          success()
        case .failure(let error):
          print("Failed to get block! error: \(error)")
          if let failResponse = response.response {
            failure(failResponse.statusCode)
          } else {
//            failure(error)
          }
        }
    }
  }
  
  class func getHistory(_ success:@escaping ([Soul])->(), failure:@escaping (Int)->()) {
    var deviceID = Device.id ?? -1
    if deviceID == -1 { deviceID = 1 } //TODO: simulator special case? disallow nils...
    get("device_history/" + String(deviceID)).responseJSON { (response) in
      switch response.result {
      case .success(let JSON):
        print("Got history!\(JSON)")
        success(Soul.fromArray(JSON as! [[String:AnyObject]]))
      case .failure(let error):
        print("Failed to get history! error: \(error)")
        if let failResponse = response.response {
          failure(failResponse.statusCode)
        } else {
//          failure(error.code)
        }
      }
    }
  }
  
  class func getLatest(_ success:@escaping ([String : AnyObject])->(), failure:@escaping (Int)->()){
    //TODO: test.
    get("souls", parameters: Device.toParams())
      .responseJSON { (response) in
        switch response.result {
        case .success(let JSON):
          print("Got Latest Soul!")
          success(JSON as! [String: AnyObject])
        case .failure:
          if let r = response.response {
            failure(r.statusCode)
          }
          
        }
    }
  }
  
  class func post(_ outgoingSoul: Soul, success:@escaping ()->(), failure: @escaping (Int)->()) {
    post("souls", parameters: outgoingSoul.toParams())
      .responseString { response in
        switch response.result{
        case .success:
          print("Outgoing Soul Post success!")
          success()
        case .failure:
          print("Outgoing Soul Post failure!")
          if let r = response.response {
            failure(r.statusCode)
          }
        }
    }
  }
  
  class func post(_ wave: Wave, _ success:@escaping ()->() = {_ in}, failure: @escaping (Int)->()) {
    post("waves", parameters: wave.toParams() as [String : AnyObject]?)
    .responseString { response in
      switch response.result {
      case .success:
        print ("Post Wave success!")
        success()
      case .failure:
        print("Post wave fail!")
        failure(response.response!.statusCode)
      }
    }
  }

  class func improve(_ feedbackSoul: Soul, success:@escaping ()->(), failure: @escaping (Int)->()) {
    post("improves.json", parameters: feedbackSoul.toParams())
      .responseString { response in
        switch response.result{
        case .success:
          print("Outgoing Soul Post success!")
          success()
        case .failure:
          print("Outgoing Soul Post failure!")
          if let r = response.response {
            failure(r.statusCode)
          }
        }
    }
  }
  
  class func echo(_ outgoingSoul: Soul, success:@escaping (Soul)->(), failure: @escaping (Int)->()) {
    post("echo", parameters: outgoingSoul.toParams())
      .responseJSON { response in
      switch response.result{
      case .success(let JSON):
        print("Echo Soul success!")
        let soul = Soul.fromHash(JSON as! NSDictionary)
        dump(soul)
        success(soul)
      case .failure:
        print("Echo Soul failure!")
        if let r = response.response {
          failure(r.statusCode)
        }
      }
    }
  }
  
  static let jsonHeader = ["Content-type":"application/json", "Accept":"application/json"]
  
  class func postDevice( success:@escaping ()->(), failure: @escaping (Int)->()) {
    post("devices", parameters: Device.toParams())
      .responseJSON {
        (response) in
      switch response.result {
      case .success (let JSON):
        if let responseJSON = JSON as? NSDictionary {
          let deviceID = responseJSON["id"]
          if deviceID is Int {
            Device.id = deviceID as! Int
          }
        }
        success()
        
      case .failure:
        print("Register local device failure!")
        if let r = response.response {
          failure(r.statusCode)
        }
        
        }
    }
  }
  
  class func patchDevice(success:@escaping ()->(), failure: @escaping (Int)->()) {
    guard let deviceInt = Device.id
      else { return }
    
    let deviceString = String(deviceInt)
    patch("devices/" + deviceString + ".json", parameters: Device.toParams())
      .responseJSON { (response) in
      switch response.result {
      case .success:
        success()
      case .failure :
        if let r = response.response {
          failure(r.statusCode)
        }
      }
    }
  }
  
  
  class func getNearbyDevices(_ completion:@escaping (Int)->(), failure:@escaping ()->()) {
    request(serverURL + "nearby/",
            method: .get,
            parameters: Device.toParams(),
            headers: ServerFacade.jsonHeader).validate()
      .responseJSON { (response) in
      switch response.result {
      case .success(let JSON):
        if let responseJSON = JSON as? NSDictionary {
          completion(responseJSON["nearby"] as! Int)
        }
        
      case .failure:
        print("getNearbyDevices fail")
        failure()
      }
    }
    
  }
  
  class func report(_ soul:Soul) {
    request(serverURL + "report",
            method: .post,
            parameters: soul.toParams(),
            encoding: JSONEncoding.default,
            headers: ServerFacade.jsonHeader)
    
  }
  
  fileprivate class func get( _ route: String, parameters: [String: AnyObject]? = nil)
    -> DataRequest {
      return request(serverURL + route,
                     method: .get,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers: ServerFacade.jsonHeader).validate()
  }
  
  fileprivate class func post( _ route: String, parameters: [String: AnyObject]? = nil)
    -> DataRequest {
      return request(serverURL + route,
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers: ServerFacade.jsonHeader).validate()
  }
  
  fileprivate class func patch( _ route: String, parameters: [String: AnyObject]? = nil)
    -> DataRequest {
      return request(serverURL + route,
                     method: .patch,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers: ServerFacade.jsonHeader).validate()
  }
}


class MockServerFacade: ServerFacade {
  class override func getHistory(_ success:@escaping ([Soul])->(), failure:@escaping (Int)->()) {
    success([
      MockFactory.mockSoulOne(),
      MockFactory.mockSoulTwo(),
      MockFactory.mockSoulThree(),
      MockFactory.mockSoulFour(),
      MockFactory.mockSoulFive(), ])
  }
  class override func block(_ soul:Soul, success:@escaping ()->(), failure:@escaping (Int)->()) {
    success()
  }
  class func post(_ wave: Wave,_ success:@escaping ()->() = {_ in}) {
    success()
  }
}
