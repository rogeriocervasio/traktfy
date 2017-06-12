//
//  EpisodeEntity+CoreDataProperties.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 11/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import Foundation
import CoreData


extension EpisodeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EpisodeEntity> {
        return NSFetchRequest<EpisodeEntity>(entityName: "EpisodeEntity")
    }

    @NSManaged public var episodeID: Int32
    @NSManaged public var episodeImdb: String?
    @NSManaged public var episodeOverview: String?
    @NSManaged public var episodeTmdb: Int32
    @NSManaged public var episodeTvdb: Int32
    @NSManaged public var episodeTvrage: String?
    @NSManaged public var firstAired: Date?
    @NSManaged public var number: Int32
    @NSManaged public var numberAbs: Int32
    @NSManaged public var rating: Double
    @NSManaged public var season: Int32
    @NSManaged public var seasonID: Int32
    @NSManaged public var showID: Int32
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var votes: Int32
    @NSManaged public var watched: Bool
    @NSManaged public var availableTranslations: [String]?

}
