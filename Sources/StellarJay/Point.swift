//
//  Point.swift
//  StellarJay
//
//  Created by Stadelman, Stan on 8/15/18.
//  Copyright © 2018 sstadelman. All rights reserved.
//

import Foundation
import MapKit

final public class Point: Geometry, PositionContaining {
    
    typealias Coordinates = CLLocationCoordinate2D
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let coords = try values.decode(Array<Double>.self, forKey: .coordinates)
        switch coords.count {
        case 2...:
            self.coordinates = CLLocationCoordinate2D(latitude: coords[1], longitude: coords[0])
        default:
            throw DecodingError.typeMismatch(Array<Double>.self, DecodingError.Context(codingPath: [CodingKeys.coordinates], debugDescription: "Coordinates dimension count < 2"))
        }
        try super.init(from: decoder)
    }
    
    public let coordinates: CLLocationCoordinate2D
}
