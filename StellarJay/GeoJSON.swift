//
//  GeoJSON.swift
//  StellarJay
//
//  Created by Stadelman, Stan on 8/15/18.
//  Copyright © 2018 sstadelman. All rights reserved.
//

import Foundation

open class GeoJSON: Decodable {
    enum GeoJSONKeys: String, CodingKey {
        case type
        //        case boundingBox = "bbox"
    }
    
    public required init(from decoder: Decoder) throws  {
        let values = try decoder.container(keyedBy: GeoJSONKeys.self)
        self.type = try values.decode(String.self, forKey: .type)
    }
    public let type: String
}
