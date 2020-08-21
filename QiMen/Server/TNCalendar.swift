//
//  TNCalendar.swift
//  Notice
//
//  Created by 王申宇 on 25/03/2020.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import Foundation

class TNCalendar {
    private static var shareCalendar: TNCalendar = {
        let shared = TNCalendar()
        return shared
    }()

    class func shared() -> TNCalendar {
        return shareCalendar
    }

    private var calendar = Calendar.current

    fileprivate var weekArray: [String]?
    fileprivate var timeArray: [[String]]?
    fileprivate var yearArray: [String]?
    fileprivate var monthArray: [String]?
    fileprivate var year: Int?
    fileprivate var month: Int?
    fileprivate var day: Int?
    fileprivate var currentYear: Int?
    fileprivate var currentMonth: Int?
    fileprivate var currentDay: Int?
    fileprivate var selectYear: Int?
    fileprivate var selectMonth: Int?
    fileprivate let showYearsCount = 100

    // 农历节日
    fileprivate let chineseHoliDay = ["1-1":"春节","1-15":"元宵","5-5":"端午","7-7":"七夕", "7-15":"中元","8-15":"中秋","9-9":"重阳","12-8":"腊八", "12-23":"小年"]
    // 节气
    fileprivate let chineseDays:[String] = ["小寒", "大寒", "立春", "雨水", "惊蛰", "春分", "清明", "谷雨", "立夏", "小满", "芒种", "夏至", "小暑", "大暑", "立秋", "处暑", "白露", "秋分", "寒露", "霜降", "立冬", "小雪", "大雪", "冬至"]

    let gLunarHolDay:[Int32] =   [ 0xA5, 0xB4, 0xA6, 0xA5, 0xA6, 0x96, 0x88, 0x88, 0x78, 0x78, 0x87, 0x87,   //2018
    0xA5, 0xB4, 0x96, 0xA5, 0x96, 0x96, 0x88, 0x78, 0x78, 0x79, 0x77, 0x87,   //2019
    0x95, 0xB4, 0xA5, 0xB4, 0xA5, 0xA6, 0x97, 0x87, 0x87, 0x78, 0x87, 0x86,   //2020
    0xA5, 0xC3, 0xA5, 0xB5, 0xA6, 0xA6, 0x87, 0x88, 0x88, 0x78, 0x87, 0x86,   //2021
    0xA5, 0xB4, 0xA5, 0xA5, 0xA6, 0x96, 0x88, 0x88, 0x88, 0x78, 0x87, 0x87,   //2022
    0xA5, 0xB4, 0x96, 0xA5, 0x96, 0x96, 0x88, 0x78, 0x78, 0x79, 0x77, 0x87,   //2023
    0x95, 0xB4, 0xA5, 0xB4, 0xA5, 0xA6, 0x97, 0x87, 0x87, 0x78, 0x87, 0x96,   //2024
    0xA5, 0xC3, 0xA5, 0xB5, 0xA6, 0xA6, 0x87, 0x88, 0x88, 0x78, 0x87, 0x86,   //2025
    0xA5, 0xB3, 0xA5, 0xA5, 0xA6, 0xA6, 0x88, 0x88, 0x88, 0x78, 0x87, 0x87,   //2026
    0xA5, 0xB4, 0x96, 0xA5, 0x96, 0x96, 0x88, 0x78, 0x78, 0x78, 0x87, 0x87,   //2027
    0x95, 0xB4, 0xA5, 0xB4, 0xA5, 0xA6, 0x97, 0x87, 0x87, 0x78, 0x87, 0x96   //2028
    ]
    let start_year = 2018 // 开始年（节气计算）
    let end_year = 2028 // 结束年（节气计算）

    private init() {
        setDefaultInfo(date: Date())
    }
    
    public func setYear(_ year: Int) {
        self.year = year
    }

    public func getYear() -> Int{
        return self.year ?? -1
    }
    
    public func setMonth(_ month: Int) {
        self.month = month
    }
    
    public func getMonth() -> Int {
        return self.month ?? -1
    }
    
    fileprivate func setDefaultInfo(date: Date) {
        let components = Calendar.current
        year = components.component(.year, from: date)
        month = components.component(.month, from: date)
        day = components.component(.day, from: date)

        selectYear = year
        selectMonth = month
        self.getDatasouce()
    }

