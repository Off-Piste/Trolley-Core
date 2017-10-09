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

private final class TRLRetryHelperTask: NSObject {

    var block: trl_void_void?

    init(block: @escaping trl_void_void){
        self.block = block
    }

    override init() {
        fatalError()
    }

    var isCanceled: Bool {
        return self.block == nil
    }

    func cancel() {
        self.block = nil
    }

    func execute() {
        block?()
    }
}

/// :nodoc:
@objc public final class TRLRetryHelper: NSObject {

    private var queue: DispatchQueue

    private var minRetryDelayAfterFailure: TimeInterval

    private var maxRetryDelay: TimeInterval

    private var retryExponent: Double

    private var jitterFactor: Double

    private var lastWasSuccess: Bool = true

    private var currentRetryDelay: TimeInterval = TimeInterval(NSNotFound)

    private var scheduledRetry: TRLRetryHelperTask?

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
