class FoggyDefaults
  include FoggyConstants

  InitialSettings = {
    activateOnLaunch: NSOffState,
    openAtLogin: NSOnState,
    timer: Forever
  }

  def self.loadDefaults
    InitialSettings.each do |key, value|
      NSUserDefaults[key] = value unless NSUserDefaults[key] != nil
    end
  end
end
