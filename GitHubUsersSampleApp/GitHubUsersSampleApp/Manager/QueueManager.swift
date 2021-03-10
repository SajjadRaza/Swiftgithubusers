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
                if self.queueList.count > 0 {
                    print(self.queueList.count)
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
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}
