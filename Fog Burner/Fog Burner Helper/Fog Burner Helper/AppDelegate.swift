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
        // Launch Fog Burner when the app is opened (should only be on user login).
        if NSWorkspace.sharedWorkspace().launchApplication("Fog Burner") {
            NSLog("Launched Fog Burner")
        } else {
            NSLog("Failed to launch Fog Burner -- was it renamed?")
        }

        NSApplication.sharedApplication().terminate(self)
    }

}
