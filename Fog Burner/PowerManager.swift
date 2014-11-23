//
//  PowerManager.swift
//  Fog Burner
//
//  Created by Matthew Riley MacPherson on 21/11/2014.
//  Copyright (c) 2014 Matthew Riley MacPherson. All rights reserved.
//

import CoreFoundation
import Foundation
import IOKit.pwr_mgt

// This isn't defined in Swift, so we cheat and do so here.
let kIOPMAssertionTypeNoDisplaySleep = "PreventUserIdleDisplaySleep" as CFString

class PowerManager {

    // Just a random value to prevent release message during first caffeination
    var powerAssertion: IOReturn = -100
    var powerId: IOPMAssertionID = IOPMAssertionID(0)

    func preventSleep(time: NSInteger = 0) {
        if powerAssertion == kIOReturnSuccess {
            NSLog("Sleep already prevented; releasing existing assertion first.")
            releaseSleepAssertion()
        }

        powerAssertion = IOPMAssertionCreateWithName(
            kIOPMAssertionTypeNoDisplaySleep,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            "Keep screen on for set time",
            &powerId
        )

        if powerAssertion == kIOReturnSuccess {
            if time != 0 {
                NSLog("Disable screen sleep for %i minute(s)", time)
            } else {
                NSLog("Disable screen sleep indefinitely")
            }
        }
    }

    func releaseSleepAssertion() {
        NSLog("Enable display sleep")
        IOPMAssertionRelease(powerId)
    }

}
