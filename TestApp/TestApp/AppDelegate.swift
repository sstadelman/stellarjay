//
//  AppDelegate.swift
//  TestApp
//
//  Created by Stadelman, Stan on 2/26/20.
//  Copyright © 2020 Stadelman, Stan. All rights reserved.
//

import UIKit
import StellarJay
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let url: URL = Bundle.main.url(forResource: "us_state_outlines", withExtension: "geojson")!
        
        //: Use `Decodable` to parse `*.geojson` into `FeatureCollection`
        var featureCollection: FeatureCollection<Feature<us_state_outlines.State>>!

        do {
            let data = try Data(contentsOf: url)
            featureCollection = try JSONDecoder().decode(FeatureCollection<Feature<us_state_outlines.State>>.self, from: data)
            //: Produce `MKOverlay` from the geojson `Geometries`
            let polygons: [MKPolygon] = featureCollection.features.reduce(into: Array<MKPolygon>()) { prev, next in
                guard let polygon = next.geometry as? StellarJay.Polygon else { return }
                prev += polygon.coordinates.map {
                    return MKPolygon(coordinates: $0, count: $0.count)
                }
            }
            print(polygons.count)
        }
        catch {
            print(error)
        }
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

