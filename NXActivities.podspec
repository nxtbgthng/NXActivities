Pod::Spec.new do |s|
  s.platform = :ios, '6.0'
  s.ios.deployment_target = '5.0'
  s.name     = 'NXActivities'
  
  s.version  = '0.1'
  s.license  = 'BSD'
  
  s.summary  = 'Provides ready to use UIActivity implementations for several popular webservices like Instapaper and Pocket.'
  s.homepage = 'https://github.com/nxtbgthng/NXActivities'
  s.author   = { 'Thomas Kollbach' => 'toto@nxtbgthng.com' }
  
  s.dependency 'MBProgressHUD', '0.5'
  
  s.source   = { :git => 'https://github.com/nxtbgthng/NXActivities.git', :tag => '0.1' }
  s.source_files = 'Sources/*.{h,m}'
  
  s.requires_arc = true
  s.framework    = "CoreGraphics"
  s.framework    = "Security"
end