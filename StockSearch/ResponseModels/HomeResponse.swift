

import Foundation
struct HomeResponse : Codable {
	let ok : Bool?
	let users : [UserResponse]?

	enum CodingKeys: String, CodingKey {

		case ok = "ok"
		case users = "users"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		ok = try values.decodeIfPresent(Bool.self, forKey: .ok)
		users = try values.decodeIfPresent([UserResponse].self, forKey: .users)
	}

}
