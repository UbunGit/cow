Pod::Spec.new do |spec|

  spec.name         = "Magicbox"
  spec.version      = "1.0.0"
  spec.summary      = "ios app 组件"
 
  spec.description  = "ios app 组件"

  spec.homepage     = "http://github/ubungit.git"


  spec.license      = "MIT"
  
  spec.author             = { "michan" => "296019487@qq.com" }
  
  spec.platform     = :ios, "11.0"

  spec.source       = { :git => "http://github/ubungit.git", :tag => "#{spec.version}" }

  spec.source_files  =  "Magicbox/source/**/*.{h,m,swift}"
  
  spec.resources = ['Magicbox/resources/**/*',"Magicbox/source/**/*.{xib}"]

  spec.dependency 'MJRefresh'
  spec.dependency 'YYKit'
  spec.dependency 'MBProgressHUD'
  
  
  spec.prefix_header_contents = <<-EOS


  EOS

end
