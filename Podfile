# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TravelMaker' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

 pod 'NidThirdPartyLogin'
 pod 'NMapsMap'
 pod 'ImageSlideshow', '~> 1.9.0'
 pod 'FloatingPanel'


  # Pods for TravelMaker

end

post_install do |installer|
  # 1) 공통 빌드 설정 패치
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end

      if target.respond_to?(:product_type) && target.product_type == 'com.apple.product-type.bundle'
        target.build_configurations.each do |config|
          config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
        end
      end
    end
  end

  # 2) Naver Maps SDK bitcode 제거 (존재할 때만 실행)
  #    SDK 배포본에 따라 폴더명이 다를 수 있어 두 경로 모두 체크합니다.
  nmap_candidates = [
    'Pods/NMapsMap/framework/NMapsMap.xcframework/ios-arm64/NMapsMap.framework/NMapsMap',
    'Pods/NMapsMap/framework/NMapsMap.xcframework/ios-arm64_armv7/NMapsMap.framework/NMapsMap'
  ]
  ngeo_candidates = [
    'Pods/NMapsGeometry/framework/NMapsGeometry.xcframework/ios-arm64/NMapsGeometry.framework/NMapsGeometry',
    'Pods/NMapsGeometry/framework/NMapsGeometry.xcframework/ios-arm64_armv7/NMapsGeometry.framework/NMapsGeometry'
  ]

  nmap_path = nmap_candidates.find { |p| File.exist?(p) }
  ngeo_path = ngeo_candidates.find { |p| File.exist?(p) }

  if nmap_path
    system("xcrun --sdk iphoneos bitcode_strip -r #{nmap_path} -o #{nmap_path}")
  end
  if ngeo_path
    system("xcrun --sdk iphoneos bitcode_strip -r #{ngeo_path} -o #{ngeo_path}")
  end
end

