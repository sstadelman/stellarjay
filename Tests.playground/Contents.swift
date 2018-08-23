//: A MapKit based Playground

import MapKit
import StellarJay
import PlaygroundSupport

class Delegate: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolygonRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.orange.withAlphaComponent(0.6)
        renderer.lineWidth = 0.5
        renderer.fillColor = UIColor.orange.withAlphaComponent(0.15)
        return renderer
    }
}
let delegate = Delegate()

let url: URL = Bundle.main.url(forResource: "nyc_special_purpose_zoning", withExtension: "geojson")!

var standardCollection: FeatureCollectionStandard!

do {
    let data = try Data(contentsOf: url)
    standardCollection = try JSONDecoder().decode(FeatureCollectionStandard.self, from: data)
}
catch {
    print(error)
}

let nyCoordinates = CLLocationCoordinate2DMake(40.804379624000035, -73.935327719999975)

// Now let's create a MKMapView
let mapView = MKMapView(frame: CGRect(x:0, y:0, width:800, height:800))
mapView.delegate = delegate

// Define a region for our map view
var mapRegion = MKCoordinateRegion()

let mapRegionSpan = 0.04
mapRegion.center = nyCoordinates
mapRegion.span.latitudeDelta = mapRegionSpan
mapRegion.span.longitudeDelta = mapRegionSpan

mapView.setRegion(mapRegion, animated: true)

let polygons: [MKPolygon] = standardCollection.features.compactMap {
    guard let polygon = $0.geometry as? Polygon, let outerPolygonCoords = polygon.coordinates.first else { return nil }
    return MKPolygon(coordinates: outerPolygonCoords, count: outerPolygonCoords.count)
}

mapView.addOverlays(polygons)

// Add the created mapView to our Playground Live View
PlaygroundPage.current.liveView = mapView
