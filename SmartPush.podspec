Pod::Spec.new do |s|
  s.name     = 'SmartPush'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'A APNS push framework for Apple platforms.'
  s.homepage = 'https://github.com/datnm8x/SmartPush'
  s.authors  = { 'Dat Ng' => 'datnm8x@gmail.com' }
  s.source   = { :git => 'https://github.com/datnm8x/SmartPush.git', :tag => s.version }

  s.ios.pod_target_xcconfig = { 'PRODUCT_BUNDLE_IDENTIFIER' => 'datnm8x.com.SmartPush' }
  s.osx.pod_target_xcconfig = { 'PRODUCT_BUNDLE_IDENTIFIER' => 'datnm8x.com.SmartPush' }
  
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  
  s.swift_versions = ['5.3', '5.4', '5.5']

  s.source_files = 'Source/*.swift'
   
  s.subspec 'Core' do |ss|
   ss.source_files = 'Source/Core/*.{h,m}'
  end
end
