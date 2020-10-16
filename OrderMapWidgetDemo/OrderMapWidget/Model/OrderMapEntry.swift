//
//  OrderMapEntry.swift
//  OrderMapWidgetExtension
//
//  Created by wangshoukai3 on 2020/10/16.
//

import Foundation

struct OrderMapEntry {
    let title: String
    let tabs: [OrderTabEntry]
    let shopIcon: String
    let content: String
    let lat: Float
    let lng: Float
}

struct OrderTabEntry {
    let imageIcon: String
    let title: String
}
