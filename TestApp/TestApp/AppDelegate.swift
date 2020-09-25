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
        
        let url: URL = Bundle.main.url(forResource: "cb_2018_us_csa_500k", withExtension: "geojson")!
        
        //: Use `Decodable` to parse `*.geojson` into `FeatureCollection`
        var featureCollection: FeatureCollection<Feature<Properties.CSA>>!

        do {
            let data = try Data(contentsOf: url)
            featureCollection = try JSONDecoder().decode(FeatureCollection<Feature<Properties.CSA>>.self, from: data)
            //: Produce `MKOverlay` from the geojson `Geometries`
            let polygons: [MKPolygon] = featureCollection.features.reduce(into: Array<MKPolygon>()) { prev, next in
                switch next.geometry {
                case .some(let g) where g is MultiPolygon:
                    let polygons = (g as! MultiPolygon).coordinates.flatMap({ $0.flatMap({ MKPolygon(coordinates: $0, count: $0.count )})})
                    prev.append(contentsOf: polygons)
                case .some(let g) where g is StellarJay.Polygon:
                    prev += (g as! StellarJay.Polygon).coordinates.map {
                        return MKPolygon(coordinates: $0, count: $0.count)
                    }
                default:
                    print("Could not convert: \(next.properties)")
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

