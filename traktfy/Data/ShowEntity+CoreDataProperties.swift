//
//  ShowEntity+CoreDataProperties.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 11/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import Foundation
import CoreData


extension ShowEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShowEntity> {
        return NSFetchRequest<ShowEntity>(entityName: "ShowEntity")
    }

    @NSManaged public var airedEpisodes: Int32
    @NSManaged public var airsDay: String?
    @NSManaged public var airsTime: String?
    @NSManaged public var airsTimezone: String?
    @NSManaged public var availableTranslations: [String]?
    @NSManaged public var certification: String?
    @NSManaged public var country: String?
    @NSManaged public var firstAired: Date?
    @NSManaged public var following: Bool
    @NSManaged public var genres: [String]?
    @NSManaged public var homepage: String?
    @NSManaged public var language: String?
    @NSManaged public var network: String?
    @NSManaged public var rating: Double
    @NSManaged public var runtime: Int32
    @NSManaged public var score: Double
    @NSManaged public var showOverview: String?
    @NSManaged public var showTitle: String?
    @NSManaged public var showYear: Int16
    @NSManaged public var status: String?
    @NSManaged public var trailer: String?
    @NSManaged public var traktID: Int32
    @NSManaged public var traktImdb: String?
    @NSManaged public var traktSlug: String?
    @NSManaged public var traktTmdb: Int32
    @NSManaged public var traktTvrage: String?
    @NSManaged public var type: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var votes: Int32

}
