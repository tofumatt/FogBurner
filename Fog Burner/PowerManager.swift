//
//  PowerManager.swift
//  Fog Burner
//
//  Created by Matthew Riley MacPherson on 21/11/2014.
//  Copyright (c) 2014 Matthew Riley MacPherson. All rights reserved.
//

import ObjectiveC
import CoreFoundation
import Foundation
import IOKit.pwr_mgt

let kIOPMAssertionTypeNoDisplaySleep = "PreventUserIdleDisplaySleep" as CFString

class PowerManager {
    var powerIDReference : IOPMAssertionID = IOPMAssertionID(0)
    var powerAssertion : IOReturn = 0
    
    func preventSleep(time : NSInteger = 0) -> Void {
        powerAssertion = IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep, IOPMAssertionLevel(kIOPMAssertionLevelOn), "Keep screen on for set time", &powerIDReference)
        
        if powerAssertion == kIOReturnSuccess {
            NSLog("Caffeinate indefinitely")
        }
    }
    
    func releaseSleepAssertion() -> Void {
        IOPMAssertionRelease(powerIDReference)
    }
}
