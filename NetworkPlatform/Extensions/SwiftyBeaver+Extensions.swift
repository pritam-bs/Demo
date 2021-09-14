//
//  SwiftyBeaver+Extensions.swift
//  NetworkPlatform
//
//  Created by Pritam on 11/9/21.
//

import SwiftyBeaver
import Foundation

let log = SwiftyBeaver.self

extension SwiftyBeaver {
    class func initLog() {
        let console = ConsoleDestination()
        let file = FileDestination()
        let subPath = "Demo.log"
        let tempFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent(subPath)
        let url = URL(fileURLWithPath: tempFilePath, isDirectory: false)
        file.logFileURL = url
        console.format = "$DHH:mm:ss$d $N.$F():$l $C$L$c: $M"
        SwiftyBeaver.addDestination(console)
        SwiftyBeaver.addDestination(file)
        
        #if DEBUG
        console.minLevel = .debug
        file.minLevel = .debug
        #else
        console.minLevel = .warning
        file.minLevel = .warning
        #endif
    }
}
