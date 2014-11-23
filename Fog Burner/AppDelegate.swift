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
    // Houses the first run, open at login prompt.
    var firstRunWindow: FirstRunPromptController!
    // About/Prefs/Activate/Quit main menu; activated on ^+click/right-click.
    var mainMenu = NSMenu()
    // The instance of our menu item.
    var menuItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    // An instance of our power manager that disables/enables display sleep.
    var powerManager = PowerManager()
    // Prefs controller.
    var prefsController: PreferencesController!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Get user preferences (this creates them if not already set).
        UserPreferences.synchronize()

        createMenu()

        if UserPreferences.boolForKey("activateOnLaunch") {
            NSLog("Set to activate on launch")
            caffeinate(UserPreferences.integerForKey("timer"))
        }

        // Prompt the user to start Fog Burner at startup, but only the first
        // time the app is launched.
        if !UserPreferences.boolForKey("firstRunComplete") {
            firstRun()
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
            toggleCaffeination()
        }
    }

    // This creates a request (via IOKit) to prevent idle display dimming and
    // idle display sleep. You can check this via `pmset -g`.
    func caffeinate(timerValue: NSInteger) {
        if decafTask != nil {
            decafTask.invalidate()
        }

        var seconds = timerValue * 60

        // If the timerValue is 0, that means "forever". Otherwise make sure at
        // the end of our timeout, we decaffeinate.
        if timerValue != 0 {
            decafTask = NSTimer.scheduledTimerWithTimeInterval(
                NSTimeInterval(seconds), target: self, selector: "decaffeinate",
                userInfo: nil, repeats: false)
        }

        powerManager.preventSleep(time: timerValue)

        caffeinated = true

        if menuItem.button? != nil {
            menuItem.button?.appearsDisabled = false
        } else {
            var image = NSImage(named: "eye-template")
            menuItem.image = image
        }
    }

    // TODO: Do this with tags or whatever; this is awful.
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

    // This programmatically creates the menu item, populates its menu contents,
    // and assigns actions and images to the button itself.
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

        // If we're using Yosemite, we have access to a `button` property
        // automatically instantiated on the `menuItem`; on Mavericks this
        // won't exist and we need to set these properties on the `menuItem`
        // directly.
        if menuItem.button? != nil {
            var image = NSImage(named: "eye-template")
            image?.setTemplate(true)

            menuItem.button?.menu = mainMenu
            menuItem.button?.image = image

            menuItem.button?.appearsDisabled = !UserPreferences.boolForKey("activateOnLaunch")

            menuItem.button?.sendActionOn(NSLeftMouseUpMask|NSRightMouseUpMask)
            menuItem.button?.action = "activateMenuBarItem"
        } else {
            // Mavericks doesn't create the `button` property, so we assign
            // these things directly to our `menuItem` (doing so is deprecated
            // in Yosemite).
            var image:NSImage!
            if UserPreferences.boolForKey("activateOnLaunch") {
                image = NSImage(named: "eye-template")
            } else {
                image = NSImage(named: "eye-template-disabled")
            }

            menuItem.image = image

            menuItem.sendActionOn(NSLeftMouseUpMask|NSRightMouseUpMask)
            menuItem.action = "activateMenuBarItem"
        }
    }

    // This releases our request to prevent the display from sleeping.
    // Running `pmset -g` will show Fog Burner is no longer listed under
    // `displaysleep`.
    func decaffeinate() {
        if decafTask != nil {
            decafTask.invalidate()
        }

        powerManager.releaseSleepAssertion()

        caffeinated = false
        decafTask = nil

        if menuItem.button? != nil {
            menuItem.button?.appearsDisabled = true
        } else {
            var image = NSImage(named: "eye-template-disabled")
        }
    }

    func firstRun() {
        firstRunWindow = FirstRunPromptController(windowNibName: "OpenAtLaunch")
        firstRunWindow.showWindow(self)

        // Bring the app (i.e. this window) to the front.
        NSApplication.sharedApplication().activateIgnoringOtherApps(true)

        UserPreferences.setBool(true, forKey: "firstRunComplete")
    }

    // Open the standard "about" app dialog; maybe we'll spruce this up in the
    // future.
    func openAbout() {
        NSApplication.sharedApplication().orderFrontStandardAboutPanel(nil)
    }

    // Opens the main menu, as clicking on the NSStatusItem (even with a right
    // click action) will send the action to the "activateMenuBarItem" method.
    func openMenu() {
        menuItem.popUpStatusItemMenu(mainMenu)
    }

    // Load the Preferences window.
    func openPreferences() {
        // If a user went for the Preferences window, let's close the "first
        // run" prompt if it's still open.
        if firstRunWindow != nil {
            firstRunWindow.window?.performClose(self)
        }

        // Launch the Preferences controller and bring its window to the front.
        prefsController = PreferencesController(windowNibName: "Preferences")
        prefsController.showWindow(self)

        NSApplication.sharedApplication().activateIgnoringOtherApps(true)
    }

    // Toggle the display sleep prevention, using the user preference for
    // default time to prevent sleep as the caffeination value in minutes.
    func toggleCaffeination() {
        if caffeinated {
            decaffeinate()
        } else {
            caffeinate(UserPreferences.integerForKey("timer"))
        }
    }

}
