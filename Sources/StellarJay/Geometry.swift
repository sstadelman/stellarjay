//
//  Geometry.swift
//  StellarJay
//
//  Created by Stadelman, Stan on 8/15/18.
//  Copyright © 2018 sstadelman. All rights reserved.
//

import Foundation

public class Geometry: GeoJSON {
    
    enum CodingKeys: String, CodingKey {
        case coordinates
    }
    
    public required init(from decoder: Decoder) throws  {
        try super.init(from: decoder)
    }
}
