//
//  StandardGeoJSONTests.swift
//  StellarJayTests
//
//  Created by Stadelman, Stan on 8/15/18.
//  Copyright © 2018 sstadelman. All rights reserved.
//
import XCTest
import StellarJay
import os.log


class StandardGeoJSONTests3: XCTestCase {
    
    var featureCollection: FeatureCollectionStandard?
    
    override func setUp() {
        do {
            let bundle = Bundle(for: type(of: self))
            let data = try Data(contentsOf: bundle.url(forResource:"us_state_outlines", withExtension: "geojson")!, options: [])
            let routeCollection = try JSONDecoder().decode(FeatureCollectionStandard.self, from: data)
            self.featureCollection = routeCollection
        }
        catch {
            os_log("Failed to decode FeatureCollection %@", error.localizedDescription)
        }
    }
    
    
    func testType() {
        guard let featureCollection = self.featureCollection else {
            return XCTFail()
        }
        XCTAssertEqual(featureCollection.type, "FeatureCollection")
    }
    
    func testFeatureCount() {
        guard let featureCollection = self.featureCollection else {
            return XCTFail()
        }
        XCTAssertEqual(featureCollection.features.count, 4)
    }
    
    override func tearDown() {
        featureCollection = nil
    }
}

