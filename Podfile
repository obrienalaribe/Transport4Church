source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'Transport4Church' do
    pod 'Eureka', '~> 2.0.0-beta.1'
    pod 'ImageRow', '~> 1.0'
#    pod 'PostalAddressRow'
    pod 'GoogleMaps'
    pod 'GooglePlaces'
    pod 'GooglePlacePicker'
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'NVActivityIndicatorView'
    pod 'Parse'
    pod 'Socket.IO-Client-Swift', '~> 8.0.2'
    pod 'BRYXBanner'
end

target 'Transport4ChurchTests' do

end

target 'Transport4ChurchUITests' do

end

#not sure what this does
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

