//
//  Show.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 06/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import ObjectMapper

public class Show: NSObject, Mappable {
    
    public var following: Bool?
    public var type: String?
    public var score: NSNumber?
    public var showTitle: String?
    public var showYear: Int?
    public var traktID: Int?
    public var traktSlug: String?
    public var traktImdb: String?
    public var traktTmdb: Int?
    public var traktTvrage: String?
    public var showOverview: String?
    public var firstAired: Date?
    public var airsDay: String?
    public var airsTime: String?
    public var airsTimezone: String?
    public var runtime: Int?
    public var certification: String?
    public var network: String?
    public var country: String?
    public var trailer: String?
    public var homepage: String?
    public var status: String?
    public var rating: Double?
    public var votes: Int?
    public var updatedAt: Date?
    public var language: String?
    public var availableTranslations: [String]?
    public var genres: [String]?
    public var airedEpisodes: Int?
    
    
    required public override init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        
        self.type           <- map["type"]
        self.score          <- map["score"]
        self.showTitle      <- map["show.title"]
        self.showYear       <- map["show.year"]
        self.traktID        <- map["show.ids.trakt"]
        self.traktSlug      <- map["show.ids.slug"]
        self.traktImdb      <- map["show.ids.imdb"]
        self.traktTmdb      <- map["show.ids.tmdb"]
        self.traktTvrage    <- map["show.ids.tvrage"]
        self.showOverview   <- map["show.overview"]
        self.firstAired     <- (map["show.first_aired"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"))
        self.airsDay        <- map["show.airs.day"]
        self.airsTime       <- map["show.airs.time"]
        self.airsTimezone   <- map["show.airs.timezone"]
        self.runtime        <- map["show.runtime"]
        self.certification  <- map["show.certification"]
        self.network        <- map["show.network"]
        self.country        <- map["show.country"]
        self.trailer        <- map["show.trailer"]
        self.homepage       <- map["show.homepage"]
        self.status         <- map["show.status"]
        self.rating         <- map["show.rating"]
        self.votes          <- map["show.votes"]
        self.updatedAt      <- (map["show.updated_at"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"))
        self.language       <- map["show.language"]
        self.availableTranslations <- map["show.available_translations"]
        self.genres         <- map["show.genres"]
        self.airedEpisodes  <- map["show.aired_episodes"]
    }
}
/*
{
    "type": "show",
    "score": 169.1802,
    "show": {
        "title": "The Bridge",
        "year": 2011,
        "ids": {
            "trakt": 44768,
            "slug": "the-bridge",
            "tvdb": 252019,
            "imdb": "tt1733785",
            "tmdb": 45016,
            "tvrage": null
        },
        "overview": "A body is found on the bridge from Malmö to Copenhagen causing a jurisdiction issue. Forced to work together, a Swedish and a Danish police detective are on the hunt for a killer.",
        "first_aired": "2011-09-20T21:00:00.000Z",
        "airs": {
            "day": "Sunday",
            "time": "21:00",
            "timezone": "Europe/Copenhagen"
        },
        "runtime": 60,
        "certification": "TV-MA",
        "network": "SVT",
        "country": "dk",
        "trailer": "http://youtube.com/watch?v=256_XTAEWqY",
        "homepage": "http://www.svt.se/bron/",
        "status": "returning series",
        "rating": 8.74226,
        "votes": 1389,
        "updated_at": "2017-05-16T10:38:09.000Z",
        "language": "sv",
        "available_translations": [
        "bs",
        "cs",
        "da",
        "de",
        "en",
        "es",
        "fi",
        "fr",
        "hu",
        "nl",
        "pl",
        "pt",
        "ru",
        "sv",
        "uk",
        "zh"
        ],
        "genres": [
        "drama",
        "crime"
        ],
        "aired_episodes": 30
    }
},
*/
