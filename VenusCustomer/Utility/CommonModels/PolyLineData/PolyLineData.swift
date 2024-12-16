//
//  PolyLineData.swift
//  VenusCustomer
//
//  Created by Amit on 19/02/24.
//

import Foundation
import CoreLocation
import GoogleMaps

struct DriverPolyData:Codable {

    var overviewPolyline:PolyLinePoint
    var legsData:LegsData

    enum CodingKeys: String, CodingKey {
        case overviewPolyline = "overview_polyline"
        case legsData = "legs"
    }

    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        overviewPolyline = try value.decodeIfPresent(PolyLinePoint.self, forKey: .overviewPolyline) ?? PolyLinePoint()
        legsData = try value.decodeIfPresent(LegsData.self, forKey: .legsData) ?? LegsData()
    }
    init() {
        overviewPolyline = PolyLinePoint()
        legsData = LegsData()
    }
}


struct PolyLinePoint:Codable {

    var points:String

    enum CodingKeys: String, CodingKey {
        case points
    }

    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        points = try value.decodeIfPresent(String.self, forKey: .points) ?? ""
    }

    init() {
        points = ""
    }
}



struct LegsData:Codable {

    var endLocation:CoordinatePoint
    var newEndLocation:CoordinatePoint
    var oldEndLocation:CoordinatePoint
    var startLocation:CoordinatePoint
    var newStartLocation:CoordinatePoint
    var oldStartLocation:CoordinatePoint
    var endAddress:String
    var startAddress:String
    var duration:DurationModel
    var distance:DurationModel
    var driverMarker : GMSMarker = GMSMarker()

    enum CodingKeys: String, CodingKey {
        case endLocation = "end_location"
        case newEndLocation = "newEndLocation"
        case oldEndLocation = "oldEndLocation"
        case startLocation = "start_location"
        case newStartLocation = "newStartLocation"
        case oldStartLocation = "oldStartLocation"
        case endAddress = "end_address"
        case startAddress = "start_address"
        case duration
        case distance
    }

    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        endLocation = try value.decodeIfPresent(CoordinatePoint.self, forKey: .endLocation) ?? CoordinatePoint()
        newEndLocation = try value.decodeIfPresent(CoordinatePoint.self, forKey: .newEndLocation) ?? CoordinatePoint()
        oldEndLocation = try value.decodeIfPresent(CoordinatePoint.self, forKey: .oldEndLocation) ?? CoordinatePoint()
        startLocation = try value.decodeIfPresent(CoordinatePoint.self, forKey: .startLocation) ?? CoordinatePoint()
        newStartLocation = try value.decodeIfPresent(CoordinatePoint.self, forKey: .newStartLocation) ?? CoordinatePoint()
        oldStartLocation = try value.decodeIfPresent(CoordinatePoint.self, forKey: .oldStartLocation) ?? CoordinatePoint()
        endAddress = try value.decodeIfPresent(String.self, forKey: .endAddress) ?? ""
        startAddress = try value.decodeIfPresent(String.self, forKey: .startAddress) ?? ""
        duration = try value.decodeIfPresent(DurationModel.self, forKey: .duration) ?? DurationModel()
        distance = try value.decodeIfPresent(DurationModel.self, forKey: .distance) ?? DurationModel()
    }

    init() {
        endLocation = CoordinatePoint()
        newEndLocation = CoordinatePoint()
        oldEndLocation = CoordinatePoint()
        startLocation = CoordinatePoint()
        newStartLocation = CoordinatePoint()
        oldStartLocation = CoordinatePoint()
        endAddress = ""
        startAddress = ""
        duration = DurationModel()
        distance = DurationModel()
        driverMarker = GMSMarker()
    }
}

struct CoordinatePoint:Codable {

    var coordinates: CLLocationCoordinate2D
    var lat:Double
    var lng:Double

    enum CodingKeys: String, CodingKey {
        case lat
        case lng
    }

    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        lat = try value.decodeIfPresent(Double.self, forKey: .lat) ?? 0.0
        lng = try value.decodeIfPresent(Double.self, forKey: .lng) ?? 0.0
        coordinates = CLLocationCoordinate2D(latitude:lat, longitude: lng)
    }

    init() {
        coordinates = CLLocationCoordinate2D(latitude:0.0, longitude: 0.0)
        lat = 0.0
        lng = 0.0
    }
}

struct DurationModel:Codable {

    var valueData:Double
    var text:String

    enum CodingKeys: String, CodingKey {
        case valueData = "value"
        case text
    }

    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        valueData = try value.decodeIfPresent(Double.self, forKey: .valueData) ?? 0.0
        text = try value.decodeIfPresent(String.self, forKey: .text) ?? ""
    }

    init() {
        valueData = 0.0
        text = ""
    }
}
