//
//  Scheduler.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import Dispatch
import Foundation

/// Scheduler struct, based on top of `DispatchSourceTimer`.
public struct Scheduler {
    /// Schedule timer.
    public private(set) var timer: DispatchSourceTimer
    /// Schedule deadline.
    public private(set) var deadline: DispatchTime
    /// Schedule repeating interval.
    public private(set) var repeating: DispatchTimeInterval
    /// Schedule quality of service.
    public private(set) var qualityOfService: DispatchQoS
    /// Schedule handler.
    public private(set) var handler: (() -> Void)?
    
    /// Create a schedule.
    ///
    /// - Parameters:
    ///   - deadline: Deadline.
    ///   - repeating: Repeating interval
    ///   - qualityOfService: Quality of service.
    ///   - handler: Closure handler.
    public init(deadline: DispatchTime, repeating: DispatchTimeInterval, qualityOfService: DispatchQoS = .default, handler: (() -> Void)? = nil) {
        self.deadline = deadline
        self.repeating = repeating
        self.qualityOfService = qualityOfService
        self.handler = handler
        
        timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: deadline, repeating: repeating)
        if let handler = handler {
            timer.setEventHandler(qos: qualityOfService) {
                handler()
            }
            timer.resume()
        }
    }
    
    /// Set the handler after schedule creation.
    ///
    /// - Parameter handler: Closure handler.
    public mutating func setHandler(_ handler: @escaping () -> Void) {
        self.handler = handler
        
        timer.setEventHandler(qos: qualityOfService) {
            handler()
        }
        timer.resume()
    }
}
