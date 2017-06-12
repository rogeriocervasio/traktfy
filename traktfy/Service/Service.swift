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

    
    // GET https://api.trakt.tv/shows/44768/seasons/1?extended=full
    
    
    public func getShowSeasons(traktID: Int, extendedOptions: String, completion: ((_ finished: Bool, _ seasons: [Season]?) -> Void)? = nil) -> Request {
        // GET https://api.trakt.tv/shows/id/seasons
        // GET https://api.trakt.tv/shows/44768/seasons?extended=full&page=1
        
        let parameters = ["extended": extendedOptions] as [String : Any]
        
        return self.apiRequest(.get, address: self.baseAPI! + "/shows/\(traktID)/seasons", parameters: parameters) { (_ finished, _ response) in
            
            var seasons: [Season]?
            
            if finished {
                
                seasons = Mapper<Season>().mapArray(JSONObject: response)
            }
            
            completion?(finished, seasons)
        }
    }
 
    
    public func getSearchedSeries(extendedOptions: String, query: String, page: Int, completion: ((_ finished: Bool, _ show: [Show]?) -> Void)? = nil) -> Request {
        //  GET https://api.trakt.tv/search/show?extended=full&query=thebridge&page=1
        
        let parameters = ["extended": extendedOptions, "query": query, "page": page] as [String : Any]
        
        return self.apiRequest(.get, address: self.baseAPI! + "/search/show", parameters: parameters) { (_ finished, _ response) in
            
            var show: [Show]?
            
            if finished {
                
                show = Mapper<Show>().mapArray(JSONObject: response)
            }
            
            completion?(finished, show)
        }
    }

}
