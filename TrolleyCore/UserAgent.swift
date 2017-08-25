//
//  TRLUserAgent.swift
//  TrolleyCore
//
//  Created by Harry Wright on 25.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

import UIKit

/// User-Agent
/// 
/// Example: `iOS Example/1.0 (io.off-piste.iOS-Example; build:1; iOS 10.0.0) TrolleyCore/10.5.10`
///
/// See - https://tools.ietf.org/html/rfc7231#section-5.5.3
public final class UserAgent: NSObject {

    internal var bundleInfoDictionary: [String: Any]? {
        return Bundle.main.infoDictionary
    }

    public static var shared: UserAgent {
        return UserAgent()
    }

    public var executable: String {
        return bundleInfoDictionary?[kCFBundleExecutableKey as String] as? String ?? "Unknown"
    }

    public var bundle: String {
        return bundleInfoDictionary?[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
    }

    public var appVersion: String {
        return bundleInfoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    public var appBuild: String {
        return bundleInfoDictionary?[kCFBundleVersionKey as String] as? String ?? "Unknown"
    }

    public var osName_Version: String {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

        let osName: String = {
            #if os(iOS)
                return "iOS"
            #elseif os(watchOS)
                return "watchOS"
            #elseif os(tvOS)
                return "tvOS"
            #elseif os(macOS)
                return "OS X"
            #elseif os(Linux)
                return "Linux"
            #else
                return "Unknown"
            #endif
        }()

        return "\(osName) \(versionString)"
    }

    public var trolleyVersion: String {
        guard let tcInfo = Bundle(for: Trolley.self).infoDictionary,
            let build = tcInfo["CFBundleShortVersionString"] else {
            return "Unknown"
        }
        return "Trolley/\(build)"
    }

    public func header() -> String {
        if self.bundleInfoDictionary != nil {
            return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osName_Version)) \(trolleyVersion)"
        }

        return "Trolley"
    }
}
