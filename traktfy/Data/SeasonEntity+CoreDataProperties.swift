//
//  SeasonEntity+CoreDataProperties.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 11/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import Foundation
import CoreData


extension SeasonEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SeasonEntity> {
        return NSFetchRequest<SeasonEntity>(entityName: "SeasonEntity")
    }

    @NSManaged public var airedEpisodes: Int32
    @NSManaged public var episodeCount: Int32
    @NSManaged public var firstAired: Date?
    @NSManaged public var seasonNumber: Int32
    @NSManaged public var seasonRating: Double
    @NSManaged public var seasonID: Int32
    @NSManaged public var seasonOverview: String?
    @NSManaged public var seasonTmdb: Int32
    @NSManaged public var seasonTvdb: Int32
    @NSManaged public var seasonTvrage: String?
    @NSManaged public var showID: Int32
    @NSManaged public var seasonTitle: String?
    @NSManaged public var seasonVotes: Int32
    @NSManaged public var watched: Bool

}
