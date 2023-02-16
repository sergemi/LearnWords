//
//  Logger.swift
//  LearnWords
//
//  Created by sergemi on 15.02.2023.
//

import Foundation

struct log {
    
    private init() {}
    
    private static func log(level: Level, _ items: [Any], pathToFile: String, line: Int, function: String) {
    #if DEBUG
        let fileName = (pathToFile as NSString).lastPathComponent
        let argsAsStr = items.map { String(describing: $0) }.joined(separator: " ")
        let threadName = Thread.current.isMainThread ?  "[main]" : "[background]"
        print(level.icon, Date().formattedNow, "thread: \(threadName)", "<\(line)>", fileName, function)
        print(argsAsStr)
    #endif
    }
}

// MARK: - Log level

private extension log {
    
    enum Level {
        case debug
        case info
        case error
        case network
        
        var icon: String {
            switch self {
            case .debug  : return "👁"
            case .info   : return "ℹ️"
            case .error  : return "🤬"
            case .network: return "📡"
            }
        }
    }
    
}

extension log {
    
    static func debug(_ message: Any..., pathToFile: String = #file, line: Int = #line, function: String = #function) {
        log(level: .debug, message, pathToFile: pathToFile, line: line, function: function)
    }
    
    static func info(_ message: Any..., pathToFile: String = #file, line: Int = #line, function: String = #function) {
        log(level: .info, message, pathToFile: pathToFile, line: line, function: function)
    }
    
    static func mark(pathToFile: String = #file, line: Int = #line, function: String = #function) {
        log(level: .info, [], pathToFile: pathToFile, line: line, function: function)
    }
    
    static func error(_ message: Any..., pathToFile: String = #file, line: Int = #line, function: String = #function) {
        log(level: .error, message, pathToFile: pathToFile, line: line, function: function)
    }
    
    static func network(_ message: Any..., pathToFile: String = #file, line: Int = #line, function: String = #function) {
        log(level: .network, message, pathToFile: pathToFile, line: line, function: function)
    }
    
    static func method(file: String = #file, function: String = #function) {
        #if DEBUG
        let lvl = Level.info
        var className = file.components(separatedBy: "/").last ?? ""
        className = className.components(separatedBy: ".").first ?? ""
//        print(lvl.icon, className, ".", function)
        print(lvl.icon, "\(className).\(function)")
        #endif
    }
}
