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

    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    @IBAction func saveOpenAtLaunchPreference(sender: AnyObject) {
        Settings.setToOpenAtLogin(true)
        window?.performClose(sender)
    }

}
