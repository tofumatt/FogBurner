//
//  PreferencesController.swift
//  Fog Burner
//
//  Created by Matthew Riley MacPherson on 2014-11-12.
//  Copyright (c) 2014 Matthew Riley MacPherson. All rights reserved.
//

import AppKit
import Cocoa

class PreferencesController: NSWindowController {
    
    // @IBOutlet weak var window: NSWindow!
    
    // UI Elements
    @IBOutlet var activateOnLaunch : NSButton!
    @IBOutlet var openAtLogin : NSButton!
    @IBOutlet var timerDefault : NSPopUpButton!

    override func windowDidLoad() {
        super.windowDidLoad()
        
        activateOnLaunch.state = UserPreferences.boolForKey("activateOnLaunch") ? NSOnState : NSOffState
        openAtLogin.state = UserPreferences.boolForKey("openAtLogin") ? NSOnState : NSOffState
        timerDefault.selectItemWithTag(UserPreferences.integerForKey("timer"))
    }
    
    @IBAction func saveActivateOnLaunchPreference(sender: AnyObject) {
        UserPreferences.setBool(sender.state == NSOnState ? true : false, forKey: "activateOnLaunch")
    }
    
    @IBAction func saveDefaultTimerPreference(sender: AnyObject) {
        UserPreferences.setInteger(sender.selectedTag(), forKey: "timer")
    }
    
    @IBAction func saveOpenAtLoginPreference(sender: AnyObject) {
        Settings.setToOpenAtLogin(sender.state == NSOnState ? true : false)
    }
}
