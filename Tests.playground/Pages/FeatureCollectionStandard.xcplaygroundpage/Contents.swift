//: A MapKit based Playground

import MapKit
import StellarJay
import PlaygroundSupport


let nyCoordinates = CLLocationCoordinate2DMake(40.804379624000035, -73.935327719999975)

// Now let's create a MKMapView
let mapView = MKMapView(frame: CGRect(x:0, y:0, width:640, height:800))
let delegate = MKMapViewDelegateImpl()
mapView.delegate = delegate

// Define a region for our map view
var mapRegion = MKCoordinateRegion()

let mapRegionSpan = 0.04
mapRegion.center = nyCoordinates
mapRegion.span.latitudeDelta = mapRegionSpan
mapRegion.span.longitudeDelta = mapRegionSpan

mapView.setRegion(mapRegion, animated: true)

let camera = MKMapCamera()
    camera.centerCoordinate = mapView.centerCoordinate
    camera.pitch = 80.0
    camera.altitude = 100.0
    camera.heading = 45.0
    mapView.setCamera(camera, animated: true)


let url: URL = Bundle.main.url(forResource: "nyc_special_purpose_zoning", withExtension: "geojson")!













//: Use `Decodable` to parse `*.geojson` into `FeatureCollection`
var standardCollection: FeatureCollectionStandard!

do {
    let data = try Data(contentsOf: url)
    standardCollection = try JSONDecoder().decode(FeatureCollectionStandard.self, from: data)
}
catch {
    print(error)
}

//: Produce `MKOverlay` from the geojson `Geometries`
let polygons: [MKPolygon] = standardCollection.features.reduce(into: Array<MKPolygon>()) { prev, next in
    guard let polygon = next.geometry as? Polygon else { return }
    prev += polygon.coordinates.map {
        return MKPolygon(coordinates: $0, count: $0.count)
    }
}

mapView.addOverlays(polygons)

















// Add the created mapView to our Playground Live View
PlaygroundPage.current.liveView = mapView
