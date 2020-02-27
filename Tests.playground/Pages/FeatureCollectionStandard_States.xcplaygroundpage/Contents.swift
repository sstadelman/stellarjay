//: A MapKit based Playground

import MapKit
import StellarJay
import PlaygroundSupport


let nyCoordinates = CLLocationCoordinate2DMake(40.804379624000035, -73.935327719999975)

// Now let's create a MKMapView
let mapView = MKMapView(frame: CGRect(x:0, y:0, width:800, height:800))
let delegate = MKMapViewDelegateImpl()
mapView.delegate = delegate

// Define a region for our map view
var mapRegion = MKCoordinateRegion()

let mapRegionSpan = 5.0
mapRegion.center = nyCoordinates
mapRegion.span.latitudeDelta = mapRegionSpan
mapRegion.span.longitudeDelta = mapRegionSpan

mapView.setRegion(mapRegion, animated: true)

let url: URL = Bundle.main.url(forResource: "us_state_outlines", withExtension: "geojson")!

//: Use `Decodable` to parse `*.geojson` into `FeatureCollection`
var featureCollection: FeatureCollection<Feature<us_state_outlines.State>>!

do {
    let data = try Data(contentsOf: url)
    featureCollection = try JSONDecoder().decode(FeatureCollection<Feature<us_state_outlines.State>>.self, from: data)
    //: Produce `MKOverlay` from the geojson `Geometries`
    let polygons: [MKPolygon] = featureCollection.features.reduce(into: Array<MKPolygon>()) { prev, next in
        guard let polygon = next.geometry as? Polygon else { return }
        prev += polygon.coordinates.map {
            return MKPolygon(coordinates: $0, count: $0.count)
        }
    }
    mapView.addOverlays(polygons)
}
catch {
    print(error)
}



















// Add the created mapView to our Playground Live View
PlaygroundPage.current.liveView = mapView
