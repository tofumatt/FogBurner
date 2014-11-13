//
//  AppDelegate.swift
//  Fog Burner
//
//  Created by Matthew Riley MacPherson on 2014-11-12.
//  Copyright (c) 2014 Matthew Riley MacPherson. All rights reserved.
//

import Cocoa

let AppName = "Fog Burner" // NSBundle.mainBundle().objectForInfoDictionaryKey("DisplayName")
let Preferences = Settings.load()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var menu : NSStatusItem?
    var statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    var statusMenu = NSMenu()
    var enableSubMenu = NSMenu()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Get user preferences (this creates them if not already set).
        Preferences.synchronize()
        
        menu = createMenu()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func createMenu() -> NSStatusItem {
        statusMenu.addItemWithTitle("About \(AppName)", action: nil, keyEquivalent: "")
        statusMenu.addItemWithTitle("Preferences", action: nil, keyEquivalent: "")
        statusMenu.addItem(NSMenuItem.separatorItem())
        
        // Handle the "Enable for: [...]" submenu.
        var enableForItem = statusMenu.addItemWithTitle("Enable for:", action: nil, keyEquivalent: "")
        
        enableSubMenu.addItemWithTitle("5 minutes", action: nil, keyEquivalent: "")
        enableSubMenu.addItemWithTitle("15 minutes", action: nil, keyEquivalent: "")
        enableSubMenu.addItemWithTitle("1 hour", action: nil, keyEquivalent: "")
        enableSubMenu.addItemWithTitle("4 hours", action: nil, keyEquivalent: "")
        enableSubMenu.addItemWithTitle("Indefinitely", action: nil, keyEquivalent: "")
        
        statusMenu.setSubmenu(enableSubMenu, forItem: enableForItem!)
        
        statusMenu.addItem(NSMenuItem.separatorItem())
        statusMenu.addItemWithTitle("Quit", action: "terminate:", keyEquivalent: "")
        
        var image = NSImage(named: "eye-template")
        image?.setTemplate(true)
        
        statusItem.button?.title = "Fog"
        statusItem.menu = statusMenu
        statusItem.button?.image = image
        statusItem.button?.appearsDisabled = true
        
        return statusItem
    }
}

