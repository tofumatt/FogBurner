class AppDelegate
  attr_accessor :statusMenu

  def applicationDidFinishLaunching(notification)
    @app_name = NSBundle.mainBundle.infoDictionary["CFBundleDisplayName"]

    @statusMenu = NSMenu.new
    @statusMenu.addItem createMenuItem("About #{@app_name}",
                                       "orderFrontStandardAboutPanel:")
    @statusMenu.addItem createMenuItem("Toggle #{@app_name}", "toggle")
    @statusMenu.addItem createMenuItem("Preferences", "openPreferences")
    @statusMenu.addItem NSMenuItem.separatorItem
    @statusMenu.addItem createMenuItem("Quit", "terminate")

    image = NSImage.imageNamed "black-outline.png"
    image.setSize(NSMakeSize(20, 20))

    @statusItem = NSStatusBar.systemStatusBar
                             .statusItemWithLength(NSVariableStatusItemLength)

    @statusItem.setHighlightMode(false)
    @statusItem.setTitle(nil)
    @statusItem.setImage(image)

    @statusItem.setAction(:activate)
  end

  def activate
    event = NSApp.currentEvent
    # If Control or Option key is being held, load the preferences.
    if event.modifierFlags & NSControlKeyMask != 0 or
       event.modifierFlags & NSAlternateKeyMask != 0
      openMenu
    else
      toggle
    end
  end

  def createMenuItem(name, action)
    NSMenuItem.alloc.initWithTitle(name, action: action, keyEquivalent: '')
  end

  def openMenu
    @statusItem.setHighlightMode(true)
    @statusItem.popUpStatusItemMenu(@statusMenu)
    @statusItem.setHighlightMode(false)
  end

  # TODO: Implement this.
  # def openPreferences
  #
  # end

  def terminate
    turnOffCaffeinate
    NSApp.performSelector("terminate:", withObject:nil)
  end

  def toggle
    if @caffeinate
      turnOffCaffeinate
    else
      turnOnCaffeinate
    end
  end

  def turnOffCaffeinate
    return unless @caffeinate

    image = NSImage.imageNamed "black-outline.png"
    image.setSize(NSMakeSize(20, 20))

    @statusItem.setImage image

    @caffeinate.terminate
    @caffeinate = nil
  end

  def turnOnCaffeinate
    image = NSImage.imageNamed "black-fill.png"
    image.setSize(NSMakeSize(20, 20))

    @statusItem.setImage image

    @caffeinate = NSTask.new
    @caffeinate.setLaunchPath('/usr/bin/caffeinate')
    @caffeinate.launch
  end
end
