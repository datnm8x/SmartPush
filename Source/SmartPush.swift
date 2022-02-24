//
//  SmartPush++.swift
//  DemoVoIP
//
//  Created by Dat Ng on 16/02/2022.
//  Copyright © 2022 Nguyen Mau Dat. All rights reserved.
//

import Foundation

public enum PushType: String {
  case alert = "alert"
  case background = "background"
  case voIP = "voip"
  case complication = "complication"
  case fileProvider = "fileprovider"
  case mdm = "mdm"
}

public typealias Payload = (aps: [String: Any], acme: [String: Any]?)

public enum SmartPush {
  public enum Result {
    case success
    case failed(String)
  }
  
  public static func connectCertificate(path: String, password: String = "") {
    APNSClient.shared().connectCertificate(path, pass: password)
  }
  
  public static func sendPush(payload: [String: Any],
                              toToken: String,
                              topic: String? = nil,
                              priority: UInt = 10,
                              collapseID: String = "",
                              pushType: PushType = .alert,
                              sandbox: Bool = true,
                              completion: @escaping((Result) -> Void)) {
    var apsPayload = payload
    if !apsPayload.keys.contains("aps") {
      apsPayload = ["aps": apsPayload]
    }
    
    guard let payloadJSONData = try?  JSONSerialization.data(withJSONObject: apsPayload, options: .init(rawValue: 0)),
          let payloadJSONString = String(data: payloadJSONData, encoding: .utf8) else {
            completion(.failed("Payload json error!"))
            return
          }
    
    APNSClient.sendPush(payloadJSONString, toToken: toToken, topic: topic, priority: priority, collapseID: collapseID, pushType: pushType.rawValue, inSandbox: sandbox) { success in
      success ? completion(.success) : completion(.failed("Unkown"))
    } exeFailed: { reason in
      completion(.failed(reason))
    }
  }
  
  public struct Payload {
    public var alert: Any?
    public var badge: Int = 0
    public var sound: String = "default"
    public var contentAvailable: Int?
    public var others: [String: Any]?
    public var acmes: [String: Any]?
    public var targetToken: String
    
    public init(alert: Any? = nil, badge: Int = 0, sound: String = "default", contentAvailable: Int? = nil, others: [String : Any]? = nil, acmes: [String : Any]? = nil, targetToken: String) {
      self.alert = alert
      self.badge = badge
      self.sound = sound
      self.contentAvailable = contentAvailable
      self.others = others
      self.acmes = acmes
      self.targetToken = targetToken
    }
    
    var jsonString: String? {
      var payload: [String: Any] = ["badge": badge, "sound": sound]
      if let alert = alert { payload["alert"] = alert }
      if let contentAvailable = contentAvailable { payload["content-available"] = contentAvailable }
      others?.forEach({ (key: String, value: Any) in
        payload[key] = value
      })
      payload["aps"] = payload
      
      acmes?.forEach({ (key: String, value: Any) in
        payload[key] = value
      })
      
      guard let payloadJSONData = try?  JSONSerialization.data(withJSONObject: payload, options: .init(rawValue: 0)) else { return nil }
      
      return String(data: payloadJSONData, encoding: .utf8)
    }
  }
  
  public struct Options {
    public var topic: String?
    public var priority: UInt = 10
    public var collapseID: String = ""
    public var pushType: PushType = .alert
    public var sandbox: Bool = true
    
    public init(topic: String? = nil, priority: UInt = 10, collapseID: String = "", pushType: PushType = .alert, sandbox: Bool = true) {
      self.topic = topic
      self.priority = priority
      self.collapseID = collapseID
      self.pushType = pushType
      self.sandbox = sandbox
    }
    
    public static let `default` = Options()
  }
  
  public static func sendPush(payload: Payload, options: Options = .default, completion: @escaping((Result) -> Void)) {
    guard let jsonString = payload.jsonString else {
      completion(.failed("Payload json error!"))
      return
    }
    
    APNSClient.sendPush(
      jsonString,
      toToken: payload.targetToken,
      topic: options.topic,
      priority: options.priority,
      collapseID: options.collapseID,
      pushType: options.pushType.rawValue,
      inSandbox: options.sandbox) { success in
        success ? completion(.success) : completion(.failed("Unkown"))
      } exeFailed: { reason in
        completion(.failed(reason))
      }
  }
}
