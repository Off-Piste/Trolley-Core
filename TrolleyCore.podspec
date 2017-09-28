#
#  Be sure to run `pod spec lint TrolleyCore.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "TrolleyCore"
  s.version      = "0.0.2"
  s.summary      = "TrolleyCore is a mobile and web ecommerce system"
  s.description  = <<-DESC
  A very very very very very very short description of TrolleyCore.
  TrolleyCore is a mobile and web ecommerce system.
                   DESC

  s.homepage     = "https://github.com/harrytwright/trolley_core"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "harrytwright" => "haroldtomwright@gmail.com" }

  s.platform     = :ios, 10.3
  s.source       = { :git => "https://github.com/harrytwright/trolley_core.git", :tag => "#{s.version}" }

  s.module_map = 'TrolleyCore/TrolleyCore.modulemap'

  public_header_files   =   'TrolleyCore/Networking/Request/TRLURLRequest.h',
                            'TrolleyCore/Networking/Request/TRLURLDataRequest.h',
                            'TrolleyCore/Networking/Delegation/TRLURLDataTaskDelegate.h',
                            'TrolleyCore/Networking/Delegation/TRLURLTaskDelegate.h',
                            'TrolleyCore/Networking/Encoding/TRLURLEncoding.h',
                            'TrolleyCore/Networking/Encoding/TRLURLParameterEncoding.h',
                            'TrolleyCore/Networking/JSON/TRLJSON.h',
                            'TrolleyCore/Networking/JSON/TRLJSONBase.h',
                            'TrolleyCore/Networking/JSON/TRLMutableJSON.h',
                            'TrolleyCore/Networking/JSON/TRLMutableArray.h',
                            'TrolleyCore/Networking/JSON/TRLMutableDictionary.h',
                            'TrolleyCore/Networking/Reachability/Reachability.h',
                            'TrolleyCore/Networking/Utils/NSMutableURLRequest+Reqestable.h',
                            'TrolleyCore/Networking/Utils/TNTUtils.h',
                            'TrolleyCore/Networking/Utils/TRLBlocks.h',
                            'TrolleyCore/Networking/TRLURLSessionManager.h',
                            'TrolleyCore/Networking/Utils/NSArray+Map.h',

                            # API Connections Headers
                            'TrolleyCore/API Connections/TRLRequest.h',
                            'TrolleyCore/API Connections/TRLNetworkManager.h',

                            # Core Headers
                            'TrolleyCore/TRLError.h',
                            'TrolleyCore/Trolley.h',
                            'TrolleyCore/Log.h',
                            'TrolleyCore/TrolleyCore.h',

                            #Dynamic Header
                            'TrolleyCore/Networking/JSON/TRLJSONBase_Dynamic.h',
                            'TrolleyCore/TRLNetworkManager_Options.h'


  source_files =            'TrolleyCore/{Networking, API Connections}/**/*.{swift, m, h}',
                            'TrolleyCore/*.{swift, m, h}'

  s.source_files = source_files
  s.public_header_files = public_header_files

  # s.dependency 'PromiseKit'
  s.libraries = 'icucore', 'c++'
  s.frameworks = 'CoreFoundation', 'CFNetwork', 'Security', 'SystemConfiguration'

  s.pod_target_xcconfig = {
    'CLANG_ENABLE_MODULES' => 'YES',
    'OTHER_LDFLAGS' => '$(inherited)',
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES'
  }

  s.subspec 'Headers' do |s|
    s.source_files          = public_header_files
    s.public_header_files   = public_header_files
  end

end
