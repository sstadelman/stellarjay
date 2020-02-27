//
//  MultiPolygon.swift
//  StellarJay
//
//  Created by Stadelman, Stan on 8/15/18.
//  Copyright © 2018 sstadelman. All rights reserved.
//

import Foundation
import MapKit

public final class MultiPolygon: Geometry, PositionContaining {
    
    public typealias Coordinates = [[[CLLocationCoordinate2D]]]
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let nestedValues = try values.decode(Array<Array<Array<Array<Double>>>>.self, forKey: .coordinates)
        self.coordinates = nestedValues.map({ multiPolygon in
            multiPolygon.map({ polygon in
                polygon.map({ doubleArray in
                    guard doubleArray.count == 2 else {
                        preconditionFailure()
                    }
                    return CLLocationCoordinate2D(latitude: doubleArray[1], longitude: doubleArray[0] )}
                )}
            )})
        try super.init(from: decoder)
    }
    
    public let coordinates: Coordinates
}

extension CLLocationCoordinate2D: Decodable {
    
    enum CodingKeys: CodingKey {
        case latitude, longitude
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try values.decode(Double.self, forKey: .latitude)
        let longitude = try values.decode(Double.self, forKey: .longitude)
        
        self.init()
        self.latitude = CLLocationDegrees(latitude)
        self.longitude = CLLocationDegrees(longitude)
    }
}
