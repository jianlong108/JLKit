//
//  File.swift
//  bigolive
//
//  Created by JL on 2023/9/28.
//  Copyright © 2023 YY Inc. All rights reserved.
//

import Foundation
import os.signpost

@objc
public final class BLSignposts: NSObject {
    static let applaunchLog = OSLog(subsystem: "bigolive", category: "applaunch")
    static let applaunchpid = OSSignpostID(log: applaunchLog)

    static let poiLog = OSLog(subsystem: "bigolive", category: .pointsOfInterest)
    static let poipid = OSSignpostID(log: poiLog)

    private class func aMethod(i: Int) -> StaticString {
        switch i {
        case 1:
            return "appLaunch"
        case 2:
            return "firstFrame"
        case 3:
            return "lifeCycle"
        case 4:
            return "mainTabbar"
        case 5:
            return "mainLive"
        case 6:
            return "mainThreadCost"
        case 7:
            return "LaunchPlugin"
        case 8:
            return "runloop"
        case 9:
            return "UIInitlize"
        case 10:
            return "tiebar"
        default:
            return "Default"
        }
    }
    @objc public class func os_signpost_begin(_ idx: Int, name: String) {
        os_signpost(.begin, log: BLSignposts.applaunchLog, name: BLSignposts.aMethod(i: idx), signpostID: BLSignposts.applaunchpid, "%{public}@",name)
    }
    @objc public class func os_signpost_end(_ idx: Int, name: String) {
        os_signpost(.end, log: BLSignposts.applaunchLog, name: BLSignposts.aMethod(i: idx), signpostID: BLSignposts.applaunchpid, "%{public}@",name)
    }
    @objc public class func os_poi_event(_ idx: Int, name: String) {
        os_signpost(.event, log: BLSignposts.poiLog, name: BLSignposts.aMethod(i: idx), "%{public}@",name)
    }
}
