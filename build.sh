#!/bin/bash

set -o pipefail
set -e

source_root="$(dirname "$0")"
source="$0"

CODESIGN_PARAMS="CODE_SIGN_IDENTITY= CODE_SIGNING_REQUIRED=NO"

usage() {
cat <<EOF
Usage: sh $0 command [argument]
command:
  swiftlint:    Run swiftlint for the swift code
environment variables:
  XCMODE: xcodebuild (default), xcpretty or xctool
  TRL_EXTRA_BUILD_ARGUMENTS: additional arguments to pass to the build tool
  TRL_XCODE_VERSION: the version number of Xcode to use (e.g.: 8.1)
EOF
}

######################################
# Xcode Helpers
######################################

xcode() {
    mkdir -p build/DerivedData
    CMD="xcodebuild -IDECustomDerivedDataLocation=build/DerivedData $@"
    echo "Building with command:" $CMD
    eval "$CMD"
}

build() {
  echo "Hello"
}

pre_install() {
  echo "Uninstalling Cocoapods"
  gem uninstall cocoapods -a --force -x

  echo "Installing Cocoapods"
  gem install cocoapods

  echo "Installing xcpretty"
  gem install xcpretty --no-rdoc --no-ri --no-document --quiet

  echo "Installing xcpretty-travis-formatter"
  gem install xcpretty-travis-formatter --no-rdoc --no-ri --no-document --quiet
}

pre_build_simulator_ios_10() {
  # Workaround for Error 65
    export IOS_SIMULATOR_UDID=`instruments -s devices | grep "iPhone 7 (10.3.1" | awk -F '[ ]' '{print $4}' | awk -F '[\[]' '{print $2}' | sed 's/.$//'`
    echo $IOS_SIMULATOR_UDID
    open -a "simulator" --args -CurrentDeviceUDID $IOS_SIMULATOR_UDID
}

pre_build_simulator_ios_11() {
  # Workaround for Error 65
    export IOS_SIMULATOR_UDID=`instruments -s devices | grep "iPhone 7 (11.0" | awk -F '[ ]' '{print $4}' | awk -F '[\[]' '{print $2}' | sed 's/.$//'`
    echo $IOS_SIMULATOR_UDID
    open -a "simulator" --args -CurrentDeviceUDID $IOS_SIMULATOR_UDID
}

#######################################
#              Swiftlint              #
#######################################

build_swiftlint() {
  if which swiftlint >/dev/null; then
      echo "SwiftLint is installed"
      brew outdated swiftlint || brew upgrade swiftlint
  else
      echo "SwiftLint not installed, downloading via homebrew"
      brew install swiftlint
  fi
}

run_swiftlint() {
  echo "Running SwiftLint"
  swiftlint
}

#######################################
#                Docs                 #
#######################################

build_jazzy() {
  if gem list -i "^jazzy$"; then
    echo "Jazzy is installed"
  else
    gem install jazzy
  fi
}

build_doc() {
  local language="$1"

  if [[ "$language" == "swift" ]]; then
    echo "Building jazzy for Swift"
    swift_jazzy
  else
    echo "Moving Public Headers"
    adjust_for_objc

    echo "Building jazzy for Objective-C"
    echo "Ignore Warnings, downside of workaround..."
    objc_jazzy

    echo "Deleting Public Headers Folder"
    rm -rf headers
  fi
}

