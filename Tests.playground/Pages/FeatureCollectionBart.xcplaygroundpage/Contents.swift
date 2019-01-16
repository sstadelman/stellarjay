//: A MapKit based Playground

import MapKit
import StellarJay
import PlaygroundSupport


let sfCoordinates = CLLocationCoordinate2DMake(37.7749, -122.4194)
// Now let's create a MKMapView
let mapView = MKMapView(frame: CGRect(x:0, y:0, width:800, height:800))
let delegate = MKMapViewDelegateImpl()
mapView.delegate = delegate

// Define a region for our map view
var mapRegion = MKCoordinateRegion()
let mapRegionSpan = 0.04
mapRegion.center = sfCoordinates
mapRegion.span.latitudeDelta = mapRegionSpan
mapRegion.span.longitudeDelta = mapRegionSpan
mapView.setRegion(mapRegion, animated: true)


let url: URL = Bundle.main.url(forResource: "bart", withExtension: "geojson")!

var featureCollection: FeatureCollection<Feature<BartData.Line>>!

do {
    let data = try Data(contentsOf: url)
    featureCollection = try JSONDecoder().decode(FeatureCollection<Feature<BartData.Line>>.self, from: data)
}
catch {
    print(error)
}

let polygons: [MKPolygon] = featureCollection.features.reduce(into: Array<MKPolygon>()) { prev, next in
    guard let polygon = next.geometry as? Polygon else { return }
    prev += polygon.coordinates.map {
        return MKPolygon(coordinates: $0, count: $0.count)
    }
}

let polylines: [MKPolyline] = featureCollection.features.reduce(into: Array<MKPolyline>()) { prev, next in
    guard let multiLineString = next.geometry as? MultiLineString else { return }
    prev += multiLineString.toMKPolylines()
}

let pointCoordinates: [CLLocationCoordinate2D] = featureCollection.features.reduce(into: Array<CLLocationCoordinate2D>()) { (prev, next) in
    guard let point = next.geometry as? Point else { return }
    prev += [point.coordinates]
}

public class CustomAnnotation: NSObject, MKAnnotation {
    var _coordinate: CLLocationCoordinate2D
    
    init(_ coordinate: CLLocationCoordinate2D) {
        self._coordinate = coordinate
    }
    
    public var coordinate: CLLocationCoordinate2D {
        return _coordinate
    }
}

let points: [CustomAnnotation] = pointCoordinates.map({ return CustomAnnotation($0) })

mapView.addOverlays(polygons)
mapView.addOverlays(polylines)
mapView.addAnnotations(points)

// Add the created mapView to our Playground Live View
PlaygroundPage.current.liveView = mapView
