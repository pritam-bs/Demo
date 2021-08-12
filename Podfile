plugin 'cocoapods-binary'

platform :ios, '11.0'
use_frameworks!
enable_bitcode_for_prebuilt_frameworks!
keep_source_code_for_prebuilt_frameworks!
all_binary!

target 'Demo' do
  post_install do |installer|
    Xcodeproj::Project.open(*Dir.glob('*.xcodeproj')).tap do |project|
      project.targets.each do |target|
        if target.name == "Demo"
          target.build_configurations.each do |config|
            if config.name == "Debug" || config.name == "Stub"
              config.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = "com.mlbd.demo.debug"
              config.build_settings["BUNDLE_DISPLAY_NAME"] = "Demo Debug"
              if config.name == "Stub"
                config.build_settings["OTHER_SWIFT_FLAGS"] = "$(inherited) -D ENV_DEBUG -D API_STUB"
              else
                config.build_settings["OTHER_SWIFT_FLAGS"] = "$(inherited) -D ENV_DEBUG"
              end
            else
              config.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = "com.mlbd.demo"
              config.build_settings["BUNDLE_DISPLAY_NAME"] = "Demo"
              config.build_settings["OTHER_SWIFT_FLAGS"] = "$(inherited) -D ENV_RELEASE"
            end
          end
        end
      end
      project.save
    end
    installer.pods_project.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
    end
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
        config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ""
        config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
        config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
        config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
      end
    end
  end
end
