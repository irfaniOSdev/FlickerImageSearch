//
//  FlickerImageSearchTests.swift
//  FlickerImageSearchTests
//
//  Created by Muhammad Irfan on 06/05/2022.
//

import XCTest
@testable import FlickerImageSearch

class FlickerImageSearchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    
    func testFlickerSearchWithValidText() {
        
        let expct = expectation(description: "Should return non empty response")
        let service = ImageSearchService()
        service.text = "cat"
        service.page = 1
        service.executeRequest { result, _ in
            switch result {
            case .success(let model):
                if model.photos !=  nil {
                    XCTAssert(true, "Success")
                    expct.fulfill()
                }else {
                    XCTFail("No results")
                }
            case .failure(let error):
                XCTFail(error.codeError().description ?? "")
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
        
        let service = ImageSearchService()
        service.text = ""
        service.page = 1
        service.executeRequest { result, _ in
            switch result {
            case .success(let model):
                if model.photos !=  nil {
                    XCTFail(model.stat ?? "")
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
