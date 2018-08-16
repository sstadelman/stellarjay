//
//  BearTransit.swift
//  StellarJayTests
//
//  Created by Stadelman, Stan on 8/15/18.
//  Copyright © 2018 sstadelman. All rights reserved.
//

import Foundation
import UIKit

enum BearTransit {
    
    struct Route: Decodable {

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
        
        init(from decoder: Decoder) throws {
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
    
    struct Stop: Decodable {
        
        private enum CodingKeys: String, CodingKey {
            case onestopId = "onestop_id"
            case name
            //        case timezone
            case vehicleTypes = "served_by_vehicle_types"
            case wheelchairAccessible = "wheelchair_boarding"
            case operators = "operators_serving_stop"
            case routes = "routes_serving_stop"
            case tags
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.onestopId = try values.decode(String.self, forKey: .onestopId)
            self.name = try values.decode(String.self, forKey: .name)
            self.vehicleTypes = try values.decode(Array<String>.self, forKey: .vehicleTypes)
            if let accessible = try values.decodeIfPresent(String.self, forKey: .wheelchairAccessible) {
                self.wheelchairAccessible = Accessiblity(rawValue: accessible) ?? .unknown
            } else {
                self.wheelchairAccessible = .unknown
            }
            self.operators = try values.decode(Array<Dictionary<String, String>>.self, forKey: .operators)
            self.routes = try values.decode(Array<Dictionary<String, String>>.self, forKey: .routes)
            self.tags = try values.decode(Dictionary<String, String>.self, forKey: .tags)
        }
        
        let onestopId: String
        let name: String
        //    let timezone: String
        let vehicleTypes: [String]
        let wheelchairAccessible: Accessiblity
        let operators: [[String: String]]
        let routes: [[String: String]]
        let tags: [String: String]
    }
    
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
}

// from https://stackoverflow.com/a/51236967/242447
extension UIColor {
    convenience init(hexString:String, alpha:CGFloat = 1.0) {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
