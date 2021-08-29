# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'


def common

  
  pod 'MBProgressHUD'
  pod 'MJRefresh'
  pod 'HandyJSON'
  pod 'SnapKit'
  pod 'Charts'
  pod 'SQLite.swift'
  pod 'Alamofire'
  pod 'IQKeyboardManager'
  pod 'Magicbox', :path=>'./'
end

def debug
  pod 'DoraemonKit/Core', :git => "https://gitee.com/yixiangboy/DoraemonKit.git", :tag => '3.0.2', :configurations => ['Debug'] #必选
  pod 'DoraemonKit/WithLogger', :git => "https://gitee.com/yixiangboy/DoraemonKit.git", :tag => '3.0.2', :configurations => ['Debug'] #可选
#  pod 'DoraemonKit/WithGPS', :git => "https://gitee.com/yixiangboy/DoraemonKit.git", :tag => '3.0.2', :configurations => ['Debug'] #可选
  pod 'DoraemonKit/WithLoad', :git => "https://gitee.com/yixiangboy/DoraemonKit.git", :tag => '3.0.2', :configurations => ['Debug'] #可选
  pod 'DoraemonKit/WithDatabase', :git => "https://gitee.com/yixiangboy/DoraemonKit.git", :tag => '3.0.2', :configurations => ['Debug'] #可选
  pod 'DoraemonKit/WithMLeaksFinder', :git => "https://gitee.com/yixiangboy/DoraemonKit.git", :tag => '3.0.2', :configurations => ['Debug'] #可选
  pod 'DoraemonKit/WithWeex', :git => "https://gitee.com/yixiangboy/DoraemonKit.git", :tag => '3.0.2', :configurations => ['Debug'] #可选
  
end

target 'Cow' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  debug
  common

  
  
end
target 'CowTests' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  debug
  common

  
  
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
