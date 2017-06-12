//
//  ShowObjectMapperTests.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 12/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import XCTest
import Foundation
import ObjectMapper
@testable import traktfy

class ShowObjectMapperTests: XCTestCase {
    
    var shows: [Show] = []
    
    override func setUp() {
        super.setUp()
        
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [Any]
        
        shows = Mapper<Show>().mapArray(JSONObject: json)!
    }
    
    func testShowMappingHasExpectedItemsCount() {
        
        XCTAssert(shows.count == 10,
                  "Collection didn't have expected number of items")
        
    }
    
    func testFirstShowHasExpectedValues(index: Int) {
        
        let show = shows[0]
        
        XCTAssertEqual(show.type, "show")
        XCTAssertEqual(show.score, 168.69261)
        XCTAssertEqual(show.showTitle, "The Bridge")
        XCTAssertEqual(show.showYear, 2011)
        XCTAssertEqual(show.traktID, 44768)
        XCTAssertEqual(show.traktSlug, "the-bridge")
        XCTAssertEqual(show.traktImdb, "tt1733785")
        XCTAssertEqual(show.traktTmdb, 45016)
        XCTAssertEqual(show.traktTvrage, nil)
        XCTAssertEqual(show.showOverview, "A body is found on the bridge from Malmö to Copenhagen causing a jurisdiction issue. Forced to work together, a Swedish and a Danish police detective are on the hunt for a killer.")
        XCTAssertEqual(show.firstAired, ISO8601DateFormatter.date(from: "2011-09-20T21:00:00.000Z"))
        
    }
    
    private lazy var data:Data = {
        let path = Bundle(for: type(of: self)).url(forResource: "show", withExtension: "json")!
        let data = try! Data(contentsOf: path)
        return data
    }()
    
    private let ISO8601DateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        let enUSPOSIXLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPOSIXLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
}
