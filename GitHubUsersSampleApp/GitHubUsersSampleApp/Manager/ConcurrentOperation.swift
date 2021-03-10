//
//  ConcurrentOperation.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import Foundation

/// It allows asynchronous tasks, has a pause and resume states,
/// can be easily added to a queue and can be created with a block.
open class ConcurrentOperation: Operation {
    /// `Operation`'s execution block.
    public var executionBlock: ((_ operation: ConcurrentOperation) -> Void)?
    
    /// Set the `Operation` as asynchronous.
    override open var isAsynchronous: Bool {
        return true
    }
    
    /// Set if the `Operation` is executing.
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    /// Set if the `Operation` is executing.
    override open var isExecuting: Bool {
        return _executing
    }
    
    /// Set if the `Operation` is finished.
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    /// Set if the `Operation` is finished.
    override open var isFinished: Bool {
        return _finished
    }
    
    /// `Operation` progress, set it as many times as you like within the `Operation` execution.
    /// Useful for Queue Restoration.
    open var progress: Int = 0 {
        didSet {
            progress = progress < 100 ? (progress > 0 ? progress : 0) : 100
        }
    }
    
    /// You should use `hasFailed` if you want the retry feature.
    /// Set it to `true` if the `Operation` has failed, otherwise `false`.
    /// Default is `false` to avoid retries.
    @available(*, deprecated, renamed: "success")
    open var hasFailed: Bool {
        return !success
    }
    
    /// You should use `success` if you want the retry feature.
    /// Set it to `false` if the `Operation` has failed, otherwise `true`.
    /// Default is `true` to avoid retries.
    open var success = true
    
    /// Maximum allowed retries.
    /// Default are 3 retries.
    open var maximumRetries = 3
    
    /// Current retry attempt.
    open private(set) var currentAttempt = 1
    
    /// Allows for manual retries.
    /// If set to `true`, `retry()` function must be manually called.
    /// Default is `false` to automatically retry.
    open var manualRetry = false
    
    /// Specify if the `Operation` should retry another time.
    private var shouldRetry = true
    
    /// Creates the `Operation` with an execution block.
    ///
    /// - Parameters:
    ///   - name: Operation name, useful for Queue Restoration. It must be unique.
    ///   - executionBlock: Execution block.
    public init(name: String? = nil, executionBlock: ((_ operation: ConcurrentOperation) -> Void)? = nil) {
        super.init()
        
        self.name = name
        self.executionBlock = executionBlock
    }
    
    /// Start the `Operation`.
    override open func start() {
        _executing = true
        execute()
    }
    
    /// Retry function.
    /// It only works if `manualRetry` property has been set to `true`.
    open func retry() {
        if manualRetry, shouldRetry, let executionBlock = executionBlock {
            executionBlock(self)
            finish(success: success)
        }
    }
    
    /// Execute the `Operation`.
    /// If `executionBlock` is set, it will be executed and also `finish()` will be called.
    open func execute() {
        if let executionBlock = executionBlock {
            while shouldRetry, !manualRetry {
                executionBlock(self)
                finish(success: success)
            }
            
            retry()
        }
    }
    
    /// - Parameter hasFailed: Set it to `true` if the `Operation` has failed, otherwise `false`.
    @available(*, deprecated, renamed: "finish(success:)")
    open func finish(_ hasFailed: Bool) {
        finish(success: !hasFailed)
    }
    
    /// Notify the completion of asynchronous task and hence the completion of the `Operation`.
    /// Must be called when the `Operation` is finished.
    ///
    /// - Parameter success: Set it to `false` if the `Operation` has failed, otherwise `true`.
    ///                      Default is `true`.
    open func finish(success: Bool = true) {
        if success || currentAttempt >= maximumRetries {
            _executing = false
            _finished = true
            shouldRetry = false
        } else {
            currentAttempt += 1
            shouldRetry = true
        }
    }
    
    /// Pause the current `Operation`, if it's supported.
    /// Must be overridden by a subclass to get a custom pause action.
    open func pause() {}
    
    /// Resume the current `Operation`, if it's supported.
    /// Must be overridden by a subclass to get a custom resume action.
    open func resume() {}
}

/// `ConcurrentOperation` extension with queue handling.
public extension ConcurrentOperation {
    /// Adds the `Operation` to `shared` Queuer.
    func addToSharedQueuer() {
        Queuer.shared.addOperation(self)
    }
    
    /// Adds the `Operation` to the custom queue.
    ///
    /// - Parameter queue: Custom queue where the `Operation` will be added.
    func addToQueue(_ queue: Queuer) {
        queue.addOperation(self)
    }
}
