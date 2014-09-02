Pod::Spec.new do |s|
  s.name         = "RLModules"
  s.version      = "0.1"
  s.summary      = "Collection view modules system"
  s.description  = <<-DESC
                   Builds a layout framework on top of UICollectionView.
                   DESC
  s.homepage     = "https://github.mobiebay.com/nsvpply/RLModules"
  s.license      = { :type => "ebay", :text => "ebay" }
  s.author             = { "Nate Stedman" => "nate@svpply.com" }
  s.social_media_url   = "http://twitter.com/natestedman"
  s.ios.deployment_target = '7.0'
  s.source       = { :git => "git@github.mobiebay.com:nsvpply/RLModules.git", :tag => "0.1" }
  s.source_files  = "RLModules/RLModules"
  s.requires_arc = true
end
