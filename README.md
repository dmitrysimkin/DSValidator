# DSValidator
Validation

Features: 
- bla
- ba


## Installation

Framework doesn't contain any external dependencies.

### [Carthage](https://github.com/Carthage/Carthage)

Add this to `Cartfile`
```
github "dmitrysimkin/DSValidator"
```
and then run:
```bash
$ carthage update
```

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)
Add to your `Podfile`
```ruby
pod 'DSValidator'
```
and run:
```bash
$ pod install
```

### Swift package manager
* Go to `File > Swift Packages > Add Package Dependency ...` 
* enter url  `https://github.com/dmitrysimkin/DSValidator.git` 
* select version/branch/commit

### Manually using git submodules
* Add DSValidator as a submodule
```bash
$ git submodule add https://github.com/dmitrysimkin/DSValidator.git
```
* Drag `DSValidator.xcodeproj` into Project Navigator
* Go to `Project > Targets > Build Phases > Link Binary With Libraries`, click `+` and select `DSValidator.framework`

