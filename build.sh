#!/bin/bash

set -o pipefail
set -e

source_root="$(dirname "$0")"
source="$0"

: ${XCMODE:=xcodebuild}

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




#######################################
#              Interface              #
#######################################


COMMAND="$1"

case "$COMMAND" in
  L)
    sh build.sh swiftlint ;;
  D)
    sh build.sh jazzy ;;
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
  *)
    echo "Unknown command '$COMMAND'"
    usage
    exit 1 ;;

esac
