//
//  Feature.swift
//  StellarJay
//
//  Created by Stadelman, Stan on 8/15/18.
//  Copyright © 2018 sstadelman. All rights reserved.
//

import Foundation

public final class Feature<PropertiesType: Decodable>: GeoJSON {
    enum CodingKeys: String, CodingKey {
        case geometry, properties, id
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.properties = try values.decode(PropertiesType.self, forKey: .properties)
        try super.init(from: decoder)
        let geometry = try values.decode(Geometry.self, forKey: .geometry)
        
        print(geometry.type)
        switch geometry.type {
        case "Point":
            self.geometry = try values.decode(Point.self, forKey: .geometry)
        case "MultiPoint":
            self.geometry = try values.decode(MultiPoint.self, forKey: .geometry)
        case "LineString":
            self.geometry = try values.decode(LineString.self, forKey: .geometry)
        case "MultiLineString":
            self.geometry = try values.decode(MultiLineString.self, forKey: .geometry)
        case "Polygon":
            self.geometry = try values.decode(Polygon.self, forKey: .geometry)
        case "MultiPolygon":
            self.geometry = try values.decode(MultiPolygon.self, forKey: .geometry)
            /// TODO:  Support GeometryCollection
            //        case "GeometryCollection":
        //            self.geometry = try values.decode(GeometryCollection.self, forKey: .geometry)
        default:
            self.geometry = nil
            break
        }
        
        guard values.contains(.id) else {
            self.id = nil
            return
        }
        self.id = try values.decode(String.self, forKey: .id)
    }
    
    public private(set) var properties: PropertiesType
    public private(set) var geometry: Geometry? = nil
    public private(set) var id: String? = nil
}

public final class FeatureStandard: GeoJSON {
    enum CodingKeys: String, CodingKey {
        case geometry, properties, id
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.properties = try values.decode(Dictionary<String, Any>.self, forKey: .properties)
        try super.init(from: decoder)
        let geometry = try values.decode(Geometry.self, forKey: .geometry)
        
        print(geometry.type)
        switch geometry.type {
        case "Point":
            self.geometry = try values.decode(Point.self, forKey: .geometry)
        case "MultiPoint":
            self.geometry = try values.decode(MultiPoint.self, forKey: .geometry)
        case "LineString":
            self.geometry = try values.decode(LineString.self, forKey: .geometry)
        case "MultiLineString":
            self.geometry = try values.decode(MultiLineString.self, forKey: .geometry)
        case "Polygon":
            self.geometry = try values.decode(Polygon.self, forKey: .geometry)
        case "MultiPolygon":
            self.geometry = try values.decode(MultiPolygon.self, forKey: .geometry)
            //        case "GeometryCollection":
        //            self.geometry = try values.decode(GeometryCollection.self, forKey: .geometry)
        default:
            self.geometry = nil
            break
        }
        
        guard values.contains(.id) else {
            self.id = nil
            return
        }
        self.id = try values.decode(String.self, forKey: .id)
    }
    
    public private(set) var properties: Dictionary<String, Any>
    public private(set) var geometry: Geometry? = nil
    public private(set) var id: String? = nil
}
