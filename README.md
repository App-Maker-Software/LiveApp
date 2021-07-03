# Live App

This repository hosts both the Swift Package and Homebrew CLI for Live App, a server-driven SwiftUI solution powered by [App Maker Professional's](https://appmakerios.com) [SwiftUI Interpreter](https://github.com/App-Maker-Software/BinarySwiftUIInterpreter).

The Swift Package adds less than 1 megabyte to your app footprint.

This is under active development, if you would like to contribute or try a demo, contact Joe Hinkle. 

## Documentation

http://docs.liveapp.cc/

## Installing

http://docs.liveapp.cc/#/installation

Install the `liveapp` CLI with Homebrew.

```
# (optional) brew update
brew install App-Maker-Software/tools/liveapp
```

Add this script as a "Run Script" phase to your build phases in Xcode.

```bash
if ! /usr/bin/liveapp build:bundle ; then
    if ! /usr/local/bin/liveapp build:bundle ; then
        /opt/homebrew/bin/liveapp build:bundle
    fi
fi

```

Then start using the `LiveView` protocol in place of the SwiftUI `View` for any view you want to be updatable remotely.

## Swift Interpreter

The Swift interpreter is in it's own [repo here](https://github.com/App-Maker-Software/SwiftInterpreter).

While the interpreter mainly excels at interpreter declarative-style SwiftUI code, its eventual goal is to be able to run most imperative-style Swift code too. You can quickly see it's support for various Swift features by looking at the test results automatically written to [this markdown file](https://github.com/App-Maker-Software/SwiftInterpreter/blob/main/TEST_RESULTS.md). You can also run these tests locally yourself if you wish.
