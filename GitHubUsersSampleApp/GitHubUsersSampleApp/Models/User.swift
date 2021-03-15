//
//  User.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import Foundation
import CoreData
import UIKit

extension User {
    
    func update(with userRM: UserResponseModel) throws {
        login = userRM.login
        userID = userRM.userID ?? 0
        nodeID = userRM.nodeID
        avatarURL = userRM.avatarURL
        gravatarID = userRM.gravatarID
        url = userRM.url
        htmlURL = userRM.htmlURL
        followingURL = userRM.followingURL
        followersURL = userRM.followersURL
        gistsURL = userRM.gistsURL
        starredURL = userRM.starredURL
        subscriptionURL = userRM.subscriptionURL
        organizationURL = userRM.organizationURL
        reposURL = userRM.reposURL
        eventsURL = userRM.eventsURL
        receivedEventsURL = userRM.receivedEventsURL
        type = userRM.type
        siteAdmin = userRM.siteAdmin ?? false
        name = userRM.name
        company = userRM.company
        blog = userRM.blog
        location = userRM.location
        email = userRM.email
        hireable = userRM.hireable ?? false
        bio = userRM.bio
        twitterUsername = userRM.twitterUsername
        piblicRepos = userRM.piblicRepos ?? 0
        publicGists = userRM.publicGists ?? 0
        followers = userRM.followers ?? 0
        following = userRM.following ?? 0
        createdAt = userRM.createdAt
        updatedAt = userRM.updatedAt
    }
}
