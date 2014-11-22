//
//  FirstRunPrompt.swift
//  Fog Burner
//
//  Created by Matthew Riley MacPherson on 22/11/2014.
//  Copyright (c) 2014 Matthew Riley MacPherson. All rights reserved.
//

import AppKit
import Cocoa

class FirstRunPromptController: NSWindowController {
    
    // @IBOutlet var window: NSWindow!

    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    @IBAction func saveOpenAtLaunchPreference(sender: AnyObject) {
        UserPreferences.setBool(sender.state == NSOnState ? true : false, forKey: "activateOnLaunch")
    }
    
}
