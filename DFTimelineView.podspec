
Pod::Spec.new do |s|


  s.name         = "DFTimelineView"
  s.version      = "1.2.6"
  s.summary      = "仿微信朋友圈"

  s.homepage     = "https://github.com/anyunzhong/DFTimelineView"

  s.license      = "Apache 2.0"

  s.author       = { "Fast-Dev-Kit" => "2642754767@qq.com" }

  s.platform     = :ios, "7.0"


  s.source       = { :git => "https://github.com/anyunzhong/DFTimelineView.git", :tag => "1.2.6" }


  s.source_files = "DFTimelineView/DFTimelineView/**/*.{h,m}"

  s.resources = "DFTimelineView/DFTimelineView/Resource/*.png"


  s.requires_arc = true

  #s.dependency = 'DFCommon', :git => 'https://github.com/anyunzhong/DFCommon.git', :tag => '1.3.1'

end
