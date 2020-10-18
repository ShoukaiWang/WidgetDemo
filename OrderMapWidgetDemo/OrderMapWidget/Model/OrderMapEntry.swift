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


let tabs = [OrderTabEntry(imageIcon: "", title: "代付款"),
            OrderTabEntry(imageIcon: "", title: "代收货"),
            OrderTabEntry(imageIcon: "", title: "代评价"),
            OrderTabEntry(imageIcon: "", title: "退货/售后")]

let orderMapInfo = OrderMapEntry(title: "我的订单", tabs: tabs, shopIcon: "", content: "北京市东城区建国门街道1号", lat: 39.999919, lng: 116.387976)
