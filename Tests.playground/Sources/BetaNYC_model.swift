import Foundation

public enum BetaNYC {
    
    public struct Zone: Decodable {
        
        private enum CodingKeys: String, CodingKey {
            case id = "OBJECTID"
            case name = "SDNAME"
            case label = "SDLBL"
            case link = "@id"
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try values.decode(Int.self, forKey: .id)
            self.name = try values.decode(String.self, forKey: .name)
            self.label = try values.decode(String.self, forKey: .label)
            self.link = try values.decode(String.self, forKey: .link)
        }
        
        public let id: Int
        public let name: String
        public let label: String
        public let link: String?
    }
    
}
