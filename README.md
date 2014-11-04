# Fog Burner

A simple status bar applicatiom for OS X Yosemite that prevents your Mac from
going to sleep or dimming its screen. This is useful if you're on battery
power but want to temporarily keep your screen on without keyboard input.

By default, Fog Burner leaves your screen on until it is disabled, but you can
set a preset or custom amount of time for your Energy Saving settings to resume
as per normal.

## Building

Fog Burner is a [RubyMotion][] app developed on OS X Yosemite (using Ruby 2.1
and RubyMotion 2.37). You'll need Xcode 6.1 installed to compile Fog Burner.
It targets **OS X Yosemite only**.

To get started, you'll need RubyMotion installed. After you check out the repo,
you can run the app easily:

```bash
bundle install
rake
```

And the app will compile and start!

[RubyMotion]: http://www.rubymotion.com/

# License

Eye icon from [Font Awesome by Dave Gandy](http://fontawesome.io/)

---

Copyright (c) 2014 [Matthew Riley MacPherson](http://tofumatt.com).
