//
//  MenuController
//  Fog Burner
//
//  Created by Matthew Riley MacPherson on 2014-11-12.
//  Copyright (c) 2014 Matthew Riley MacPherson. All rights reserved.
//

//import Cocoa
//import Foundation
//
//class MenuController {
//    var statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
//    var statusMenu = NSMenu()
//    
//    func init() -> NSStatusItem {
//        return createMenu()
//    }
//
//    func createMenu() -> NSStatusItem {
//        statusMenu.addItemWithTitle("About Fog Burner", action: nil, keyEquivalent: "")
//        statusMenu.addItemWithTitle("Preferences", action: nil, keyEquivalent: "")
//        statusMenu.addItem(NSMenuItem.separatorItem())
//        statusMenu.addItemWithTitle("Enable for:", action: nil, keyEquivalent: "")
//        statusMenu.addItem(NSMenuItem.separatorItem())
//        statusMenu.addItemWithTitle("Quit", action: nil, keyEquivalent: "")
//        
//        var image = NSImage(named: "eye-template")
//        image?.setTemplate(true)
//        
//        statusItem.button?.title = "Fog"
//        statusItem.menu = statusMenu
//        statusItem.button?.image = image
//        statusItem.button?.appearsDisabled = true
//        
//        return statusItem
//    }
//}