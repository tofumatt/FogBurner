class AppDelegate
  STATUS_BAR_ICON_SIZE = 16

  FIVE_MINUTES = 300
  FIFTEEN_MINUTES = 900
  ONE_HOUR = 3600
  FOUR_HOURS = 14400

  def applicationDidFinishLaunching(notification)
    @app_name = NSBundle.mainBundle.infoDictionary["CFBundleDisplayName"]

    @statusMenu = NSMenu.new
    @statusMenu.addItem(createMenuItem("About #{@app_name}",
                                       "orderFrontStandardAboutPanel:"))
    @statusMenu.addItem(createMenuItem("Enable", "caffeinate", [
      {name: "5 minutes", action: "caffeinate", tag: FIVE_MINUTES},
      {name: "15 minutes", action: "caffeinate", tag: FIFTEEN_MINUTES},
      {name: "1 hour", action: "caffeinate", tag: ONE_HOUR},
      {name: "4 hours", action: "caffeinate", tag: FOUR_HOURS},
      {name: "Indefinitely", action: "caffeinate"}
    ]))
    @statusMenu.addItem(createMenuItem("Preferences", "openPreferences"))
    @statusMenu.addItem(NSMenuItem.separatorItem)
    @statusMenu.addItem(createMenuItem("Quit", "terminate"))

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

  def caffeinate(sender = nil)
    # Always decaffeinate first; we might be overriding an existing run.
    decaffeinate()

    if sender
      NSLog("Caffeinate for #{sender.tag / 60} minutes")
      @timer = NSTimer.scheduledTimerWithTimeInterval(sender.tag,
        :target => self,
        :selector => "decaffeinate",
        :userInfo => nil,
        :repeats => false
      )
    else
      NSLog("Caffeinate indefinitely")
      timeout = []
    end

    @statusItem.button.appearsDisabled = false

    @caffeinate = NSTask.new
    @caffeinate.setLaunchPath("/usr/bin/caffeinate")
    @caffeinate.launch
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
