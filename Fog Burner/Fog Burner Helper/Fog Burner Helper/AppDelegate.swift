//
//  AppDelegate.swift
//  Fog Burner Helper
//
//  Created by Matthew Riley MacPherson on 22/11/2014.
//  Copyright (c) 2014 Matthew Riley MacPherson. All rights reserved.
//

import AppKit
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        NSLog("Quitting app")
        // Insert code here to initialize your application
        if NSWorkspace.sharedWorkspace().launchApplication("Fog Burner") {
            NSLog("Launched Fog Burner app, quitting...")
        } else {
            NSLog("Failed to launch Fog Burner app")
        }

        NSApplication.sharedApplication().terminate(self)
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
}

