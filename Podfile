platform :ios, '14.1' # A global platform for the project.
inhibit_all_warnings! # Ignore all warnings from all pods.

target 'Oniony' do
  # Use dynamic frameworks.
  use_frameworks!

  # Pods for Oniony
  # Automation
  pod 'SwiftGen', '6.4.0'
  pod 'SwiftLint', '0.39.2'
  pod 'Swinject', '2.7.1'
end

# Setup podfile to automatically set the deployment target.
post_install do |pi|
    pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.1'
        end
    end
end
