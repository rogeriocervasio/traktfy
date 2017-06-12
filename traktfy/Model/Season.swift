//
//  Season.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 11/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import ObjectMapper

public class Season: NSObject, Mappable {
    
    public var watched: Bool?
    public var showID: Int?
    
    public var seasonNumber: Int?
    public var seasonID: Int?
    public var seasonTvdb: Int?
    public var seasonTmdb: Int?
    public var seasonTvrage: String?
    public var seasonRating: Double?
    public var seasonVotes: Int?
    public var episodeCount: Int?
    public var airedEpisodes: Int?
    public var seasonTitle: String?
    public var seasonOverview: String?
    public var firstAired: Date?
    
    required public override init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        
        self.seasonNumber   <- map["number"]
        self.seasonID       <- map["ids.trakt"]
        self.seasonTvdb     <- map["ids.tvdb"]
        self.seasonTmdb     <- map["ids.tmdb"]
        self.seasonTvrage   <- map["ids.tvrage"]
        self.seasonRating   <- map["rating"]
        self.seasonVotes    <- map["votes"]
        self.episodeCount   <- map["episode_count"]
        self.airedEpisodes  <- map["aired_episodes"]
        self.seasonTitle    <- map["title"]
        self.seasonOverview <- map["overview"]
        self.firstAired     <- (map["first_aired"], ISO8601DateTransform())
    }
}
/*
{
    "number": 1,
    "ids": {
        "trakt": 54971,
        "tvdb": null,
        "tmdb": 59745,
        "tvrage": null
    },
    "rating": 9.03226,
    "votes": 124,
    "episode_count": 10,
    "aired_episodes": 10,
    "title": "Bron|Broen",
    "overview": " The first season started with a police investigation following the discovery of a dead body on the Øresund Bridge connecting Sweden and Denmark. It was first broadcast on SVT1 and DR1 during the autumn of 2011.",
    "first_aired": "2011-09-28T19:00:00.000Z"
},
*/
