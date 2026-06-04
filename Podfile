# Uncomment the next line to define a global platform for your project

platform :ios, '16.1'
#inhibit_all_warnings!

#本地包
$ReactNativeEnabled = false;

if $ReactNativeEnabled
  # Resolve react_native_pods.rb with node to allow for hoisting
  require Pod::Executable.execute_command('node', ['-p',
    'require.resolve(
      "react-native/scripts/react_native_pods.rb",
      {paths: [process.argv[1]]},
    )', __dir__]).strip

  prepare_react_native_project!

  linkage = ENV['USE_FRAMEWORKS']
  if linkage != nil
    Pod::UI.puts "Configuring Pod with #{linkage}ally linked Frameworks".green
    use_frameworks! :linkage => linkage.to_sym
  end
end

def debug_tools()
  
  pod 'LookinServer', :configurations => ['Debug']
  
end

def jf_libs()
  
  pod 'QGVAPlayer', :git => 'https://github.com/jumpingfrog0/vap-ios.git'
  
  pod 'JFFoundation', :path => './Libs/JFFoundation'
  
  pod 'JFUIKit', :path => './Libs/JFUIKit'
  pod 'JFUIKit/Hook/UIImageViewDownloadCheck', :path => './Libs/JFUIKit'
  
end

def ios_thirdparty()
  
  pod 'Masonry', '1.1.0'
  pod 'SDWebImage', '5.21.7'

end

target 'ObjcDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
#  use_frameworks!
  
  debug_tools()
  
  ios_thirdparty()
  
  jf_libs()
  
  if $ReactNativeEnabled
    config = use_native_modules!

    use_react_native!(
      :path => config[:reactNativePath],
      # An absolute path to your application root.
      :app_path => "#{Pod::Config.instance.installation_root}/.."
    )

    post_install do |installer|
      react_native_post_install(
        installer,
        config[:reactNativePath],
        :mac_catalyst_enabled => false,
        # :ccache_enabled => true
      )
    end
  end

end

target 'ObjcDemoTests' do

  pod 'JFFoundation', :path => './Libs/JFFoundation'

end
