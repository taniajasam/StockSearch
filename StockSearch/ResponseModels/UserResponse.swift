
import Foundation
struct UserResponse : Codable {
	let avatarUrl : String?
	let displayName : String?
	let id : Int?
	let username : String?

	enum CodingKeys: String, CodingKey {

		case avatarUrl = "avatar_url"
		case displayName = "display_name"
		case id = "id"
		case username = "username"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
		displayName = try values.decodeIfPresent(String.self, forKey: .displayName)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		username = try values.decodeIfPresent(String.self, forKey: .username)
	}

}
