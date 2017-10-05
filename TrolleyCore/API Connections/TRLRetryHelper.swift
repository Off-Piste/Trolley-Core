//
//  TRLRetryHelper.swift
//  TrolleyCore
//
//  Created by Harry Wright on 21.09.17.
//

import Foundation
import ObjectiveC.NSObjCRuntime

// swiftlint:disable next type_name
public typealias trl_void_void = () -> Void

internal var arc4random_max: Double {
    return 0x100000000
}

internal var randomDouble: Double {
    return Double(arc4random()) / arc4random_max
}

@objc
public final class TRLRetryHelperTask: NSObject {

    @objc public var block: trl_void_void?

    public init(block: @escaping trl_void_void){
        self.block = block
    }

    private override init() {
        fatalError()
    }

    @objc public var isCanceled: Bool {
        return self.block == nil
    }

    public func cancel() {
        self.block = nil
    }

     public func execute() {
        block?()
    }
}

@objc
public final class TRLRetryHelper: NSObject {

    internal var queue: DispatchQueue

    internal var minRetryDelayAfterFailure: TimeInterval

    internal var maxRetryDelay: TimeInterval

    internal var retryExponent: Double

    internal var jitterFactor: Double

    internal var lastWasSuccess: Bool = true

    internal var currentRetryDelay: TimeInterval = TimeInterval(NSNotFound)

    internal var scheduledRetry: TRLRetryHelperTask?

    private override init() {
        fatalError()
    }

    @objc public init(withDispatchQueue queue: DispatchQueue, minRetryDelayAfterFailure: TimeInterval, maxRetryDelay: TimeInterval, retryExponent: Double, jitterFactor: Double) {
        self.queue = queue
        self.minRetryDelayAfterFailure = minRetryDelayAfterFailure
        self.maxRetryDelay = maxRetryDelay
        self.retryExponent = retryExponent
        self.jitterFactor = jitterFactor
    }

    @objc public func retry(block: @escaping trl_void_void) {
        if scheduledRetry != nil {
            TRLDebugLogger(for: .core, "Canceling existing retry attempt")
            scheduledRetry?.cancel()
            scheduledRetry = nil
        }

        var delay: TimeInterval!
        if (self.lastWasSuccess) {
            delay = 0
        } else {
            if self.currentRetryDelay == 0 {
                self.currentRetryDelay = self.minRetryDelayAfterFailure
            } else {
                let newDelay: TimeInterval = self.maxRetryDelay * self.retryExponent
                self.currentRetryDelay = min(newDelay, self.maxRetryDelay)
            }

            delay = ((1 - self.jitterFactor) * self.currentRetryDelay) +
                (self.jitterFactor * self.currentRetryDelay * randomDouble)
            TRLDebugLogger(for: .core, "Scheduling retry in %fs", delay)
        }

        let task = TRLRetryHelperTask(block: block)
        self.scheduledRetry = task
        self.lastWasSuccess = false

        let ns = DispatchTime.now().uptimeNanoseconds + UInt64(delay) * NSEC_PER_SEC
        let popTime: DispatchTime = DispatchTime(uptimeNanoseconds: ns)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            if (!task.isCanceled) {
                self.scheduledRetry = nil
                task.execute()
            }
        }

//        let timer = TRLTimer(for: delay * TimeInterval(NSEC_PER_SEC))
//        timer.queue = .main
//        timer.once {
//
//        }
    }

    @objc public func cancel() {
        if self.scheduledRetry != nil {
            TRLDebugLogger(for: .core, "Canceling existing retry attempt")
            self.scheduledRetry?.cancel()
            self.scheduledRetry = nil
        } else {
            TRLDebugLogger(for: .core, "No existing retry attempt to cancel")
        }
        self.currentRetryDelay = 0
    }

    @objc public func signalSuccess() {
        self.lastWasSuccess = true
        self.currentRetryDelay = 0
    }
}
