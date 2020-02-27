import Foundation

public enum us_state_outlines {
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
