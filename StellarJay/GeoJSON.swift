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
        case bbox
    }
    
    public required init(from decoder: Decoder) throws  {
        let values = try decoder.container(keyedBy: GeoJSONKeys.self)
        self.type = try values.decode(String.self, forKey: .type)
        self._bbox = try values.decodeIfPresent(Array<Double>.self, forKey: .bbox)
    }
    public let type: String
    
    private var _bbox: [Double]?
    
    private var bbox: [Double] {
        get {
            guard let _bbox = _bbox else {
                // compute bbox
                return []
            }
            return _bbox
        }
    }
}
