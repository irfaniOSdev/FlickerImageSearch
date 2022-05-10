//
//  FlickerImageSearchTests.swift
//  FlickerImageSearchTests
//
//  Created by Muhammad Irfan on 06/05/2022.
//

import XCTest
@testable import FlickerImageSearch

class FlickerImageSearchTests: XCTestCase {

    var sut : ImageSearchService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ImageSearchService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // test if requested URL is matching with specific search text
    func testSearchRequestURL() {
        let text = "car"
        sut.text = text
        sut.page = 1
        let correctURLString = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=a4f28588b57387edc18282228da39744&text=\(text)&per_page=50&page=1&format=json&nojsoncallback=1"
        XCTAssertEqual(sut.absoluteURL, correctURLString)
    }
    
    func testFlickerSearchWithValidText() {
        
        let expct = expectation(description: "Should return non empty response")
        sut.text = "cat"
        sut.page = 1
        sut.executeRequest { result, _ in
            switch result {
            case .success(let model):
                if model.photos !=  nil {
                    XCTAssert(true, "Success")
                    expct.fulfill()
                }else {
                    XCTFail("No results")
                }
            case .failure(let error):
                XCTFail(error.codeError().description ?? Constant.StringConstants.generalErrorMessage)
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testFlickerSearchWithInvalidText() {
        
        let expct = expectation(description: "Returns error message or empty response")
        
        sut.text = ""
        sut.page = 1
        sut.executeRequest { result, _ in
            switch result {
            case .success(let model):
                if model.photos !=  nil {
                    XCTFail(model.stat ?? Constant.StringConstants.generalErrorMessage)
                }else {
                    XCTAssert(true, "Success")
                    expct.fulfill()
                }
            case .failure(let error):
                XCTAssert(true, error.localizedDescription)
                expct.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
}
