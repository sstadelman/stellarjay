//
//  PositionContaining.swift
//  StellarJay
//
//  Created by Stadelman, Stan on 8/15/18.
//  Copyright © 2018 sstadelman. All rights reserved.
//

import Foundation

protocol PositionContaining {
    associatedtype Coordinates
    var coordinates: Coordinates { get }
}
