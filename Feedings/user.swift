//
//  user.swift
//  Feedings
//
//  Created by Kevin McGladdery on 2/3/16.
//  Copyright © 2016 Kevin McGladdery. All rights reserved.
//

import Foundation

protocol User {
    static func currentUser() -> User
}