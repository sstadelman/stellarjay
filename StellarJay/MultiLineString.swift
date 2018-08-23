//
//  MultiLineString.swift
//  StellarJay
//
//  Created by Stadelman, Stan on 8/15/18.
//  Copyright © 2018 sstadelman. All rights reserved.
//

import Foundation
import MapKit

final public class MultiLineString: Geometry, PositionContaining {
    
    typealias Coordinates = [[CLLocationCoordinate2D]]
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let coords = try values.decode(Array<Array<Array<Double>>>.self, forKey: .coordinates)
        self.coordinates = try coords.map {
            guard $0.count > 1 else {
                throw DecodingError.typeMismatch(Array<Array<Array<Double>>>.self, DecodingError.Context(codingPath: [CodingKeys.coordinates], debugDescription: "Coordinates count in LineString < 2"))
            }
            return try $0.map {
                guard $0.count > 1 else {
                    throw DecodingError.typeMismatch(Array<Array<Double>>.self, DecodingError.Context(codingPath: [CodingKeys.coordinates], debugDescription: "Coordinates dimension count < 2"))
                }
                return CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])
            }
        }
        try super.init(from: decoder)
    }
    
    public let coordinates: [[CLLocationCoordinate2D]]
}

public extension MultiLineString {
    func toMKPolylines() -> [MKPolyline] {
        return coordinates.map {
            MKPolyline(coordinates: $0, count: $0.count)
        }
    }
}
