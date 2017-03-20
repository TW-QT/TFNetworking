TFNetworking
==========

![License MIT](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)
![Pod version](https://img.shields.io/cocoapods/v/TFNetworking.svg?style=flat)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform info](https://img.shields.io/cocoapods/p/TFNetworking.svg?style=flat)](http://cocoadocs.org/docsets/TFNetworking)
[![Build Status](https://api.travis-ci.org/Donkey-Tao/TFNetworking.svg?branch=master)](https://travis-ci.org/Donkey-Tao/TFNetworking)

## What

TFNetworking is is a high level request util based on AFNetworking. It's developed by the iOS Team of Dabay. It provides a High Level API for network request.TFNetworking is used in all products of Dabay.



## Features

* Response can be cached by expiration time
* Response can be cached by version number
* Set common base URL and CDN URL
* Validate JSON response
* Resume download
* `block` and `delegate` callback
* URL filter, replace part of URL, or append common parameter 
* Plugin mechanism, handle request start and finish. A plugin for show "Loading" HUD is provided

## Who

TFNetworking is suitable for a slightly more complex project, not for a simple personal project.

TFNetworking is helpful if you want to cache requests, manage the dependences of requests, or validate the JSON response. And if you want to cache requests based on request version, this is one of the greatest advantages of TFNetworking.

## Why 

TFNetworking provides YTKRequest to handle every network request. You should inherit it and override some methods to define custom requests in your project.

The main idea is use the Command Pattern. The benefits are:

 * Your code is decoupled to detail network request framework, it's easy to replace it. Actually, TFNetworking is originally based on ASIHttpRequest, we just spent two days to switch to AFNetworking.
 * Handle common logic in base class.
 * Easier Persistence

But TFNetworking is not suitable if your project is very simple. You can use AFNetworking directly in controller.

## Installation

To use TFNetworking add the following to your Podfile

    pod 'TFNetworking'

Or add this in your Cartfile:

    github "Donkey-Tao/TFNetworking" ~> 0.0.6

## Requirements

TFNetworking is based on AFNetworking. You can find more detail about version compability at [AFNetworking README](https://github.com/AFNetworking/AFNetworking).

## Guide & Demo

 * [Basic Usage Guide](Docs/BasicGuide_en.md)
 * [TFNetworking 2.0 Migration Guide(Simplified Chinese)](Docs/2.0_MigrationGuide_cn.md)

## Contributors

 * [lancy][lancyGithub]


## Acknowledgements

 * [AFNetworking]
 * [AFDownloadRequestOperation]

Thanks for their great work.
 
## License

TFNetworking is available under the MIT license. See the LICENSE file for more info.

<!-- external links -->


