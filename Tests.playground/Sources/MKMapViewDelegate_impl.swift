import Foundation
import UIKit
import MapKit

public class MKMapViewDelegateImpl: NSObject, MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolygonRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.orange.withAlphaComponent(0.6)
        renderer.lineWidth = 0.5
        renderer.fillColor = UIColor.orange.withAlphaComponent(0.15)
        return renderer
    }
}
