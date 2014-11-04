# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Fog Burner'
  app.codesign_for_release = false
  app.copyright = "Copyright © 2014 Matthew Riley MacPherson.\nAll rights reserved."
  app.icon = "app.icns"
  app.identifier = "com.lonelyvegan.fogburner"
  app.info_plist['LSUIElement'] = true
  app.version = "1.0.0-alpha"
end
