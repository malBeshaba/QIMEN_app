//
//  SolarTerm.swift
//  QiMen
//
//  Created by 王申宇 on 29/06/2020.
//  Copyright © 2020 王申宇. All rights reserved.
//

import Foundation

/// 节气计算类
class SolarTerm {
    private let D = 0.2422
    private let C_20 =  [6.11, 20.84, 4.6295, 19.4599, 6.3826, 21.4155, 5.59, 20.888, 6.318, 21.86, 6.5, 22.2, 7.928, 23.65, 8.35, 23.95, 8.44, 23.822, 9.098, 24.218, 8.218, 23.08, 7.9, 22.6]
    private let C_21 = [5.4055, 20.12, 3.87, 18.73, 5.63, 20.646, 4.81, 20.1, 5.52, 21.04, 5.678, 21.37, 7.108, 22.83, 7.5, 23.13, 7.646, 23.042, 8.318, 23.438, 7.438, 22.36, 7.18, 21.94]
    private let TERM = ["小寒", "大寒", "立春", "雨水", "惊蛰", "春分", "清明", "谷雨", "立夏", "小满", "芒种", "夏至", "小暑", "大暑", "立秋", "处暑", "白露", "秋分", "寒露", "霜降", "立冬", "小雪", "大雪", "冬至"]
    private var termMap = [Int: [String: String]]()
    
    public func getTermName(year: Int, month: Int, day: Int) -> String {
        let map = getYearTermMap(year: year)
        if map.isEmpty {
            return ""
        }
        return map[getTermKey(month: month, date: day)] ?? ""
    }
    
    public func getYearTermMap(year: Int) -> [String: String] {
        let c = year > 1900 && year <= 2000 ? C_20: C_21    //2100之后的不支持
        let y = year % 100
        var map = [String: String]()
        for i in 0..<24 {
            var date = 0
            if i < 2 || i > 22 {
                date = Int(Double(y) * D + c[i]) - Int((y - 1) / 4)
            } else {
                date = Int(Double(y) * D + c[i]) - Int(y / 4)
            }
            map.updateValue(TERM[i], forKey: getTermKey(month: i / 2 + 1, date: date))
        }
        termMap.updateValue(map, forKey: year)
        
        return map
    }
    
    public func getTermKey(month: Int, date: Int) -> String {
        var key = String(month)
        if month < 10 {
            key = "0" + key
        }
        if date < 10 {
            key += "0"
        }
        key += String(date)
        return key
    }
    
    public func getTermArray(_ year: Int) -> [Date] {
        var arr = [Date]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        if getTermName(year: year, month: 6, day: 21) == "夏至" {
            arr.append(dateFormatter.date(from: "\(year)/6/21")!)
        } else {
            arr.append(dateFormatter.date(from: "\(year)/6/22")!)
        }
        
        if getTermName(year: year, month: 12, day: 21) == "冬至" {
            arr.append(dateFormatter.date(from: "\(year)/12/21")!)
        } else if getTermName(year: year, month: 12, day: 22) == "冬至" {
            arr.append(dateFormatter.date(from: "\(year)/12/22")!)
        } else {
            arr.append(dateFormatter.date(from: "\(year)/12/23")!)
        }
        return arr
    }
}
