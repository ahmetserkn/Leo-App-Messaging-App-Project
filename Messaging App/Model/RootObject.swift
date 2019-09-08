//
//  Result.swift
//  Messaging App
//
//  Created by AhmetSerkan on 8.09.2019.
//  Copyright © 2019 Ahmet Serkan. All rights reserved.
//

import Foundation

struct Message: Codable {
    var id: Int?
    var user: User?
    var text: String?
    var timestamp: Int?
    var isSelf: Bool?
}
