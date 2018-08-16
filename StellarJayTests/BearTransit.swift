//
//  BearTransitRoute.swift
//  StellarJayTests
//
//  Created by Stadelman, Stan on 8/15/18.
//  Copyright © 2018 sstadelman. All rights reserved.
//

import Foundation
import UIKit

final class BearTransitRoute: Decodable {
    
    enum Accessiblity: RawRepresentable {
        typealias RawValue = String
        
        case some, all, none, unknown
        
        init?(rawValue: String) {
            switch rawValue {
            case "some_trips":
                self = .some
            case "all_trips":
                self = .all
            case "no_trips":
                self = .none
            default:
                self = .unknown
            }
        }
        
        var rawValue: String {
            switch self {
            case .some:
                return "some_trips"
            case .all:
                return "all_trips"
            case .none:
                return "no_trips"
            case .unknown:
                return "unknown"
            }
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case onestopId = "onestop_id"
        case name
        case vehicleType = "vehicle_type"
        case color
        case wheelchairAccessible = "wheelchair_accessible"
        case bikesAllowed = "bikes_allowed"
        case stops = "stops_served_by_route"
        case `operator` = "operated_by_name"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.onestopId = try values.decode(String.self, forKey: .onestopId)
        self.name = try values.decode(String.self, forKey: .name)
        self.vehicleType = try values.decode(String.self, forKey: .vehicleType)
        if let hex = try values.decodeIfPresent(String.self, forKey: .color) {
            self.color = UIColor(hexString: hex)
        } else {
            self.color = nil
        }
        self.wheelchairAccessible = try Accessiblity(rawValue: values.decode(String.self, forKey: .wheelchairAccessible)) ?? .unknown
        self.bikesAllowed = try Accessiblity(rawValue: values.decode(String.self, forKey: .bikesAllowed)) ?? .unknown
        self.stops = try values.decode(Array<Dictionary<String, String>>.self, forKey: .stops)
        self.operator = try values.decode(String.self, forKey: .operator)
    }
    
    let onestopId: String
    let name: String
    let vehicleType: String
    let color: UIColor?
    let wheelchairAccessible: Accessiblity
    let bikesAllowed: Accessiblity
    let stops: [[String: String]]
    let `operator`: String
}
