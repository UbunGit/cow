# Uncomment the next line to define a global platform for your project
#source 'https://github.com/CocoaPods/Specs.git'
#source 'https://github.com/aliyun/aliyun-specs.git'

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

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end
