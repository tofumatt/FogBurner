module FoggyConstants
  include SugarCube::Timer

  StatusBarIconSize = 16

  FiveMinutes = 1
  FifteenMinutes = 2
  OneHour = 3
  FourHours = 4
  Forever = 0

  PreferencesMap = {
    1 => :activateOnLaunch,
    2 => :openAtLogin
  }

  TimerConstantsMap = {
    FiveMinutes => 5.minutes,
    FifteenMinutes => 15.minutes,
    OneHour => 1.hour,
    FourHours => 4.hours,
    Forever => Forever
  }
end
