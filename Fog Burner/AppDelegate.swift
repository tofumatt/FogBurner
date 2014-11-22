//
//  AppDelegate.swift
//  Fog Burner
//
//  Created by Matthew Riley MacPherson on 2014-11-12.
//  Copyright (c) 2014 Matthew Riley MacPherson. All rights reserved.
//

import ObjectiveC
import AppKit
import Cocoa

// Obj-C defined constants
let NSLeftMouseUp = 2
let NSRightMouseUp = 4
let NSLeftMouseUpMask = 4
let NSRightMouseUpMask = 16
let NSControlKeyMask = 1 << 18
let NSAlternateKeyMask = 1 << 19

let AppName = "Fog Burner" // NSBundle.mainBundle().objectForInfoDictionaryKey("DisplayName")
let UserPreferences = Settings.load()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var caffeinated = false // Always initialized to false; if Preferences.boolForKey("activateOnLaunch") is true it's activated on launch
    var decafTask:NSTimer!
    var enableSubMenu = NSMenu()
    var menu: NSStatusItem?
    var powerManager = PowerManager()
    var prefsController: AnyObject?
    var prefsWindow: AnyObject?
    var statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    var statusMenu = NSMenu()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Get user preferences (this creates them if not already set).
        UserPreferences.synchronize()
        
        NSLog("App launched")
        
        menu = createMenu()
        
        if UserPreferences.boolForKey("activateOnLaunch") {
            NSLog("Activating on launch")
            caffeinate(UserPreferences.integerForKey("timer"))
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        if caffeinated {
            decaffeinate()
        }
    }
    
    func activate() {
        var event = NSApplication.sharedApplication().currentEvent?
        
        // If it's a right-click, load the menu instead of toggling caffeination.
        if event?.type == NSEventType.RightMouseUp {
            openMenu()
        } else {
            toggle()
        }
    }
    
    func caffeinate(timerValue: NSInteger) {
        if decafTask != nil {
            decafTask.invalidate()
        }

        var seconds = timerValue * 60

        // If the timerValue is 0, that means "forever". Otherwise make sure at the end of our timeout, we decaffeinate.
        if timerValue != 0 {
            decafTask = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(seconds), target: self, selector: "decaffeinate", userInfo: nil, repeats: false)
        }
        
        powerManager.preventSleep(time: timerValue)
        
        caffeinated = true
        statusItem.button?.appearsDisabled = false
    }
    
    func caffeinateFiveMinutes() {
        caffeinate(5)
    }
    
    func caffeinateFifteenMinutes() {
        caffeinate(15)
    }
    
    func caffeinateThirtyMinutes() {
        caffeinate(30)
    }
    
    func caffeinateOneHour() {
        caffeinate(60)
    }
    
    func caffeinateTwoHours() {
        caffeinate(120)
    }
    
    func caffeinateFourHours() {
        caffeinate(240)
    }
    
    func caffeinateSevenHours() {
        caffeinate(420)
    }
    
    func caffeinateForever() {
        caffeinate(0)
    }
    
    func createMenu() -> NSStatusItem {
        statusMenu.addItemWithTitle("About \(AppName)", action: "openAbout", keyEquivalent: "")
        statusMenu.addItemWithTitle("Preferences", action: "openPreferences", keyEquivalent: "")
        statusMenu.addItem(NSMenuItem.separatorItem())
        
        // Handle the "Enable for: [...]" submenu.
        var enableForItem = statusMenu.addItemWithTitle("Activate", action: nil, keyEquivalent: "")
        
        enableSubMenu.addItemWithTitle("5 minutes", action: "caffeinateFiveMinutes", keyEquivalent: "")
        enableSubMenu.addItemWithTitle("15 minutes", action: "caffeinateFifteenMinutes", keyEquivalent: "")
        enableSubMenu.addItemWithTitle("30 minutes", action: "caffeinateThirtyMinutes", keyEquivalent: "")
        enableSubMenu.addItem(NSMenuItem.separatorItem())
        enableSubMenu.addItemWithTitle("1 hour", action: "caffeinateOneHour", keyEquivalent: "")
        enableSubMenu.addItemWithTitle("2 hours", action: "caffeinateTwoHours", keyEquivalent: "")
        enableSubMenu.addItemWithTitle("4 hours", action: "caffeinateFourHours", keyEquivalent: "")
        enableSubMenu.addItemWithTitle("7 hours", action: "caffeinateSevenHours", keyEquivalent: "")
        enableSubMenu.addItem(NSMenuItem.separatorItem())
        enableSubMenu.addItemWithTitle("Indefinitely", action: "caffeinateForever", keyEquivalent: "")
        
        statusMenu.setSubmenu(enableSubMenu, forItem: enableForItem!)
        
        statusMenu.addItem(NSMenuItem.separatorItem())
        statusMenu.addItemWithTitle("Quit", action: "terminate:", keyEquivalent: "")
        
        var image = NSImage(named: "eye-template")
        image?.setTemplate(true)
        
        statusItem.button?.menu = statusMenu
        statusItem.button?.image = image
        
        // TODO: Base on whether or not app should start enabled.
        statusItem.button?.appearsDisabled = !UserPreferences.boolForKey("activateOnLaunch")
        
        statusItem.button?.sendActionOn(NSLeftMouseUpMask|NSRightMouseUpMask)
        statusItem.button?.action = "activate"
        
        return statusItem
    }
    
    func decaffeinate() {
        if decafTask != nil {
            decafTask.invalidate()
        }

        powerManager.releaseSleepAssertion()
        
        caffeinated = false
        decafTask = nil
        statusItem.button?.appearsDisabled = true
    }
    
    func openAbout() {
        NSApplication.sharedApplication().orderFrontStandardAboutPanel(nil)
    }
    
    func openMenu() {
        statusItem.popUpStatusItemMenu(statusMenu)
    }
    
    func openPreferences() {
        prefsController = PreferencesController(windowNibName: "Preferences")
        prefsWindow = prefsController?.window
        
        NSApp.activateIgnoringOtherApps(true)
    }
    
    func toggle() {
        if caffeinated {
            decaffeinate()
        } else {
            caffeinate(UserPreferences.integerForKey("timer"))
        }
    }
}
