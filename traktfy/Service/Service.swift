//
//  Service.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 06/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import Alamofire
import ObjectMapper


public class Service: BaseService {
    
    static let shared = Service()
    
    public override init() {
        super.init()
        
        self.baseAddress = "https://api.trakt.tv"
        self.baseVersion = "2"
        self.apiClientID = "019a13b1881ae971f91295efc7fdecfa48b32c2a69fe6dd03180ff59289452b8"
        
        /*
         Content-Type:application/json
         trakt-api-version:2
         trakt-api-key:[client_id]
         */
        
        self.startReachabilityMonitoring()
    }
    
    func responseMessage(_ object:AnyObject?) -> String {
        return (object?["message"] != nil ? (object?["message"] as? String)! : "")
    }
    
    /*
    public func getRepositories(_ q: String, _ sort: String, _ page: Int, completion: ((_ finished: Bool, _ repositories: Repositories?) -> Void)? = nil) -> Request {
        
        let parameters = ["q": q, "sort": sort, "page": page] as [String : Any]
        
        return self.apiRequest(.get, address: self.baseAPI! + "search/repositories", parameters: parameters) { (_ finished, _ response) in
            
            var repositories: Repositories?
            
            if finished {
                
                repositories = Mapper<Repositories>().map(JSONObject: response)
            }
            
            completion?(finished, repositories)
        }
    }
    */
    
    public func getSearchedSeries(extendedOptions: String, query: String, page: Int, completion: ((_ finished: Bool, _ show: [Show]?, _ message: String?) -> Void)? = nil) -> Request {
        //  GET https://api.trakt.tv/search/show?extended=full&query=thebridge&page=1
        
        let parameters = ["extended": extendedOptions, "query": query, "page": page] as [String : Any]
        
        return self.apiRequest(.get, address: self.baseAPI! + "/search/show", parameters: parameters) { (_ finished, _ response) in
            
            var show: [Show]?
            
            var message: String?
            
            if finished {
                
                message = self.responseMessage(response)
                
                show = Mapper<Show>().mapArray(JSONObject: response)
            }
            
            completion?(finished, show, message)
        }
    }

}
