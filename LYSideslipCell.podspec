Pod::Spec.new do |s|
s.name         = "LYSideslipCell"
s.version      = "1.1.2"
s.summary      = "A tableViewCell like WeChat"
s.homepage     = "https://github.com/louis-ly/LYSideslipCell"
s.license      = "MIT"
s.frameworks   = "UIKit"
s.platform     = :ios, '6.0'
s.author       = { "louisly" => "396868934@qq.com" }
s.source       = { :git => "https://github.com/louis-ly/LYSideslipCell.git", :tag => s.version }
s.source_files  = 'LYSideslipCell/Classes/*.{h,m}'
s.requires_arc = true
end
