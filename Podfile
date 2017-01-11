source "https://github.com/CocoaPods/Old-Specs"
platform :osx, '10.6'
pod 'RegexKitLite', '~> 4.0'

target :test,:exclusive => true do

        link_with 'iSpoilerTests'
        pod 'Specta', '0.2.1'
        pod 'Expecta', '~> 0.2.3'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_ENABLE_OBJC_ARC'] = 'NO'
        end
    end
end