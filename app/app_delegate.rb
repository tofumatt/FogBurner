class AppDelegate
  attr_accessor :status_menu

  def applicationDidFinishLaunching(notification)
    @app_name = NSBundle.mainBundle.infoDictionary['CFBundleDisplayName']

    @status_menu = NSMenu.new
    @status_menu.addItem createMenuItem("About #{@app_name}",
                                        'orderFrontStandardAboutPanel:')
    @status_menu.addItem createMenuItem("Toggle #{@app_name}", 'toggle')
    @status_menu.addItem createMenuItem("Preferences", 'pressAction')
    @status_menu.addItem createMenuItem("Quit", 'terminate')

    image = NSImage.imageNamed "black-outline.png"
    image.setSize(NSMakeSize(20, 20))

    @status_item = NSStatusBar.systemStatusBar
                              .statusItemWithLength(NSVariableStatusItemLength)

    @status_item.setAction('pressAction')
    @status_item.setMenu(@status_menu)
    @status_item.setHighlightMode(true)
    @status_item.setTitle ""
    @status_item.setImage image
  end

  def createMenuItem(name, action)
    NSMenuItem.alloc.initWithTitle(name, action: action, keyEquivalent: '')
  end

  def openPreferences
    # TODO: Implement this.
  end

  def terminate
    @task.terminate if @task
    NSApp.performSelector("terminate:", withObject:nil, afterDelay: 0.0)
  end

  def toggle
    if @task
      @task.terminate
      @task = nil
    else
      @task = NSTask.alloc.init
      @task.setLaunchPath('/usr/bin/caffeinate')
      @task.launch
    end
  end
end
