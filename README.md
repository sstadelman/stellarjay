<img src="https://raw.githubusercontent.com/sstadelman/stellarjay/logo/StellarJay.png" width=400/>

# StellarJay
**StellarJay is a helpful framework for parsing GeoJSON content in Swift.**  

## What it does
StellarJay uses Swift `Decodable` protocol and `JSONDecoder` API to parse and marshal [rfc7946 GeoJSON](https://tools.ietf.org/html/rfc7946) objects type-safely, while providing you a Swift generics API to inject custom `Decodeable` types for your service into the graph.  You get a type-safe object graph of your GeoJSON content, including your own unique types.

![](https://raw.githubusercontent.com/sstadelman/stellarjay/logo/Screen%20Shot%202018-08-24%20at%2012.22.43%20AM.png)

## Example
Using [bear_transit.geojson](https://raw.githubusercontent.com/sstadelman/stellarjay/master/StellarJayTests/bear_transit.geojson) as an example, we have a `FeatureCollection` with an array of 4 `Feature`'s.  Each `Feature` has a `Geometry` of type `MultiLineString` (a polyline), and a dictionary of `properties`.  All these types are standard GeoJSON.

### GeoJSON types only
To parse these as standard GeoJSON, use the `JSONDecoder` API to decode the `FeatureCollection`, specifying that the `Feature` will parse the `properties` dictionary as `Dictionary<String, Any>`.

```swift
let bundle = Bundle(for: type(of: self))
let data = try Data(contentsOf: bundle.url(forResource:"bear_transit", withExtension: "geojson")!, options: [])
let routeCollection: FeatureCollectionStandard = try JSONDecoder().decode(FeatureCollectionStandard.self, from: data)
```
To test this in action, see **Tests.playground** in the workspace.

### GeoJSON types + Strongly-typed properties
That's well and good, but it would be much more powerful if we could access the unique content of the `properties` dictionary from our model in a strongly-typed API, instead of navigating nested dictionaries.  To do this, we create a Swift type which implements `Decodable` protocol, which exposes all the properties which we want to access from the `Feature.properties` dictionary.

```swift
struct Route: Decodable {

    private enum CodingKeys: String, CodingKey {
        case name
        case vehicleType = "vehicle_type"
        case color
        case stops = "stops_served_by_route"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)
        self.vehicleType = try values.decode(String.self, forKey: .vehicleType)
        if let hex = try values.decodeIfPresent(String.self, forKey: .color) {
            self.color = UIColor(hexString: hex)
        } else {
            self.color = nil
        }
        self.stops = try values.decode(Array<Dictionary<String, String>>.self, forKey: .stops)
    }
    
    let name: String
    let vehicleType: String
    let color: UIColor?
    let stops: [[String: String]]
}
```

Now, you can use the generic variant of the StellarJay `FeatureCollection` API, passing in your custom type of `Feature`:

```swift
// using same file "bear_transit.geojson" as above
let routeCollection = try JSONDecoder().decode(FeatureCollection<Feature<Route>>.self, from: data)
```

### Results
Both of these `decode(...)` operations return a `FeatureCollection`, with 4 `Feature` items.  But, the `FeatureCollectionStandard`'s features have `let properties: Dictionary<String, Any>`, while the generic typed `FeatureCollection<Feature<Route>>`'s features have `let properties: Route`.

## Use Cases
StellarJay has been used with data from these services:

 - [transit.land](https://transit.land): Super-cool API for accessing transit provider route, stop, and schedule info.  (Stops, Routes)
 - [BetaNYC](http://data.beta.nyc/dataset?res_format=GeoJSON):  Open data platform for NYC (Single-part polygons)
 
> Services listed are simply compatible examples, and do not represent endorsements by the providers ;)

## Limitations & `//TODO:`

 - [ ] support for `GeometryCollection` geometry type
 - [ ] support for bounding box
 - [ ] API improvements
 - [ ] broader support for ["Foreign Members"](https://tools.ietf.org/html/rfc7946#page-15) (beyond `properties`) 
 - [ ] Cocoapods support
 - [ ] per-geometry unit tests

## License
Released under MIT license.  See LICENSE file.

## Support
Please file Issues.
