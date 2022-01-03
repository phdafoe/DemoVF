//
//  VFGLogger.swift
//  VFGCommonUtils
//
//  Created by Tomasz Czyżak on 12/11/2018
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation
import os.log

/**
 Log debug messages
 - Parameter file: file which contains log call - do not specify it will be populated during runtime
 - Parameter function: function/method which contains log call - do not specify it will be populated during runtime
 - Parameter line: line number where log is called - do not specify it will be populated during runtime
 - Parameter message: log message - supports also string format arguments
 - Parameter arguments: list of params - combined with message will build whole log message
 ### Example usage: ###
 ````
 VFGDebugLog("test")
 ````
 ### Output: ###
 ````
2018-10-12 09:09:37.3420 VFGLoggerTests.testLogger():46 🗣 test
 ````
 */
public func VFGDebugLog(file: String = #file,
                        function: String = #function,
                        line: Int = #line,
                        _ message: String,
                        _ arguments: CVarArg...) {
    VFGLogger.log(file: file, function: (function, line), logLevel: .debug, message: message, arguments: arguments)
}

/**
 Log info messages
 - Parameter file: file which contains log call - do not specify it will be populated during runtime
 - Parameter function: function/method which contains log call - do not specify it will be populated during runtime
 - Parameter line: line number where log is called - do not specify it will be populated during runtime
 - Parameter message: log message - supports also string format arguments
 - Parameter arguments: list of params - combined with message will build whole log message
 ### Example usage: ###
 ````
 VFGInfoLog("test")
 ````
 ### Output: ###
 ````
2018-10-12 09:09:37.3110 VFGLoggerTests.testLogger():45 🤖 test
 ````
 */
public func VFGInfoLog(file: String = #file,
                       function: String = #function,
                       line: Int = #line,
                       _ message: String,
                       _ arguments: CVarArg...) {
    VFGLogger.log(file: file, function: (function, line), logLevel: .info, message: message, arguments: arguments)
}

/**
 Log warning messages
 - Parameter file: file which contains log call - do not specify it will be populated during runtime
 - Parameter function: function/method which contains log call - do not specify it will be populated during runtime
 - Parameter line: line number where log is called - do not specify it will be populated during runtime
 - Parameter message: log message - supports also string format arguments
 - Parameter arguments: list of params - combined with message will build whole log message
 ### Example usage: ###
 ````
 VFGWarningLog("test")
 ````
 ### Output: ###
 ````
2018-10-12 09:09:37.3100 VFGLoggerTests.testLogger():44 🙀 test
 ````
 */
public func VFGWarningLog(file: String = #file,
                          function: String = #function,
                          line: Int = #line,
                          _ message: String,
                          _ arguments: CVarArg...) {
    VFGLogger.log(file: file, function: (function, line), logLevel: .warning, message: message, arguments: arguments)
}

/**
 Log error messages
 - Parameter file: file which contains log call - do not specify it will be populated during runtime
 - Parameter function: function/method which contains log call - do not specify it will be populated during runtime
 - Parameter line: line number where log is called - do not specify it will be populated during runtime
 - Parameter message: log message - supports also string format arguments
 - Parameter arguments: list of params - combined with message will build whole log message
 ### Example usage: ###
 ````
VFGErrorLog("test")
 ````
 ### Output: ###
````
 2018-10-12 08:47:30.6400 VFGLoggerTests.testLogger():43 👺 test
 ````
 */
public func VFGErrorLog(file: String = #file,
                        function: String = #function,
                        line: Int = #line,
                        _ message: String,
                        _ arguments: CVarArg...) {
    VFGLogger.log(file: file, function: (function, line), logLevel: .error, message: message, arguments: arguments)
}

/**
 Vodafone Group default logger - used across all Vodafone frameworks
 - Remark: Logging mechanizm is available on Debug version of VFGCommonUtils.
           Release version doesn't log anything regardless of settings.
 */
@objc public class VFGLogger: NSObject {

    internal static let shared: VFGLogger = VFGLogger()
    internal var logLevel: VFGLogLevel = .none
    internal var logToFile: Bool = false

    /**
     If logging to file is enabled this is where logs will be stored.
     Log file is created in Documents dir and each application restart will create new one.
     - Note: Log file naming convention: \<AppName\>-\<Date\>.log
     */
    public static let logFile: String = String.fullLogFilePath()

    /**
     Configure logger
     - Parameter logLevel: level of logging see VFGLogLevel for more details
     - Parameter logToFile: enable logging to file if set to true, otherwise log to file is disabled
     */
    public class func configure(logLevel: VFGLogLevel, logToFile: Bool = false) {
        let logger = VFGLogger.shared
        logger.logLevel = logLevel
        logger.logToFile = logToFile
        if logToFile {
            redirectMsgLogsToFile()
        }
    }

    internal static func log(file: String,
                             function: (String, Int),
                             logLevel: VFGLogLevel,
                             message: String,
                             arguments: CVarArg...) {
        if !VFGEnvironment.isDebug() {
            return
        }

        if logLevel > VFGLogger.shared.logLevel {
            return
        }

        let logMessage = String(format: message, arguments: arguments)
        let className = URL(fileURLWithPath: file).lastPathComponent .replacingOccurrences(of: ".swift", with: "")
        let dateStr = DateFormatter.logEntryDateFormatter.string(from: Date())
        let message = "\(dateStr) \(className).\(function.0):\(function.1) \(logLevel.toString()) \(logMessage)"
        print(message)
        if VFGLogger.shared.logToFile {
            VFGLogger.logToFile(message)
        }
    }

    private class func logToFile(_ message: String) {
        let fileManager = FileManager.default
        let logFilePath = VFGLogger.logFile
        if !fileManager.fileExists(atPath: logFilePath) {
            if fileManager.createFile(atPath: logFilePath, contents: nil, attributes: nil) == false {
                return
            }
        }

        guard let logFileHandler = FileHandle(forWritingAtPath: logFilePath),
            let data = "\(message)\n".data(using: .utf8) else {
                return
        }

        logFileHandler.seekToEndOfFile()
        logFileHandler.write(data)
        logFileHandler.synchronizeFile()
    }

    private class func redirectMsgLogsToFile() {
        let stderrOutputURL = URL(fileURLWithPath: VFGLogger.logFile)
        let stderrOutputFilePath: String = stderrOutputURL.path
        freopen(stderrOutputFilePath, "a+", stderr)
    }

    // MARK: deprecated properties/methods

    @available(*, deprecated, message: "since 2.1.0")
    static public func log(component: Bundle? = nil, _ format: String?, _ args: CVarArg...) {
        if !VFGEnvironment.isDebug() {
            return
        }

        if VFGLogger.shared.logLevel > .none,
            let format = format {
            let message = String(format: format, arguments: args)
            let prefix = "\(VFGLogLevel.debug.toString())"
            VFGLogger.loggingClosure("\(prefix) \(message)")
        }
    }

    @available(*, deprecated, message:"since 2.1.0")
    @objc static public private(set) var outputFilePath: String? = logFile

    @available(*, deprecated, message: "since 2.1.0")
    @objc static public var configuration: VFGConfiguration.Type = VFGConfiguration.self

    @available(*, deprecated, message: "since 2.1.0")
    static internal let logsFileName: String = ""

    @available(*, deprecated, message: "since 2.1.0")
    @objc public static func redirectLogsToFile() {}

    @available(*, deprecated, message: "since 2.1.0")
    @objc public static var loggingClosure: (String) -> Void = { (_ message: String) -> Void in
        if !VFGEnvironment.isDebug() {
            return
        }
        print("\(message)")
    }

}
