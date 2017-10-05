

# Trolley-Core

[![Build Status](https://travis-ci.org/Off-Piste/Trolley-Core.svg?branch=master)](https://travis-ci.org/Off-Piste/Trolley-Core)
![Languages](https://img.shields.io/badge/languages-Swift%20%7C%20ObjC-orange.svg)

This repository contains the core of our Trolley SDK, with tests and an example application. The Trolley-Core framework is the base for all the [Trolley frameworks](http://trolleyio/docs/ios/specs?spec=all) but is designed so that it can be used by itself if you wish.

The pod provides access to:

* ``Trolley`` - [Syntax Reference](http://)
* ``TRLOptions`` - [Syntax Reference](http://)
* ``TRLDefaultsManager`` - [Syntax Reference](http://)
* ``TRLRequest`` - [Syntax Reference](http://)

The pod also provides very basic access to our ``TRLNetworkingTools``

## Installation

Trolley Core is only available through [CocoaPods](http://cocoapods.org). You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Trolley into your Xcode project using CocoaPods, specify it in your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
  pod 'Trolley'
end
```

Then, run the following command:

```bash
$ pod install
```

## Roadmap

TODO

## Contributing

TODO

## Author

harrytwright, haroldtomwright@gmail.com

## License

TrolleyCore is available under the MIT license. See the LICENSE file for more info.
