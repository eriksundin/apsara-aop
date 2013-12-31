Pod::Spec.new do |s|
  s.name         = "ApsaraAOP"
  s.version      = "0.1.0"
  s.summary      = "Proxy based Aspect Oriented Programming framework for Objective-C"
  s.homepage     = "http://github.com/eriksundin/apsara-aop"
  s.license      = 'MIT'
  s.author       = { "Erik Sundin" => "erik@eriksundin.se" }
  s.source       = { :git => "http://EXAMPLE/NAME.git", :tag => s.version.to_s }

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'Classes'
  
  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  
end
