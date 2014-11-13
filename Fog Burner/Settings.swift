//
//  Settings.swift
//  Fog Burner
//
//  Created by Matthew Riley MacPherson on 2014-11-12.
//  Copyright (c) 2014 Matthew Riley MacPherson. All rights reserved.
//

import Foundation
import ServiceManagement

class Settings {
    class func load() -> NSUserDefaults {
        var preferences = NSUserDefaults.standardUserDefaults()
        preferences.registerDefaults([
            "activateOnLaunch": false,
            "firstRunComplete": false,
            "openAtLogin": false,
            "timer": 0
        ])
        
        return preferences
    }
    
    class func setToOpenAtLogin(enable : Boolean) -> Bool {
        var helperAppUrl = NSBundle.mainBundle().bundleURL.URLByAppendingPathComponent("Contents/Library/LoginItems/FogBurnerHelper.app", isDirectory: true)
        
        var status = LSRegisterURL(helperAppUrl, enable)
        SMLoginItemSetEnabled("com.lonelyvegan.fogburnerhelper", enable)
//        if status {
//            NSLog("Failed to LSRegisterURL '%@': %jd", helperAppUrl, status)
//        }
//        
//        if SMLoginItemSetEnabled("com.lonelyvegan.fogburnerhelper", enable) {
//            NSLog("SMLoginItemSetEnabled change to \(enable) worked!")
//        }
        
        return true
    }
}
