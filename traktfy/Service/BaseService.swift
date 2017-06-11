//
//  BaseService.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 06/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import Alamofire
import AlamofireNetworkActivityIndicator

public class BaseService: NSObject {
    
    public var baseAddress: String?
    public var baseVersion: String?
    public var apiClientID: String?
    
    public private(set) var baseAPI: String?
    private var reachabilityManager: NetworkReachabilityManager?
    
    public var reachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus? {
        get {
            return self.reachabilityManager?.networkReachabilityStatus
        }
    }
    
    
    public func startReachabilityMonitoring() {
        
        self.baseAPI = self.baseAddress!
        self.reachabilityManager = NetworkReachabilityManager(host: self.baseAddress!)
        
        guard let reachabilityManager = self.reachabilityManager else {
            return
        }
        
        reachabilityManager.listener = { status in
            print("reachabilityManager status: \(status)")
        }
        
        reachabilityManager.startListening()
    }
    
    internal func apiRequest(_ method: Alamofire.HTTPMethod, address: String, parameters: [String: Any]? = nil, completion: ((_ finished: Bool, _ response: AnyObject?) -> Void)? = nil) -> Request {
        
        
        var headers: [String: String]?
        
        headers = [
        "Content-Type" : "application/json",
        "trakt-api-version" : baseVersion!,
        "trakt-api-key" : apiClientID!
        ]
        
        return Alamofire.request(address, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            if let JSON = response.result.value {
                completion?(true, JSON as AnyObject?)
            } else {
                completion?(false, nil)
            }
            
        }
    }
    
}
