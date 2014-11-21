//
//  AppDelegate.swift
//  Fog Burner
//
//  Created by Matthew Riley MacPherson on 2014-11-12.
//  Copyright (c) 2014 Matthew Riley MacPherson. All rights reserved.
//

import Cocoa

// Obj-C defined constants
let NSLeftMouseUp = 2
let NSRightMouseUp = 4
let NSLeftMouseUpMask = 4
let NSRightMouseUpMask = 16
let NSControlKeyMask = 1 << 18
let NSAlternateKeyMask = 1 << 19

let AppName = "Fog Burner" // NSBundle.mainBundle().objectForInfoDictionaryKey("DisplayName")
let Preferences = Settings.load()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    var menu : NSStatusItem?
    var statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    var statusMenu = NSMenu()
    var enableSubMenu = NSMenu()
    var powerManager = PowerManager()
    var prefsController : AnyObject?
    var prefsWindow : AnyObject?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Get user preferences (this creates them if not already set).
        Preferences.synchronize()
        
        NSLog("App launched")
        
        menu = createMenu()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func activate() -> Void {
        var event = NSApp.currentEvent
        NSLog("activate run")
        
        // If Control or Option key is being held, or it's a right-click, load the menu instead of toggling caffeination.
//        if event?.modifierFlags() & NSControlKeyMask != 0 { // || event.modifierFlags & NSAlternateKeyMask != 0 || event.type == NSRightMouseUp {
//            // openMenu()
//        } else {
//            // toggle()
//        }
    }
    
    func createMenu() -> NSStatusItem {
        statusMenu.addItemWithTitle("About \(AppName)", action: nil, keyEquivalent: "")
        statusMenu.addItemWithTitle("Preferences", action: "openPreferences", keyEquivalent: "")
        statusMenu.addItem(NSMenuItem.separatorItem())
        
        // Handle the "Enable for: [...]" submenu.
        var enableForItem = statusMenu.addItemWithTitle("Enable for:", action: nil, keyEquivalent: "")
        
        enableSubMenu.addItemWithTitle("5 minutes", action: nil, keyEquivalent: "")
        enableSubMenu.addItemWithTitle("15 minutes", action: nil, keyEquivalent: "")
        enableSubMenu.addItemWithTitle("1 hour", action: nil, keyEquivalent: "")
        enableSubMenu.addItemWithTitle("4 hours", action: nil, keyEquivalent: "")
        enableSubMenu.addItemWithTitle("Indefinitely", action: "preventSleep", keyEquivalent: "")
        
        statusMenu.setSubmenu(enableSubMenu, forItem: enableForItem!)
        
        statusMenu.addItem(NSMenuItem.separatorItem())
        statusMenu.addItemWithTitle("Quit", action: "terminate:", keyEquivalent: "")
        
        var image = NSImage(named: "eye-template")
        image?.setTemplate(true)
        
        statusItem.button?.title = "Fog"
        statusItem.menu = statusMenu
        statusItem.button?.image = image
        
        // TODO: Base on whether or not app should start enabled.
        statusItem.button?.appearsDisabled = true
        
        statusItem.button?.sendActionOn(NSLeftMouseUpMask|NSRightMouseUpMask)
        statusItem.button?.action = "activate"
        
        return statusItem
    }
    
    func openPreferences() -> Void {
        NSLog("OPEN PREFS")
        prefsController = PreferencesController.init(windowNibName: "Preferences")
        // prefsController = prefsWindow?.instantiateInitialController() as NSWindowController
        prefsWindow = prefsController?.window
//        prefsController?.showWindow(self)
    }
    
    func preventSleep() -> Void {
        powerManager.preventSleep()
    }
}

