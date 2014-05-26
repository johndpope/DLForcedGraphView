Pod::Spec.new do |s|
  s.name         = "DLForcedGraphView"
  s.version      = "0.1.1"
  s.summary      = "Objective-C implementation of forced graph using SpriteKit."
  s.homepage     = "https://github.com/garnett/DLForcedGraphView"
  s.screenshots  = "https://raw.githubusercontent.com/garnett/DLForcedGraphView/master/img/demo.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Denis Lebedev" => "d2.lebedev@gmail.com" }
  s.social_media_url   = "http://twitter.com/delebedev"
  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.9"
  s.source       = { :git => "https://github.com/garnett/DLForcedGraphView.git", :tag => s.version.to_s }
  s.source_files  = "src/**/*.{h,m}"
  s.framework  = "SpriteKit"
  s.requires_arc = true
end
