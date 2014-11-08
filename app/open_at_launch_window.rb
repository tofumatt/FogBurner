class OpenAtLaunchWindow < NSWindowController
  include FoggyConstants

  extend IB

  outlet :yesButton, NSButton

  def windowDidLoad
    # Bring the window to the front of all windows and focus it.
    window.orderFront(self)
  end

  def yesButtonHandler(sender)
    NSUserDefaults[:openAtLogin] = sender.state == NSOnState ? NSOnState : NSOffState
    FoggyDefaults.setToOpenAtLogin(sender.state == NSOnState ? true : false)

    close()
  end
end
