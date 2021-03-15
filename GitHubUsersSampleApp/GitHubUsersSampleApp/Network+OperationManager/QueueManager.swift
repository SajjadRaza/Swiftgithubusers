//
//  QueueManager.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import Foundation
import Network

class QueueManager {
    let monitor = NWPathMonitor() 
    var queueList = [ConcurrentOperation]()
    var isChainOperationStart = false
    
    init() {
    }
    
    func monitorQueue() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                NotificationCenter.default.post(name: Notification.Name("connectionAvailable"), object: nil)
                if self.queueList.count > 0 {
                    if self.isChainOperationStart == false {
                        self.isChainOperationStart = true
                        Global.shared.queue.addChainedOperations(self.queueList) {
                            self.isChainOperationStart = false
                            self.queueList.removeAll()
                        }
                    }
                }
            } else {
                print("No connection.")
                NotificationCenter.default.post(name: Notification.Name("noConnection"), object: nil)
            }
        }
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }
}
