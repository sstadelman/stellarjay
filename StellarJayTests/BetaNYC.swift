//
//  BetaNYC.swift
//  StellarJayTests
//
//  Created by Stadelman, Stan on 8/22/18.
//  Copyright © 2018 sstadelman. All rights reserved.
//

import Foundation

enum BetaNYC {
    
    struct Zone: Decodable {
        
        private enum CodingKeys: String, CodingKey {
            case id = "OBJECTID"
            case name = "SDNAME"
            case label = "SDLBL"
            case link = "@id"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try values.decode(String.self, forKey: .id)
            self.name = try values.decode(String.self, forKey: .name)
            self.label = try values.decode(String.self, forKey: .label)
            self.link = try values.decode(String.self, forKey: .link)
        }
        
        let id: String
        let name: String
        let label: String
        let link: String?
    }
    
}
