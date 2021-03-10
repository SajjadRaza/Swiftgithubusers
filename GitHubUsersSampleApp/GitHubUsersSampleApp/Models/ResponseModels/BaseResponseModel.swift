//
//  BaseResponseModel.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import Foundation

struct UserResponseModel: Codable {
    
    let login: String?
    let id: Int32?
    let nodeID: String?
    let avatarURL: String?
    let gravatarID: String?
    let url: String?
    let htmlURL: String?
    let followingURL: String?
    let followersURL: String?
    let gistsURL: String?
    let starredURL: String?
    let subscriptionURL: String?
    let organizationURL: String?
    let reposURL: String?
    let eventsURL: String?
    let receivedEventsURL: String?
    let type: String?
    let siteAdmin: Bool?
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let hireable: Bool?
    let bio: String?
    let twitterUsername: String?
    let piblicRepos: Int32?
    let publicGists: Int32?
    let followers: Int32?
    let following: Int32?
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        
        case login = "login"
        case id = "id"
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url = "url"
        case htmlURL = "html_url"
        case followingURL = "following_url"
        case followersURL = "followers_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionURL = "subscriptions_url"
        case organizationURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type = "type"
        case siteAdmin = "site_admin"
        case name = "name"
        case company = "company"
        case blog = "blog"
        case location = "location"
        case email = "email"
        case hireable = "hireable"
        case bio = "bio"
        case twitterUsername = "twitter_username"
        case piblicRepos = "piblic_repos"
        case publicGists = "public_gists"
        case followers = "followers"
        case following = "following"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        login = try values.decodeIfPresent(String.self, forKey: .login)
        id = try values.decodeIfPresent(Int32.self, forKey: .id)
        nodeID = try values.decodeIfPresent(String.self, forKey: .nodeID)
        avatarURL = try values.decodeIfPresent(String.self, forKey: .avatarURL)
        gravatarID = try values.decodeIfPresent(String.self, forKey: .gravatarID)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        htmlURL = try values.decodeIfPresent(String.self, forKey: .htmlURL)
        followingURL = try values.decodeIfPresent(String.self, forKey: .followingURL)
        followersURL = try values.decodeIfPresent(String.self, forKey: .followersURL)
        gistsURL = try values.decodeIfPresent(String.self, forKey: .gistsURL)
        starredURL = try values.decodeIfPresent(String.self, forKey: .starredURL)
        subscriptionURL = try values.decodeIfPresent(String.self, forKey: .subscriptionURL)
        organizationURL = try values.decodeIfPresent(String.self, forKey: .organizationURL)
        reposURL = try values.decodeIfPresent(String.self, forKey: .reposURL)
        eventsURL = try values.decodeIfPresent(String.self, forKey: .eventsURL)
        receivedEventsURL = try values.decodeIfPresent(String.self, forKey: .receivedEventsURL)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        siteAdmin = try values.decodeIfPresent(Bool.self, forKey: .siteAdmin)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        company = try values.decodeIfPresent(String.self, forKey: .company)
        blog = try values.decodeIfPresent(String.self, forKey: .blog)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        hireable = try values.decodeIfPresent(Bool.self, forKey: .hireable)
        bio = try values.decodeIfPresent(String.self, forKey: .bio)
        twitterUsername = try values.decodeIfPresent(String.self, forKey: .twitterUsername)
        piblicRepos = try values.decodeIfPresent(Int32.self, forKey: .piblicRepos)
        publicGists = try values.decodeIfPresent(Int32.self, forKey: .publicGists)
        followers = try values.decodeIfPresent(Int32.self, forKey: .followers)
        following = try values.decodeIfPresent(Int32.self, forKey: .following)
        createdAt = try values.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(Date.self, forKey: .updatedAt)
    }
}
