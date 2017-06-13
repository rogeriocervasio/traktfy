//
//  Episode.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 11/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import ObjectMapper

public class Episode: NSObject, Mappable {
    
    public var watched: Bool?
    public var showID: Int?
    public var seasonID: Int?
    public var showTitle: String?
    
    public var season: Int?
    public var number: Int?
    public var title: String?
    public var episodeID: Int?
    public var episodeTvdb: Int?
    public var episodeImdb: String?
    public var episodeTmdb: Int?
    public var episodeTvrage: String?
    public var numberAbs: Int?
    public var episodeOverview: String?
    public var rating: Double?
    public var votes: Int?
    public var firstAired: Date?
    public var updatedAt: Date?
    public var availableTranslations: [String]?
    
    required public override init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        
        self.season         <- map["season"]
        self.number         <- map["number"]
        self.title          <- map["title"]
        self.episodeID      <- map["ids.trakt"]
        self.episodeTvdb    <- map["ids.tvdb"]
        self.episodeImdb    <- map["ids.imdb"]
        self.episodeTmdb    <- map["ids.tmdb"]
        self.episodeTvrage  <- map["ids.tvrage"]
        self.numberAbs      <- map["number_abs"]
        self.episodeOverview <- map["overview"]
        self.rating         <- map["rating"]
        self.votes          <- map["votes"]
        self.firstAired     <- (map["first_aired"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"))
        self.updatedAt      <- (map["updated_at"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"))
        self.availableTranslations <- map["available_translations"]
    }
}

/*
{
    "season": 1,
    "number": 1,
    "title": "Episode 1",
    "ids": {
        "trakt": 903798,
        "tvdb": 4173941,
        "imdb": "tt1829101",
        "tmdb": 971783,
        "tvrage": 0
    },
    "number_abs": 1,
    "overview": "A woman is found murdered in the middle of the Öresund bridge - just on the border between Sweden and Denmark. Saga Noren from the County Crimea Malmo and Martin Rohde from Copenhagen police are called to the scene. What at first appears to be a murder turns out to be two. The upper body is from a well-known Swedish politician and the lower body from a Danish prostitute.",
    "rating": 7.93647,
    "votes": 425,
    "first_aired": "2011-09-28T19:00:00.000Z",
    "updated_at": "2017-06-08T17:36:52.000Z",
    "available_translations": [
    "bs",
    "cs",
    "da",
    "de",
    "en",
    "es",
    "fr",
    "hu",
    "nl",
    "pl",
    "ru",
    "sv",
    "uk",
    "zh"
    ],
    "runtime": 57
},
*/
