# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TravelMaker' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

 pod 'naveridlogin-sdk-ios'
 pod 'NMapsMap'
 pod 'ImageSlideshow', '~> 1.9.0'
 pod 'FloatingPanel'


  # Pods for TravelMaker

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
                if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
                    target.build_configurations.each do |config|
                        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
                    end
                end
            end
        end
    end
end
