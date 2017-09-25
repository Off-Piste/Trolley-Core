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

  s.platform     = :ios, 10.0
  s.source       = { :git => "https://github.com/harrytwright/trolley_core.git", :tag => "#{s.version}" }

  s.module_map = 'TrolleyCore/TrolleyCore.modulemap'

  public_header_files   =   ['TrolleyCore/**/**/TRLURLRequest.h',
                            'TrolleyCore/**/**/TRLURLDataRequest.h',
                            'TrolleyCore/**/**/TRLURLDataTaskDelegate.h',
                            'TrolleyCore/**/**/TRLURLTaskDelegate.h',
                            'TrolleyCore/**/**/TRLURLEncoding.h',
                            'TrolleyCore/**/**/TRLURLParameterEncoding.h',
                            'TrolleyCore/**/**/TRLJSON.h',
                            'TrolleyCore/**/**/TRLJSONBase.h',
                            'TrolleyCore/**/**/TRLMutableJSON.h',
                            'TrolleyCore/**/**/TRLMutableArray.h',
                            'TrolleyCore/**/**/TRLMutableDictionary.h',
                            'TrolleyCore/**/**/Reachability.h',
                            'TrolleyCore/**/**/NSMutableURLRequest+Reqestable.h',
                            'TrolleyCore/**/**/TNTUtils.h',
                            'TrolleyCore/**/**/TRLBlocks.h',
                            'TrolleyCore/**/**/TRLURLSessionManager.h',
                            'TrolleyCore/**/**/NSArray+Map.h',

                            # API Connections Headers
                            'TrolleyCore/**/TRLRequest.h',
                            'TrolleyCore/**/TRLNetworkManager.h',

                            # Core Headers
                            'TrolleyCore/TRLError.h',
                            'TrolleyCore/Trolley.h',
                            'TrolleyCore/Log.h',
                            'TrolleyCore/TrolleyCore.h',

                            #Dynamic Header
                            'TrolleyCore/**/**/TRLJSONBase_Dynamic.h',
                            'TrolleyCore/TRLNetworkManager_Options.h']

  private_header_files =    ['TrolleyCore/**/**/TRLJSONBase_Private.h',

                            # API Connections
                            'TrolleyCore/**/TRLNetwork.h',
                            'TrolleyCore/**/**/TRLNetworkConnection.h',
                            'TrolleyCore/**/**/TRLWebSocketConnection.h',
                            'TrolleyCore/**/**/*_Private.h',
                            'TrolleyCore/**/**/TRLNetworkInfo.h',
                            'TrolleyCore/**/**/TRLParsedURL.h']

  source_files = ['TrolleyCore/**/**/*.{swift, m}']

  s.source_files = source_files + public_header_files
  s.public_header_files = public_header_files

  s.dependency 'PromiseKit'
  s.library = 'icucore'
  s.framework = 'CFNetwork'
  s.framework = 'Security'
  s.framework = 'SystemConfiguration'

end
