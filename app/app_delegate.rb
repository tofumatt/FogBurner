class AppDelegate
  STATUS_BAR_ICON_SIZE = 16

  def applicationDidFinishLaunching(notification)
    @app_name = NSBundle.mainBundle.infoDictionary["CFBundleDisplayName"]

    @statusMenu = NSMenu.new
    @statusMenu.addItem createMenuItem("About #{@app_name}",
                                       "orderFrontStandardAboutPanel:")
    @statusMenu.addItem createMenuItem("Toggle #{@app_name}", "toggle")
    @statusMenu.addItem createMenuItem("Preferences", "openPreferences")
    @statusMenu.addItem NSMenuItem.separatorItem
    @statusMenu.addItem createMenuItem("Quit", "terminate")

    image = NSImage.imageNamed("eye-template")
    image.setSize(NSMakeSize(STATUS_BAR_ICON_SIZE, STATUS_BAR_ICON_SIZE))
    image.setTemplate(true)

    @statusItem = NSStatusBar.systemStatusBar
                             .statusItemWithLength(NSSquareStatusItemLength)

    @statusItem.button.image = image
    # TODO: Base on whether or not app should start enabled.
    @statusItem.button.appearsDisabled = true

    @statusItem.button
               .sendActionOn(NSLeftMouseUpMask|NSRightMouseUpMask)
    @statusItem.setAction(:activate)
  end

  def activate
    event = NSApp.currentEvent

    # If Control or Option key is being held, or it's a right-click, load the
    # menu instead of toggling caffeination.
    if event.modifierFlags & NSControlKeyMask != 0 or
       event.modifierFlags & NSAlternateKeyMask != 0 or
       event.type == NSRightMouseUp
      openMenu
    else
      toggle
    end
  end

  def caffeinate
    @statusItem.button.appearsDisabled = false

    @caffeinate = NSTask.new
    @caffeinate.setLaunchPath('/usr/bin/caffeinate')
    @caffeinate.launch
  end

  def caffeinated?
    !!@caffeinate
  end

  def createMenuItem(name, action)
    NSMenuItem.alloc.initWithTitle(name, action: action, keyEquivalent: '')
  end

  def decaffeinate
    return unless caffeinated?

    @statusItem.button.appearsDisabled = true

    @caffeinate.terminate
    @caffeinate = nil
  end

  def openMenu
    @statusItem.popUpStatusItemMenu(@statusMenu)
  end

  # TODO: Implement this.
  # def openPreferences
  #
  # end

  def terminate
    # Make sure to disable the `caffeinate` command first; otherwise it will
    # keep running, detached from the app, which is bad.
    decaffeinate()

    # Quit the app.
    NSApp.performSelector("terminate:", withObject:nil)
  end

  def toggle
    if caffeinated?
      decaffeinate()
    else
      caffeinate()
    end
  end
end
