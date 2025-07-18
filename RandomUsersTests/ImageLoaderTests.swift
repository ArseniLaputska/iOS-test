//
//  ImageLoaderTests.swift
//  RandomUsers
//
//  Created by Arseni Laputska on 18.07.25.
//

import XCTest
@testable import RandomUsers

final class ImageLoaderTests: XCTestCase {
    func testCacheStoresImage() {
        let loader = ImageLoader.shared
        guard let url = URL(string: "https://example.com/test.png"),
              let dummy = UIImage(systemName: "person") else {
            XCTFail(); return
        }

        // положим в кэш напрямую
        loader.load(url) { _ in }
        loader.cache.setObject(dummy, forKey: url as NSURL)

        let exp = expectation(description: "load returns cached")
        
        loader.load(url) { img in
            XCTAssertEqual(img?.pngData(), dummy.pngData())
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
}