    fileprivate func getDatasouce() {
        weekArray = ["日", "一", "二", "三", "四", "五", "六"]
        timeArray = [["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"], ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]]
        let firstYear = year! - showYearsCount/2
        var yearArr = [String]()
        for i in 0..<showYearsCount {
            yearArr.append("\(firstYear+i)")
        }
        yearArray = yearArr
        monthArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    }

    public func setCalender() {
        calendar.locale = Locale(identifier: "zh_CN")
        calendar.timeZone = TimeZone(abbreviation: "EST")!
        calendar.firstWeekday = 1
        calendar.minimumDaysInFirstWeek = 3

    }

    //根据选中日期，获取相应NSDate
    public func getSelectDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: dateComponents)!
    }
    
    public func getSelectDate(_ year: Int, _ month: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: dateComponents)!
    }

    public func getSelectDate(_ year: Int, _ month: Int, _ day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: dateComponents)!
    }
    
    //获取目标月份的天数
    public func numberOfDaysInMonth() -> Int {
        return Calendar.current.range(of: .day, in: .month, for: self.getSelectDate())?.count ?? 0

    }
    
    public func numberOfDaysInMonth(_ year: Int, _ month: Int) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: dateComponents)!
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    public func numberOfDaysInYear(_ year: Int) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: dateComponents)!
        return Calendar.current.range(of: .day, in: .year, for: date)?.count ?? 0
    }

    //获取目标月份第一天星期几
    public func firstDayOfWeekInMonth() -> Int {
        //获取选中日期月份第一天星期几，因为默认日历顺序为“日一二三四五六”，所以这里返回的1对应星期日，2对应星期一，依次类推
        return Calendar.current.ordinality(of: .day, in: .weekOfYear, for: self.getSelectDate())!
    }

    /// 根据公历年、月、日获取对应的农历日期信息
    /// - Parameters:
    ///   - year: Int
    ///   - month: Int
    ///   - day: Int
    func solarToLunar(_ year: Int,_ month: Int,_ day: Int) -> String {
        //初始化公历日历
        let solarCalendar = Calendar.init(identifier: .gregorian)
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        components.minute = 0
        components.second = 0
        components.timeZone = TimeZone.init(secondsFromGMT: 60 * 60 * 8)
        let solarDate = solarCalendar.date(from: components)

        //初始化农历日历
        let lunarCalendar = Calendar.init(identifier: .chinese)
        //日期格式和输出
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateStyle = .medium
        formatter.calendar = lunarCalendar
        return formatter.string(from: solarDate!)
    }

    public func solarToLunar(_ date: Date) -> String {
        //初始化农历日历
        let lunarCalendar = Calendar.init(identifier: .chinese)
        //日期格式和输出
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateStyle = .medium
        formatter.calendar = lunarCalendar
        return formatter.string(from: date)
    }

    /// 判断当天是否是节气，并返回节气名字
    ///
    /// - Parameter date: 日期
    /// - Returns: 返回节气名字 若不是节气则为空
    public func lunarSpecialDate(_ date:Date) -> String? {
        // 公元
        let localeCalendar = Calendar.init(identifier: .gregorian)
        let anchorComponents = localeCalendar.dateComponents([.year, .month, .day], from: date)
        // 获取年月日
        let year = anchorComponents.year!
        let month = anchorComponents.month!
        let day = anchorComponents.day!

        let array_index = (year - start_year) * 12 + month - 1
        let flag = gLunarHolDay[array_index]
        var fDay = 0
        // >> 位预算符 通过右移操作保证数值的最后一个字节存储着需要的数据，并用0xff将值取出来
        if day < 15 {

            fDay = NSDecimalNumber.init(value: 15).subtracting(NSDecimalNumber.init(value: ((flag>>4)&0x0f))).intValue
        } else {
            fDay = NSDecimalNumber.init(value: ((flag)&0x0f)).adding(NSDecimalNumber.init(value: 15)).intValue
        }
        var index = -1
        if fDay == day {
            index = (month - 1) * 2 + (day>15 ? 1: 0)
        }
        if index >= 0 && index < chineseDays.count {
            return chineseDays[index]
        }
        return nil
    }
    /// 获取农历节日
    ///
    /// - Parameter date: 日期
    /// - Returns: 节日 若不是节日则返回空
    public func lunarHoliDayDate(_ date:Date) -> String? {
        let timeInterval_day = Float(60 * 60 * 24)
        /// 获取24 小时后的时间（除夕另外提出放在所有节日的末尾执行，除夕是在春节前一天，即把components当天时间前移一天）
        let nextDay_date = Date.init(timeInterval: TimeInterval(timeInterval_day), since: date)
        /// 创建日历
        let localeCalendar = Calendar.init(identifier: .chinese)
        let anchorComponents = localeCalendar.dateComponents([.day, .month, .year], from: nextDay_date)
        if 1 == anchorComponents.month && 1 == anchorComponents.day {
            return "除夕"
        }
        /// 获取今天的日期
        let localeComp = localeCalendar.dateComponents([.day, .month, .year], from: date)
        /// 拼写日期值
        let key_str = "\(localeComp.month ?? 2)" + "-" + "\(localeComp.day ?? 1)"
        return chineseHoliDay[key_str]
    }

    //MARK:-获取当前时间
    public func getCurrentDate() {
        let components = Calendar.current
        currentYear = components.component(.year, from: Date())
        currentMonth = components.component(.month, from: Date())
        currentDay = components.component(.day, from: Date())
        self.setDefaultInfo(date: Date())
    }
    
    func dateInterval(startTime:String,endTime:String) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        guard let date1 = dateFormatter.date(from: startTime),
              let date2 = dateFormatter.date(from: endTime) else {
            return -1
        }
        let components = Calendar.current.dateComponents([.day], from: date1, to: date2)
        //如果需要返回月份间隔，分钟间隔等等，只需要在dateComponents第一个参数后面加上相应的参数即可，示例如下：
    //    let components = NSCalendar.current.dateComponents([.month,.day,.hour,.minute], from: date1, to: date2)
        return components.day!
    }
    
    func addDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd/hh/tt"
        return (dateFormatter.date(from: "\(year)/\(month)/\(day)/\(hour)/\(minute)")?.addingTimeInterval(60*60))!
    }
}
