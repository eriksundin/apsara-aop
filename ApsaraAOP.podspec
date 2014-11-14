Pod::Spec.new do |s|
  s.name             = "ApsaraAOP"
  s.version          = "0.1.0"
  s.summary          = "Proxy based Aspect Oriented Programming framework for Objective-C"
  s.homepage         = "http://github.com/eriksundin/apsara-aop"
  s.license          = 'MIT'
  s.author           = { "Erik Sundin" => "erik@eriksundin.se" }
  s.source           = { :git => "https://github.com/eriksundin/apsara-aop.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'ApsaraAOP' => ['Pod/Assets/*.png']
  }
end
