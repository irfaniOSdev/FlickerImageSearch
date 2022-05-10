//
//  FlickerImageDataSourceTests.swift
//  FlickerImageSearchTests
//
//  Created by Muhammad Irfan on 10/05/2022.
//

import XCTest
@testable import FlickerImageSearch
class FlickerImageDataSourceTests: XCTestCase {

    var dataSource: FlickerSearchDataSource!
    var viewModel: FlickerSearchViewModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = FlickerSearchViewModel()
        dataSource = FlickerSearchDataSource(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        dataSource = nil
    }
    
    func loadJsonAndDecode(filename fileName: String) -> [FlickrPhoto]? {
        let bundle = Bundle(for: FlickerImageDataSourceTests.self)
        if let path =  bundle.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let result = try decoder.decode(FlickerSearchResult.self, from: data)
                return result.photos?.photo
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    func testRowsInDataSourceForSearch() {
        
        guard let photos = loadJsonAndDecode(filename: "searchSample") else {             XCTAssert(false, "unable to get data from provided json")
            return
        }
        dataSource?.viewModel?.isSearchBarActive = true
        dataSource?.viewModel?.photos = photos
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), collectionViewLayout: layout)
        collectionView.dataSource = dataSource
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        XCTAssertEqual(dataSource?.numberOfSections(in: collectionView), 1, "Expected one section in table view")
        XCTAssertEqual(dataSource?.collectionView(collectionView, numberOfItemsInSection: 0), photos.count, "Expected cells equal to photos count in collection view")
    }
    
    func testRowsInDataSourceForRecentSearches() {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), collectionViewLayout: layout)
        collectionView.dataSource = dataSource
        XCTAssertEqual(dataSource?.numberOfSections(in: collectionView), 1, "Expected one section in collection view")
        XCTAssertEqual(dataSource?.collectionView(collectionView, numberOfItemsInSection: 0), viewModel.getRecentSearches().count, "Expected cells in collection view for recent searches")
    }
    
    func testEmptyRowsInDataSource() {
        dataSource?.viewModel?.photos = []
        dataSource?.viewModel?.isSearchBarActive = true
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), collectionViewLayout: layout)
        collectionView.dataSource = dataSource
        XCTAssertEqual(dataSource?.numberOfSections(in: collectionView), 1, "Expected one section in collection view")
        XCTAssertEqual(dataSource?.collectionView(collectionView, numberOfItemsInSection: 0), 0, "Expected no cells in collection view")
    }
    
    func testActualPhotoCell() {
        guard let photos = loadJsonAndDecode(filename: "searchSample") else {             XCTAssert(false, "unable to get data from provided json")
            return
        }
        dataSource?.viewModel?.isSearchBarActive = true
        dataSource?.viewModel?.photos = photos
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: UIDevice.current.accessibilityFrame, collectionViewLayout: layout)
        collectionView.dataSource = dataSource
        collectionView.register(nib: FlickerImageCollectionViewCell.nibName)
        let indexPath = IndexPath(row: 0, section: 0)
        guard let _ = dataSource?.collectionView(collectionView, cellForItemAt: indexPath)as? FlickerImageCollectionViewCell else {
            XCTAssert(false, "Expected FlickerImageCollectionViewCell class")
            return
        }
    }
    
    func testRecentSearchCell() {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: UIDevice.current.accessibilityFrame, collectionViewLayout: layout)
        collectionView.dataSource = dataSource
        collectionView.register(nib: RecentSearchCollectionViewCell.nibName)
        let indexPath = IndexPath(row: 0, section: 0)
        guard let _ = dataSource?.collectionView(collectionView, cellForItemAt: indexPath)as? RecentSearchCollectionViewCell else {
            XCTAssert(false, "Expected RecentSearchCollectionViewCell class")
            return
        }
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

}
