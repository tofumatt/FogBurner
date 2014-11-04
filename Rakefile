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
  app.copyright = "Copyright © 2014 Matthew Riley MacPherson. All rights reserved."
  app.icon = "icon.icns"
  app.info_plist['LSUIElement'] = true
end
