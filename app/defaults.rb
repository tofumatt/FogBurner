class FoggyDefaults
  include FoggyConstants

  InitialSettings = {
    activateOnLaunch: NSOffState,
    firstRunComplete: false,
    openAtLogin: NSOffState,
    timer: Forever
  }

  class << self
    def loadDefaults
      InitialSettings.each do |key, value|
        NSUserDefaults[key] = value unless NSUserDefaults[key] != nil
      end
    end

    def setToOpenAtLogin(enable)
      helperAppUrl = NSBundle.mainBundle.bundleURL.URLByAppendingPathComponent("Contents/Library/LoginItems/FogBurnerHelper.app", isDirectory: true)

      status = LSRegisterURL(helperAppUrl, enable)
      unless status
        NSLog("Failed to LSRegisterURL '%@': %jd", helperAppUrl, status)
      end

      unless SMLoginItemSetEnabled("com.lonelyvegan.fogburnerhelper", enable)
        NSLog "SMLoginItemSetEnabled change to #{enable} failed!"
      end
    end
  end
end
