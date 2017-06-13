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
        
        self.startReachabilityMonitoring()
    }

    
    public func getNextEpisode(traktID: Int, extendedOptions: String, completion: ((_ finished: Bool, _ nextEpisode: Episode?) -> Void)? = nil) -> Request {
        
        let parameters = ["extended": extendedOptions] as [String : Any]
        
        return self.apiRequest(.get, address: self.baseAPI! + "/shows/\(traktID)/next_episode", parameters: parameters) { (_ finished, _ response) in
            
            var nextEpisode: Episode?
            
            if finished {
                
                nextEpisode = Mapper<Episode>().map(JSONObject: response)
            }
            
            completion?(finished, nextEpisode)
        }
    }
    
    
    public func getSeasonEpisodes(traktID: Int, seasonNumber: Int32, extendedOptions: String, completion: ((_ finished: Bool, _ episodes: [Episode]?) -> Void)? = nil) -> Request {
        
        let parameters = ["extended": extendedOptions] as [String : Any]
        
        return self.apiRequest(.get, address: self.baseAPI! + "/shows/\(traktID)/seasons/\(seasonNumber)", parameters: parameters) { (_ finished, _ response) in
            
            var episodes: [Episode]?
            
            if finished {
                
                episodes = Mapper<Episode>().mapArray(JSONObject: response)
            }
            
            completion?(finished, episodes)
        }
    }
    
    public func getShowSeasons(traktID: Int, extendedOptions: String, completion: ((_ finished: Bool, _ seasons: [Season]?) -> Void)? = nil) -> Request {
        
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
