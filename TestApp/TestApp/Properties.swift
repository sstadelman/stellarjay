import Foundation

public enum Properties {
    
    //"properties": { "CSAFP": "264", "AFFGEOID": "330M400US264", "GEOID": "264", "NAME": "Gainesville-Lake City, FL", "LSAD": "M0", "ALAND": 5237676473, "AWATER": 266995123 },
    // Combined Statistical Area from US Census
    public struct CSA: Decodable {
        
        public let CSAFP: String
        public let AFFGEOID: String
        public let GEOID: String
        public let NAME: String
        public let LSAD: String
        public let ALAND: Int
        public let AWATER: Int
    }
    
    
    //"properties": { "GEO_ID": "0400000US23", "STATE": "23", "NAME": "Maine", "LSAD": "", "CENSUSAREA": 30842.923000 }
    public struct State: Decodable {
        
        private enum CodingKeys: String, CodingKey {
            case geoId = "GEO_ID"
            case id = "STATE"
            case name = "NAME"
            case censusArea = "CENSUSAREA"
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.geoId = try values.decode(String.self, forKey: .geoId)
            self.id = try values.decode(String.self, forKey: .id)
            self.name = try values.decode(String.self, forKey: .name)
            self.censusArea = try values.decode(Double.self, forKey: .censusArea)
        }
        
        public let geoId: String
        public let id: String
        public let name: String
        public let censusArea: Double
    }
    
}
