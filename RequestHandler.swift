//
//  RequestHandler.swift
//
//  Created by Hadevs on 17/09/2019.
//

import Foundation
import Alamofire
import SwiftyJSON

struct RequestHandler {
  private let method: HTTPMethod
  private var path: String
  private var parameters: Parameters?
  private var jsonKeys: [String] = ["data"]
  private var baseUrl = Constants.baseUrl
  private var encoding: ParameterEncoding = JSONEncoding.default
  private var isNeedToHandleError = true
  private var manualHandleErrorClosure: ItemClosure<String?>?
  init(path: String, method: HTTPMethod = .get, parameters: Parameters? = nil) {
    self.method = method
    self.path = path
    self.parameters = parameters
  }
  
  func clearJsonKeys() -> RequestHandler {
    var new = self
    new.jsonKeys = []
    return new
  }
  
  func enableErorrHandling() -> RequestHandler {
    var new = self
    new.isNeedToHandleError = true
    return new
  }
  
  func disableErorrHandling() -> RequestHandler {
    var new = self
    new.isNeedToHandleError = false
    return new
  }
  
  func manualHandleError(_ closure: @escaping ItemClosure<String?>) -> RequestHandler {
    var new = self
    new.manualHandleErrorClosure = closure
    return new
  }
  
  func new(encoding: ParameterEncoding) -> RequestHandler {
    var new = self
    new.encoding = encoding
    return new
  }
  
  func jsonKey(_ value: String) -> RequestHandler {
    var new = self
    new.jsonKeys.append(value)
    return new
  }
  
  func newBaseURL(_ value: String) -> RequestHandler {
    var new = self
    new.baseUrl = value
    return new
  }
  
  @discardableResult
  func response<T: Codable>(_ closure: @escaping ItemClosure<T?>) -> RequestHandler {
    responseJSON { (json) in
      var finalJSON = json
      for key in self.jsonKeys {
        finalJSON = finalJSON[key]
      }
      
      let model = T.from(finalJSON)
      closure(model)
    }
    return self
  }
  
  @discardableResult
  func responseJSON(_ closure: @escaping ItemClosure<JSON>) -> RequestHandler {
    responseDataResponse { (response) in
      if let data = response.data, let json = try? JSON(data: data) {
        closure(json)
      } else {
        closure(JSON())
      }
    }
    return self
  }
  
  @discardableResult
  func responseDataResponse(_ closure: @escaping ItemClosure<DataResponse<Data>>) -> RequestHandler {
    let url = baseUrl + path
    
    let req = Alamofire.request(url,
                                method: method,
                                parameters: parameters,
                                encoding: encoding,
                                headers: AuthManager.shared.headers)
    
    req.responseData { (response) in
      closure(response)
    }
    return self
  }
}
