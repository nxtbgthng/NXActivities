Pod::Spec.new do |s|
  s.name     = 'NXActivities'
  s.version  = '0.1'
  s.license  = 'BSD'
  s.summary  = 'Provides ready to use UIActivity implementations for several popular webservices like Instapaper and Pocket.'
  s.homepage = 'https://github.com/nxtbgthng/NXActivities'
  s.author   = { 'Thomas Kollbach' => 'toto@nxtbgthng.com' }

  s.source   = { :git => 'https://github.com/nxtbgthng/NXActivities.git', :tag => 'v0.1' }
  s.source_files = 'NXReadLaterActivity.{h,m}',
                   'NXPocketActivity.{h,m}',
                   'NXInstapaperActivity.{h,m}',
                   'NXReadLaterTextInputCell.{h,m}',
                   'NSBundle+NXActivities.{h,m}',
                   'NXReadLaterLoginViewController.{h,m}'
end