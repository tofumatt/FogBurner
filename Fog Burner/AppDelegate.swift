//
//  AppDelegate.swift
//  Fog Burner
//
//  Created by Matthew Riley MacPherson on 2014-11-12.
//  Copyright (c) 2014 Matthew Riley MacPherson. All rights reserved.
//

import AppKit
import Cocoa

// Obj-C defined constants
let NSLeftMouseUp = 2
let NSRightMouseUp = 4
let NSLeftMouseUpMask = 4
let NSRightMouseUpMask = 16
let NSControlKeyMask = 1 << 18
let NSAlternateKeyMask = 1 << 19

let AppName = "Fog Burner"
let UserPreferences = Settings.load()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // The "Activate -> [x] minutes/hours" submenu.
    var activateSubMenu = NSMenu()
    // Always initialized to false; if NSUserDefaults("activateOnLaunch")
    // is true it's activated on launch.
    var caffeinated = false
    // Stores the timer that disables caffeination after a set amount of time.
    var decafTask:NSTimer!
    // About/Prefs/Activate/Quit main menu; activated on ^+click/right-click.
    var mainMenu = NSMenu()
    // The instance of our menu item.
    var menuItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    // An instance of our power manager that disables/enables display sleep.
    var powerManager = PowerManager()
    // Prefs controller and window objects.
    var prefsController: PreferencesController!
    var prefsWindow: NSWindow!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Get user preferences (this creates them if not already set).
        UserPreferences.synchronize()

        createMenu()

        if UserPreferences.boolForKey("activateOnLaunch") {
            NSLog("Set to activate on launch")
            caffeinate(UserPreferences.integerForKey("timer"))
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        if caffeinated {
            decaffeinate()
        }
    }

    func activateMenuBarItem() {
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
        menuItem.button?.appearsDisabled = false
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

    func createMenu() {
        mainMenu.addItemWithTitle("About \(AppName)", action: "openAbout", keyEquivalent: "")
        mainMenu.addItemWithTitle("Preferences", action: "openPreferences", keyEquivalent: "")
        mainMenu.addItem(NSMenuItem.separatorItem())

        // Handle the "Enable for: [...]" submenu.
        var activateForItem = mainMenu.addItemWithTitle("Activate", action: nil, keyEquivalent: "")

        activateSubMenu.addItemWithTitle("5 minutes", action: "caffeinateFiveMinutes", keyEquivalent: "")
        activateSubMenu.addItemWithTitle("15 minutes", action: "caffeinateFifteenMinutes", keyEquivalent: "")
        activateSubMenu.addItemWithTitle("30 minutes", action: "caffeinateThirtyMinutes", keyEquivalent: "")
        activateSubMenu.addItem(NSMenuItem.separatorItem())
        activateSubMenu.addItemWithTitle("1 hour", action: "caffeinateOneHour", keyEquivalent: "")
        activateSubMenu.addItemWithTitle("2 hours", action: "caffeinateTwoHours", keyEquivalent: "")
        activateSubMenu.addItemWithTitle("4 hours", action: "caffeinateFourHours", keyEquivalent: "")
        activateSubMenu.addItemWithTitle("7 hours", action: "caffeinateSevenHours", keyEquivalent: "")
        activateSubMenu.addItem(NSMenuItem.separatorItem())
        activateSubMenu.addItemWithTitle("Indefinitely", action: "caffeinateForever", keyEquivalent: "")

        mainMenu.setSubmenu(activateSubMenu, forItem: activateForItem!)

        mainMenu.addItem(NSMenuItem.separatorItem())
        mainMenu.addItemWithTitle("Quit", action: "terminate:", keyEquivalent: "")

        var image = NSImage(named: "eye-template")
        image?.setTemplate(true)

        menuItem.button?.menu = mainMenu
        menuItem.button?.image = image

        menuItem.button?.appearsDisabled = !UserPreferences.boolForKey("activateOnLaunch")

        menuItem.button?.sendActionOn(NSLeftMouseUpMask|NSRightMouseUpMask)
        menuItem.button?.action = "activateMenuBarItem"
    }

    func decaffeinate() {
        if decafTask != nil {
            decafTask.invalidate()
        }

        powerManager.releaseSleepAssertion()

        caffeinated = false
        decafTask = nil
        menuItem.button?.appearsDisabled = true
    }

    func openAbout() {
        NSApplication.sharedApplication().orderFrontStandardAboutPanel(nil)
    }

    func openMenu() {
        menuItem.popUpStatusItemMenu(mainMenu)
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
