//
//  FeatureCollection.swift
//  StellarJay
//
//  Created by Stadelman, Stan on 8/15/18.
//  Copyright © 2018 sstadelman. All rights reserved.
//

import Foundation

public final class FeatureCollection<FeatureType: Decodable>: GeoJSON {
    private enum CodingKeys: String, CodingKey {
        case features
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.features = try values.decode(Array<FeatureType>.self, forKey: .features)
        try super.init(from: decoder)
    }
    
    public let features: Array<FeatureType>
}

public final class FeatureCollectionStandard: GeoJSON {
    private enum CodingKeys: String, CodingKey {
        case features
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.features = try values.decode(Array<FeatureStandard>.self, forKey: .features)
        try super.init(from: decoder)
    }
    
    public let features: Array<FeatureStandard>
}
