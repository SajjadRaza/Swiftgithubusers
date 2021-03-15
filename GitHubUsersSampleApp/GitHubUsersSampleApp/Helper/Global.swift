//
//  Global.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import Foundation

class Global {
    class var shared: Global {
        struct Static {
            static let instance: Global = Global()
        }
        return Static.instance
    }
    let queueManager = QueueManager()
    let queue = Queuer(name: "GitHubQueue", maxConcurrentOperationCount: Int.max, qualityOfService: .default)
    
    var apiResponsePageSize: Int = 0
    
    #if DEBUG
    let environment: EnvironmentProtocol = AppURL.development
    #else
    let environment: EnvironmentProtocol = AppURL.production
    #endif
    
}
