//
//  ViewController.swift
//  Fog Burner
//
//  Created by Matthew Riley MacPherson on 2014-11-12.
//  Copyright (c) 2014 Matthew Riley MacPherson. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    // UI Elements
    var activateOnLaunch = Preferences.boolForKey("activateOnLaunch")
    var openAtLogin = Preferences.boolForKey("openAtLogin")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }


}

