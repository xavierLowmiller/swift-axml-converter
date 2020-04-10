# Swift AXML Converter

A simple tool to convert Android's binary XML format to regular XML.

## Usage

### CLI

```shell
axml-to-xml path/to/AndroidManifest.xml
```

### Swift

```swift
let axml = Data(contentsOf: urlToAndroidManifestXML)
let xml = try axmlToXml(axml)
```

## Installation

### CLI

The CLI tool is available via homebrew:

```shell
brew install xavierLowmiller/tap/axml-to-xml
```

### Swift Package Manager

1. Add the following to your dependencies in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/xavierLowmiller/swift-axml-converter", from: "1.0.0")
],
```

2. Add the `AXML` target to your target:

```swift
.target(name: "MyTarget", dependencies: ["AXML"]),
```