adjust_for_objc() {
  if [ -d "headers" ]; then
    rm -rf headers
  fi

  mkdir headers
  cd headers
  mkdir TrolleyCore
  cd -

  cp ./TrolleyCore/Log.h headers/TrolleyCore
  cp ./TrolleyCore/TRLError.h headers/TrolleyCore
  cp ./TrolleyCore/Trolley.h headers/TrolleyCore
  cp ./TrolleyCore/TrolleyCore.h headers/
  cp ./TrolleyCore/Networking/Request/TRLURLRequest.h headers/TrolleyCore
  cp ./TrolleyCore/Networking/Request/TRLURLDataRequest.h headers/TrolleyCore
  cp ./TrolleyCore/Networking/Delegation/TRLURLTaskDelegate.h headers/TrolleyCore
  cp ./TrolleyCore/Networking/Delegation/TRLURLDataTaskDelegate.h headers/TrolleyCore/
  cp ./TrolleyCore/Networking/Encoding/TRLURLEncoding.h headers/TrolleyCore/
  cp ./TrolleyCore/Networking/Encoding/TRLURLParameterEncoding.h headers/TrolleyCore/
  cp ./TrolleyCore/Networking/JSON/TRLJSON.h headers/TrolleyCore/
  cp ./TrolleyCore/Networking/JSON/TRLJSONBase.h headers/TrolleyCore/
  cp ./TrolleyCore/Networking/JSON/TRLMutableJSON.h headers/TrolleyCore/
  cp ./TrolleyCore/Networking/JSON/TRLMutableArray.h headers/TrolleyCore/
  cp ./TrolleyCore/Networking/JSON/TRLMutableDictionary.h headers/TrolleyCore/
  cp ./TrolleyCore/Networking/Reachability/Reachability.h headers/TrolleyCore/
  cp ./TrolleyCore/Networking/Utils/NSArray+Map.h headers/TrolleyCore/
  cp ./TrolleyCore/Networking/Utils/TNTUtils.h headers/TrolleyCore/
  cp ./TrolleyCore/Networking/Utils/TRLBlocks.h headers/TrolleyCore/
  cp ./TrolleyCore/Networking/Utils/NSMutableURLRequest+Reqestable.h headers/TrolleyCore/
  cp ./TrolleyCore/Networking/TRLURLSessionManager.h headers/TrolleyCore/
  cp ./TrolleyCore/API\ Connections/TRLRequest.h headers/TrolleyCore/
  cp ./TrolleyCore/API\ Connections/TRLNetworkManager.h headers/TrolleyCore/
}

swift_jazzy() {
  jazzy \
    --clean \
    --author Trolley \
    --module TrolleyCore \
    --output docs/swift_output \
    --sdk iphonesimulator \
    --no-download-badge
}

objc_jazzy() {
  local xcodebuild_arguments="--objc,headers/TrolleyCore.h,--,-x,objective-c,-isysroot,$(xcrun --show-sdk-path),-I,$(pwd)"

  jazzy \
    --objc \
    --clean \
    --author Trolley \
    --module TrolleyCore \
    --xcodebuild-arguments ${xcodebuild_arguments} \
    --output docs/objc_output \
    --sdk iphonesimulator \
    --no-download-badge
}

#######################################
#              Testing                #
#######################################

 # set -o pipefail && travis_retry xcodebuild test -workspace Example/Trolley.xcworkspace -scheme Trolley-Example -destination 'platform=iOS Simulator,name=iPhone 7,OS=10.3.1' ONLY_ACTIVE_ARCH=NO | xcpretty -f `xcpretty-travis-formatter`

run_tests() {
  local scheme="$1"
  local destination="$2"
  local swift_version="$3"
  local build_args="test -project ./Core.xcodeproj -scheme $scheme $destination ONLY_ACTIVE_ARCH=NO ${CODESIGN_PARAMS} $swift_version | xcpretty -f `xcpretty-travis-formatter` "

  xcode "$build_args"
}

#######################################
#              Interface              #
#######################################


COMMAND="$1"

case "$COMMAND" in
  cocoapod-lint)
    pod spec lint TrolleyCore.podspec --allow-warnings --verbose
    exit 0
    ;;
  lint)
    build_swiftlint
    run_swiftlint
    exit 0
    ;;
  docs)
    build_jazzy
    build_doc swift
    build_doc objc
    exit 0
    ;;
  test-ios-swift3)
    run_tests "App" "-destination 'platform=iOS Simulator,name=iPhone 7,OS=10.3.1'" "SWIFT_VERSION=3.2"
    exit 0
    ;;
  test-ios-swift4)
    run_tests "App" "-destination 'platform=iOS Simulator,name=iPhone 7,OS=11.0'" ""
    exit 0
    ;;
  #######################
  #       Helpers       #
  #######################
  build-test-ios-swift3)
    pre_build_simulator_ios_10
    exit 0
    ;;
  build-test-ios-swift4)
    pre_build_simulator_ios_11
    exit 0
    ;;
  update-xcode)
    pre_install
    exit 0
    ;;
  *)
    echo "Unknown command '$COMMAND'"
    usage
    exit 1 ;;

esac
