//
//  BaseModel.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 10/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import ObjectMapper

public class BaseModel: Mappable {
    
    public var message: String?
    
    required public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        self.message <- map["mensagem"]
    }
}
