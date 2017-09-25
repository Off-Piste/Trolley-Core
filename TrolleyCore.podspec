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

  public_header_files   =   # Networking Headers
                            'TrolleyCore/Networking/**/TRLURLRequest.h',
                            'TrolleyCore/Networking/**/TRLURLDataRequest.h',
                            'TrolleyCore/Networking/**/TRLURLDataTaskDelegate.h',
                            'TrolleyCore/Networking/**/TRLURLTaskDelegate.h',
                            'TrolleyCore/Networking/**/TRLURLEncoding.h',
                            'TrolleyCore/Networking/**/TRLURLParameterEncoding.h',
                            'TrolleyCore/Networking/**/TRLJSON.h',
                            'TrolleyCore/Networking/**/TRLJSONBase.h',
                            'TrolleyCore/Networking/**/TRLMutableJSON.h',
                            'TrolleyCore/Networking/**/TRLMutableArray.h',
                            'TrolleyCore/Networking/**/TRLMutableDictionary.h',
                            'TrolleyCore/Networking/**/Reachability.h',
                            'TrolleyCore/Networking/**/NSMutableURLRequest+Reqestable.h',
                            'TrolleyCore/Networking/**/TNTUtils.h',
                            'TrolleyCore/Networking/**/TRLBlocks.h',

                            # API Connections Headers
                            'TrolleyCore/API Connections/TRLRequest.h',
                            'TrolleyCore/API Connections/TRLNetworkManager.h',

                            # Core Headers
                            'TrolleyCore/**/**/Error.h',
                            'TrolleyCore/**/**/Trolley.h',
                            'TrolleyCore/**/**/Log.h',

                            #Dynamic Header
                            'TrolleyCore/Networking/**/TRLJSONBase_Dynamic.h',
                            'TrolleyCore/TRLNetworkManager_Options.h'

  private_header_files =    # Networking
                            'TrolleyCore/Networking/**/TRLJSONBase_Private.h',

                            # API Connections
                            'TrolleyCore/API Connections/TRLNetwork.h',
                            'TrolleyCore/API Connections/**/TRLNetworkConnection.h',
                            'TrolleyCore/API Connections/**/TRLWebSocketConnection.h',
                            'TrolleyCore/API Connections/**/*_Private.h',
                            'TrolleyCore/API Connections/**/TRLNetworkInfo.h',
                            'TrolleyCore/API Connections/**/TRLParsedURL.h'

  source_files = 'TrolleyCore/**/**/*.{swift, m}'

  s.source_files = source_files + private_header_files
  s.private_header_files = private_header_files
  s.public_header_files = public_header_files

  s.dependency 'PromiseKit'

end
