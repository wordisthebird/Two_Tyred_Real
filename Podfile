# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'Two Tyred' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Two Tyred
pod 'Firebase'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'SVProgressHUD'
pod 'ChameleonFramework'


pod 'GoogleMaps'
pod 'GooglePlaces'


pod 'SwiftyJSON'
pod 'Alamofire'

# Pods for MapBox
pod 'Mapbox-iOS-SDK', '~> 4.8'
pod 'MapboxNavigation', '~> 0.29.0'

pod 'Stripe/ApplePay'

inhibit_all_warnings!

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
    end
end
