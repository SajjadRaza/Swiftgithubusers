//
//  SynchronousOperation.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import Foundation

/// It allows synchronous tasks, has a pause and resume states, can be easily added to a queue and can be created with a block.
public class SynchronousOperation: ConcurrentOperation {
    /// Private `Semaphore` instance.
    private let semaphore = Semaphore()
    
    /// Set the `Operation` as synchronous.
    override public var isAsynchronous: Bool {
        return false
    }
    
    /// Notify the completion of synchronous task and hence the completion of the `Operation`.
    /// Must be called when the `Operation` is finished.
    ///
    /// - Parameter success: Set it to `false` if the `Operation` has failed, otherwise `true`.
    ///                      Default is `true`.
    override public func finish(success: Bool = true) {
        super.finish(success: success)
        
        semaphore.continue()
    }
    
    /// Advises the `Operation` object that it should stop executing its task.
    override public func cancel() {
        super.cancel()
        
        semaphore.continue()
    }
    
    /// Execute the `Operation`.
    /// If `executionBlock` is set, it will be executed and also `finish()` will be called.
    override public func execute() {
        super.execute()
        
        semaphore.wait()
    }
}
