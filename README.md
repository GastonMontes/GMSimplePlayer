# GMSimplePlayer
================

[![CI Status](http://img.shields.io/travis/gastonmontes@hotmail.com/GMSimplePlayer.svg?style=flat)](https://travis-ci.org/gastonmontes@hotmail.com/GMSimplePlayer)
[![Version](https://img.shields.io/cocoapods/v/GMSimplePlayer.svg?style=flat)](http://cocoapods.org/pods/GMSimplePlayer)
[![License](https://img.shields.io/cocoapods/l/GMSimplePlayer.svg?style=flat)](http://cocoapods.org/pods/GMSimplePlayer)
[![Platform](https://img.shields.io/cocoapods/p/GMSimplePlayer.svg?style=flat)](http://cocoapods.org/pods/GMSimplePlayer)

## Description

GMSimplePLayer is a customizable view player. 
You can customize It styling via code or via Interface Builder. 
To use It you can create an instance with It's initializer or just add a GMPlayer view to your .xib file.
If you do not want to customize the Player don't worry! The GMPlayer has a basic styling.
You can play a single track or multiples tracks.

You can customize:
- Player tint color (Background).
- Player Bars tint color.
- Player Controls tint colors (Buttons).
- Player controls bar height.
- Player top bar height (Navigation bar).
- Player bar hidden time.
- Player bar hidden animation time.
- Player seek time (fowward and back).
- Player images (play, pause, seek forward, seek back, previous, next, shuffle, loop and slider).
- Player slider image size (If base dot image selected, dot size can be configured).
- Player title font size.
- Player video gravity value.
- Player audio track name label.
- Player audio author label.
- Player title.
- Hide shuffle and loop buttons.
- Hide seeks buttons.

## Example

To run the example project, follow these steps:

- 1 - clone the repo: `git clone https://github.com/GastonMontes/GMSimplePlayer.git`.
- 2 - Change to Example folder: `cd GMSimplePlayer/Example/`.
- 3 - Install pods: `pod install`.
- 4 - Open Workspace: `open GMSimplePlayer.xcworkspace`.

## Requirements

| GMSimplePlayer Version |     Minimum iOS Target      |      Minimum OS X Target     |              Notes               |
|:----------------------:|:---------------------------:|:----------------------------:|:--------------------------------:|
|         1.0.0          |           iOS 11.0           |           OS X 10.12.6       |        Xcode 9 required.         |

## Installation

### 1) Download CocoaPods
-----------------------
[CocoaPods](http://cocoapods.org) is a dependency manager for iOS, which automates and simplifies the process of using 3rd-party libraries in your projects.

CocoaPods is distributed as a ruby gem, and is installed by running the following commands in Terminal.app:

```ruby
$ sudo gem install cocoapods
$ pod setup
```

### 2) Create Podfile
-------------------
In the project root folder, run the following command to create a Podfile:

```ruby
$ pod init
```

If an `YOURXCODEPROJECTFILE` project file is specified or if there is only a single project file in the current directory, targets will be automatically generated based on targets defined in the project.

## 3) Add dependencies:
An empty Podfile was created, so we are going to add dependencies to the Podfile specifying pods versions:

To use the latest version of a Pod, ommit the version specification:
```ruby
pod 'GMSimplePlayer'
```

Freezing to a specific Pod version:
```ruby
pod 'GMSimplePlayer', '1.0.0'
```

Using `logical` operators:
- `'> 0.1'`, Any version higher than 0.1.
- `'>= 0.1'`, Any version higher or equal to 0.1.
- `'< 0.1'`, Any version lower than 0.1.
- `'<= 0.1'`, Any version lower or equal to 0.1.

Using `optimistic` operators:
- `'~> 0.1.0'`, Version 0.1.0 or higher up to 0.2, not including 0.2.
- `'~> 0.1'`, Version 0.1 or higher up to 1.0, not including 1.0.

### 4) Install dependencies
-------------------------
Install Pods dependencies in your project. Run the following commands:

```ruby
$ pod install
```

From now on, be sure to always open the generated Xcode workspace (.xcworkspace) instead of the project file when building your project.

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/GMSimplePlayer). (Tag 'GMSimplePlayer')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/GMSimplePlayer).
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.
- If you **want to contact** the owner of the project, write an email to [Gastón Montes](<mailto:gastonmontes@hotmail.com>).

GMSimplePlayer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GMSimplePlayer'
```

## Author

Gaston Montes, gastonmontes@hotmail.com

## License

GMSimplePlayer is available under the BSD license. See the LICENSE file for more info.
