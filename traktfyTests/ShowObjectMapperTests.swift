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
    
    private lazy var data:Data = {
        let path = Bundle(for: type(of: self)).url(forResource: "show", withExtension: "json")!
        let data = try! Data(contentsOf: path)
        return data
    }()
}
