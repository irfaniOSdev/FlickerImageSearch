//
//  FlickerImageSearchUITests.swift
//  FlickerImageSearchUITests
//
//  Created by Muhammad Irfan on 06/05/2022.
//

import XCTest

class FlickerImageSearchUITests: XCTestCase {
    
    let app = XCUIApplication() //create app
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSearchBarActions() {
        app.activate()
        let navigationbar = app.navigationBars["Flicker Search"]
        navigationbar.staticTexts["Flicker Search"].tap()
        XCTAssertTrue(app.navigationBars.staticTexts["Flicker Search"].exists)
        let searchBarTap = navigationbar.searchFields["Search here"]
        searchBarTap.tap()
        if searchBarTap.isSelected {
          XCTAssertTrue(searchBarTap.exists)
        }
    }

    func testRecentCollectionViewRowsTap() {
        app.collectionViews.staticTexts["Car"].tap()
        XCTAssertTrue(app.collectionViews.staticTexts["Car"].exists) //check navigation bar title
    }
    
    func testCollectionViewScroll() {
        
        let collectionViewsQuery = XCUIApplication().collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Car"]/*[[".cells.staticTexts[\"Car\"]",".staticTexts[\"Car\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let children = collectionViewsQuery.children(matching: .cell).element(boundBy: 4).children(matching: .other).element.children(matching: .other).element
        children.swipeUp()
        children.swipeDown()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
