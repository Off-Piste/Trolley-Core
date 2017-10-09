//
//  Trolley.swift
//  Trolley
//
//  Created by Harry Wright on 14.09.17.
//  Copyright © 2017 Off-Piste.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import TrolleyCore.Dynamic

extension NSException {
    internal static func raise(
        for name: NSExceptionName = .genericException,
        _ msg: String
        ) -> Never
    {
        NSException(name: .genericException, reason: msg, userInfo: nil).raise()

        // Will never hit
        fatalError()
    }
}

// Have to place this out of the class as all methods are created in Trolley.shared.configure()
// so could do what firebase does and has configure as a sort of factory method and call this instead
// or not
var aTRLShop: Trolley!

/**
 The entry point for our Trolley SDKs.

 Initialize and configure FIRApp using +[Trolley configure]
 (Trolley.configure() in swift) or other customized ways as shown below.

 The logging system 
 */
@objcMembers public final class Trolley: NSObject {

    @objc public var options: TRLOptions

    #if swift(>=4.0)
    @objc(networkManager) private var networkManager: TRLNetworkManager!
    #else
    @objc(networkManager) fileprivate var networkManager: TRLNetworkManager!
    #endif

    /// Opens and configures the default Trolley shop.
    ///
    /// This method should be called after the app is launched and before
    /// using any Trolley services.
    ///
    /// - Note:     This method is thread safe.
    /// - Warning:  Raises an exception if any configuration step fails.
    @objc public class func open() {
        self.open(with: .default)
    }

    /// Open and configures the default trolley shop with custom options.
    ///
    /// This method should be called after the app is launched and before
    /// using any Trolley services.
    ///
    /// - Note:                 This method is thread safe.
    /// - Warning:              Raises an exception if any configuration step fails.
    /// - Parameter options:    The Trolley shop options used to configure the service.
    @objc(openWithOptions:) public class func open(with options: TRLOptions) {
        if aTRLShop != nil {
            NSException.raise("Default shop has already been configured.")
        }

        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        TRLDebugLogger(for: .core, "Configuring the default shop.")

        aTRLShop = Trolley(withOptions: options)
        self.sendNotificationsToSDK(aTRLShop)
    }

    /// Internal init, calls coreConfigure to setup the Trolley Insstance
    private init(withOptions options: TRLOptions) {
        self.options = options

        super.init()
        self.coreConfigure()
    }

    /// Please use [Trolley configure:] or [Trolley configureWithOptions:] instead
    ///
    /// - Warning: NEVER CALL DIRECTLY
    @available(*, unavailable, renamed: "configure()")
    private override init() { fatalError() }

}

extension Trolley {

    /// Cleans up the current Trolley Shop and releases any objects.
    ///
    /// - Note:              This method is thread safe.
    /// - Parameter handler: A handler that returns a true if the shop has
    ///                      been deleted or false if the shop could not be deleted.
    public func deleteShop(handler: ((Bool) -> Void)?) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }

        if aTRLShop == nil {
            TRLInfoLogger(for: .core, "Shop [%@] has already been deleted", self.shopName)
            handler?(false); return
        }

        TRLInfoLogger(for: .core, "Deleting shop [%@]", self.shopName)
        aTRLShop = nil
        handler?(true)
    }

    /// Cleans up the current Trolley Shop and releases any objects.
    ///
    /// - Note: This method is thread safe.
    public func deleteShop() {
        self.deleteShop(handler: nil)
    }

    /// Method to set the Global logger level
    public class func setLoggingLevel(_ level: LoggerLevel) {
        TRLLog(for: .core, "Setting the global logger level to %lu, please note if we are in TRLDebugMode this will be ignored!", level.rawValue)
        kGlobalLoggerLevel = level
    }

}

extension Trolley {

    #if swift(>=4.0)
    private func coreConfigure() { _core_config() }
    #else
    fileprivate func coreConfigure() { _core_config() }
    #endif

    private func _core_config() {
        // 1. Validate the entered options
        do {
            try self.options.validateOrThrow()
        } catch Trolley.Error.couldNotFindFile {
            let msg =   "The config file is missing, please " +
                        "download a new one at http://console.trolleyio.co.uk " +
                        "or if you have changed the name, call " +
                        "[[Trolley shared] configureWithOptions:]] " +
                        "(Trolley.shared.configure(with:) in swift) and specify the new name"

            NSException.raise(msg)
        } catch {
            NSException.raise(error.localizedDescription)
        }

        // 2. Create NetworkManager and Start Reachabilty
        self.networkManager = TRLNetworkManager(options: options)
        self.networkManager.reachability.start()
        self.networkManager.__trl_connect()
    }

    /**
     This is a workaround for the fact we can't do:

     #if swift(>=4.0)
     private class func sendNotificationsToSDK(_ shop: Trolley) {
     #else
     fileprivate class func sendNotificationsToSDK(_ shop: Trolley) {
     #endif
         ...
     }
     */
    #if swift(>=4.0)
    private class func sendNotificationsToSDK(_ shop: Trolley) { send_notifications_to_SDK(shop) }
    #else
    fileprivate class func sendNotificationsToSDK(_ shop: Trolley) { send_notifications_to_SDK(shop) }
    #endif

    private class func send_notifications_to_SDK(_ shop: Trolley) {
        let ui = ["TRLAppNameKey": shop.shopName]

        NotificationCenter.default.post(
            name: .TRLTrolleyStartingUp,
            object: shop,
            userInfo: ui
        )
    }

}

extension Trolley {

    /// <#Description#>
    @objc public var shopName: String {
        return options.shopName
    }

    /// - Note: Maybe have this as initaliser too, so it creates the default shop upon calling
    ///         if the aTRLShop is not created yet
    @objc public static var shop: Trolley? {
        if aTRLShop == nil {
            TRLInfoLogger(for: .core, "The Trolley shop has not been configured yet, please add [Trolley open] OR Trolley.open() to your application initialization")
            return nil
        }

        return aTRLShop
    }

    /// <#Description#>
    @objc public static var isShopOpen: Bool {
        return shop != nil
    }

}
