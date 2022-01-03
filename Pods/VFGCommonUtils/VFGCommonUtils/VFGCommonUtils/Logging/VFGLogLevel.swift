//
//  VFGLogLevel.swift
//  VFGCommonUtils
//
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

/// Define log level
public enum VFGLogLevel: Int, Comparable {

    /// No logs - default
    case none = 0
    /// Error logs only
    case error = 1
    /// Enable warning logs
    case warning = 2
    /// Enable info logs
    case info = 3
    /// Enable all logs
    case debug = 4

    func toString() -> String {
        switch self {
        case .none:
            return ""
        case .error:
            return "👺"
        case .warning:
            return "🙀"
        case .info:
            return "🤖"
        case .debug:
            return "🗣"
        }
    }

    public static func < (lhs: VFGLogLevel, rhs: VFGLogLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    static func all() -> [VFGLogLevel] {
        return [.none, .error, .warning, .info, .debug]
    }

}
