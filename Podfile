# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'

target 'Cow' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'MBProgressHUD'
  pod 'MJRefresh'
  pod 'HandyJSON'
  pod 'SnapKit'
  pod 'Charts'
  pod 'SQLite.swift'
  pod 'Alamofire'
  
pod 'Magicbox', :path=>'./'
  

end


##################加入代码##################
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] ='11.0',
      config.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
#      config.build_settings["ONLY_ACTIVE_ARCH"] = "NO"
    end
  end
end
##################加入代码##################
