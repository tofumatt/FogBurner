class AppDelegate
  include FoggyConstants

  attr_accessor :statusMenu

  def applicationDidFinishLaunching(notification)
    # Load the defaults!
    FoggyDefaults.loadDefaults()

    @app_name = NSBundle.mainBundle.infoDictionary["CFBundleDisplayName"]

    @statusMenu = NSMenu.new
    @statusMenu.addItem(createMenuItem("About #{@app_name}",
                                       "orderFrontStandardAboutPanel:"))
    @statusMenu.addItem(createMenuItem("Preferences", "openPreferences"))
    @statusMenu.addItem(NSMenuItem.separatorItem)
    @statusMenu.addItem(createMenuItem("Enable for:", nil, [
      {name: "5 minutes", action: "caffeinate", tag: FiveMinutes},
      {name: "15 minutes", action: "caffeinate", tag: FifteenMinutes},
      {name: "1 hour", action: "caffeinate", tag: OneHour},
      {name: "4 hours", action: "caffeinate", tag: FourHours},
      {name: "Indefinitely", action: "caffeinate", tag: Forever}
    ]))
    @statusMenu.addItem(NSMenuItem.separatorItem)
    @statusMenu.addItem(createMenuItem("Quit", "terminate"))

    image = NSImage.imageNamed("eye-template")
    image.setSize(NSMakeSize(StatusBarIconSize, StatusBarIconSize))
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
      openMenu()
    else
      toggle()
    end
  end

  def caffeinate(sender = nil, timerValue = nil)
    # Always decaffeinate first; we might be overriding an existing run.
    decaffeinate()

    # If the sender has a tag set, it's the timerValue we should we.
    if sender and sender.tag
      timerValue = sender.tag
    end

    unless timerValue.nil? or timerValue == Forever
      minutesUntilDecaffeination = timeFromConstant(timerValue)
      NSLog("Caffeinate for #{minutesUntilDecaffeination} minutes")
      @timer = after minutesUntilDecaffeination do
        decaffeinate()
      end
    else
      NSLog("Caffeinate indefinitely")
    end

    @statusItem.button.appearsDisabled = false

    @caffeinate = NSTask.new
    @caffeinate.setLaunchPath("/usr/bin/caffeinate")
    @caffeinate.launch()
  end

  def caffeinated?
    !!@caffeinate
  end

  def createMenuItem(name, action, subItems = nil, tag = nil)
    item = NSMenuItem.alloc.initWithTitle(name, action: action,
                                          keyEquivalent: '')
    if tag
      item.tag = tag
    end

    if subItems
      submenu = NSMenu.new
      subItems.each do |i|
        submenu.addItem createMenuItem(i[:name], i[:action], nil, i[:tag])
      end

      item.setSubmenu(submenu)
    end
    item
  end

  def decaffeinate
    return unless caffeinated?

    NSLog("Decaffeinating...")

    @timer.invalidate() if @timer

    @statusItem.button.appearsDisabled = true

    @caffeinate.terminate
    @caffeinate = nil
  end

  def openMenu
    @statusItem.popUpStatusItemMenu(@statusMenu)
  end

  # TODO: Implement this.
  def openPreferences
    @preferencesWindow = PreferencesWindow.alloc.initWithWindowNibName('PreferencesWindow')
    @preferencesWindow.window

    # Bring the app (i.e. the preferences window) to the front.
    NSApp.activateIgnoringOtherApps(true)
  end

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
      # TODO: Caffeinate for default time as set in Preferences.
      caffeinate(nil, NSUserDefaults[:timer])
    end
  end

  def timeFromConstant(constant)
    return TimerConstantsMap[constant] if TimerConstantsMap.has_key?(constant)

    raise Error, "Constant with value #{constant} not recognized."
  end
end
