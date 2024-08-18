//
//  SUserEntity.swift
//  TymeXTest
//
//  Created by Thanh Nhut on 18/8/24.
//

import CoreData

extension SUserEntity {
    convenience init(userInfo: GUser, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.login = userInfo.username
        self.avatar_url = userInfo.avatarUrl
        self.html_url = userInfo.landingPageUrl
        self.location = userInfo.location
        self.followers = Int64(userInfo.followers ?? 0)
        self.following = Int64(userInfo.following ?? 0)
        self.createdAt = userInfo.createdAt ?? Date()
    }
}

extension SUserEntity {
    func toDomain() -> GUser {
        return .init(username: login,
                     landingPageUrl: html_url,
                     avatarUrl: avatar_url,
                     location: location,
                     followers: Int(followers),
                     following: Int(following))
    }
}
