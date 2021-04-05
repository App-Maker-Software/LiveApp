import XCTest

import liveappTests

var tests = [XCTestCaseEntry]()
tests += liveappTests.allTests()
XCTMain(tests)
