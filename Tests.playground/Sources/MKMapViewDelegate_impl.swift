import Foundation
import UIKit
import MapKit

public class MKMapViewDelegateImpl: NSObject, MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue.withAlphaComponent(0.6)
            renderer.lineWidth = 2
            return renderer
        } else if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.green.withAlphaComponent(0.6)
            renderer.lineWidth = 1
            renderer.fillColor = UIColor.green.withAlphaComponent(0.15)
            return renderer
        }
        return MKOverlayRenderer()
    }
}
