# This file is automatically generated. Do not edit.

if Object.const_defined?('TestFlight') and !UIDevice.currentDevice.model.include?('Simulator')
  NSNotificationCenter.defaultCenter.addObserverForName(UIApplicationDidBecomeActiveNotification, object:nil, queue:nil, usingBlock:lambda do |notification|
  TestFlight.takeOff('05027d9118f0430bb7006b10a1ea6ad1_MTI0NTUyMjAxMi0wOC0yMyAxMzozNjoxNy41OTQ4NjU')
  end)
end