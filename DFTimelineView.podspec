
Pod::Spec.new do |s|


  s.name         = "DFTimelineView"
  s.version      = "1.2.9"
  s.summary      = "仿微信朋友圈"

  s.homepage     = "https://github.com/anyunzhong/DFTimelineView"

  s.license      = "Apache 2.0"

  s.author       = { "Fast-Dev-Kit" => "2642754767@qq.com" }

  s.platform     = :ios, "7.0"


  s.source       = { :git => "https://github.com/anyunzhong/DFTimelineView.git", :tag => "1.2.9" }


  s.source_files = "DFTimelineView/DFTimelineView/**/*.{h,m}"

  s.resources = "DFTimelineView/DFTimelineView/Resource/*.png"


  s.requires_arc = true

  s.dependency 'DFCommon', '~> 1.3.7'
  s.dependency 'AFNetworking', '~> 2.6.0'
  s.dependency 'SDWebImage', '~> 3.7.3'
  s.dependency 'FMDB', '~> 2.5'
  s.dependency 'MBProgressHUD', '~> 0.9.1'
  s.dependency 'MLLabel', '~> 1.7'

  s.dependency 'MJRefresh', '~> 2.4.11'
  s.dependency 'ODRefreshControl', '~> 1.2'
  s.dependency 'MJPhotoBrowser', '~> 1.0.2'
  s.dependency 'MMPopupView'
  s.dependency 'TZImagePickerController'

end
