//
//  QMStartManager.swift
//  QiMen
//
//  Created by 王申宇 on 28/06/2020.
//  Copyright © 2020 王申宇. All rights reserved.
//

import Foundation

class QMGenerator {
    private let data = QMData()

    private let year_datum = 1900
    private let month_datum = 1
    private let day_datum = 31
    private let year_datum_stem = 5
    private let year_datum_branch = 11
    private let day_datum_stem = 0
    private let day_datum_branch = 4
    
    private var year: Int!
    private var month: Int!
    private var day: Int!
    private var hour: Int!
    private var minute: Int!
    
    private var lunar: String!
    private var date: Date!
    private let term = SolarTerm()
    
    var calendar = Calendar.current
    
    init(year: Int, month: Int, day: Int, hour: Int, minute: Int) {
        self.date = addDate(year: year, month: month, day: day, hour: hour, minute: minute)
        self.year = calendar.component(.year, from: date)
        self.month = calendar.component(.month, from: date)
        self.day = calendar.component(.day, from: date)
        self.hour = calendar.component(.hour, from: date)
        self.minute = calendar.component(.minute, from: date)
        //阳历转农历
        self.lunar = TNCalendar.shared().solarToLunar(year, month, day)
    }
    
    public func getLunar() -> String {
        return lunar
    }
    
    /// 排四柱 , 即是把起局时的阳历时间查万年历转换成干支表示方式
    /// - Parameters:
    ///   - year: 公元年
    ///   - month: 月
    ///   - day: 日
    ///   - hour: 时
    ///   - minute: 分
    /// - Returns: 四柱
    func getTime() -> String {
        return getYearColumns() + getMonthColumns() + getDayColumns() + getHourColumns()
    }
    /// 年柱
    /// - Parameter str: 农历 ， 例如：2020年闰四月初八
    /// - Returns: 年柱， 如：庚子
    func getYearColumns() -> String {
        let year = Int(lunar.prefix(4))!
        let p = (year - year_datum) % 60
        let b = (p % 12 + year_datum_branch + 1) % 12
        let s = (p % 10 + year_datum_stem + 1) % 10
        return data.getStem()[s] + data.getBranch()[b]
    }
    /// 月柱
    /// - Parameter str: 农历 ， 例如：2020年闰四月初八
    /// - Returns: 月柱： 如：壬午
    func getMonthColumns() -> String {
        let month = getMonNum(str: String(lunar.suffix(4).prefix(1)))
        let first = getFirstMonth(String(getYearColumns().prefix(1)))
        return data.getStem()[(first + month) % 10] + data.getBranch()[(2 + month) % 12]
    }
    
    /// 日柱
    /// - Returns: 日柱：如：壬午
    func getDayColumns() -> String {
        let days = TNCalendar.shared().dateInterval(startTime: "1900/01/31", endTime: "\(year!)/\(month!)/\(day!)")
        let p = (days - 1) % 60
        let b = (p % 12 + day_datum_branch + 1) % 12
        let s = (p % 10 + day_datum_stem + 1) % 10
        return data.getStem()[s] + data.getBranch()[b]
    }
    
    /// 时柱
    /// - Returns: 时柱：如：壬午
    func getHourColumns() -> String {
        let first = getFirstHour(String(getDayColumns().prefix(1)))
        let hour = Int(self.hour / 2)
        return data.getStem()[(first + hour) % 10] + data.getBranch()[hour]
    }
    
    /// 五虎遁
    /// - Parameter str: 年柱天干
    /// - Returns: 天干序
    func getFirstMonth(_ str: String) -> Int {
        switch str {
        case "甲", "己":
            return 2
        case "乙", "庚":
            return 4
        case "丙", "辛":
            return 6
        case "丁", "壬":
            return 8
        default:
            return 0
        }
    }
    
    /// 获取数字月份
    /// - Parameter str: 汉字月
    /// - Returns: 0...11
    func getMonNum(str: String) -> Int {
        var num = 0
        for s in data.getLanar() {
            if str == s {
                return num
            }
            num += 1
        }
        return -1
    }
    
    
    /// 五鼠遁
    /// - Parameter str: 日柱天干
    /// - Returns: 天干序
    func getFirstHour(_ str: String) -> Int {
        switch str {
        case "甲", "己":
            return 0
        case "乙", "庚":
            return 2
        case "丙", "辛":
            return 4
        case "丁", "壬":
            return 6
        default:
            return 8
        }
    }
    
    /// 23点后为第二天，所以时间加上一小时
    /// - Returns: 更改后Date
    func addDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return (dateFormatter.date(from: "\(year)/\(month)/\(day) \(hour):\(minute)")?.addingTimeInterval(60*60))!
    }
    
    /// Date to String
    /// - Parameters:
    ///   - date: Date
    ///   - dateFormat: 格式
    /// - Returns: 日期字符串
    func date2String(_ date: Date, dateFormat:String = "yyyy-MM-dd HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
    
    /// 定阴阳
    /// - Returns: string
    func getYY() -> String {
        let arr = term.getTermArray(self.year)
        if self.date.compare(arr[0]) == .orderedAscending || self.date.compare(arr[1]) == .orderedDescending {
            return "阳"
        } else {
            return "阴"
        }
    }
    
    /// 定局数
    /// - Returns: int
    func getStep() -> Int {
        let a = data.getBranchDic()[String(getTime().prefix(2).suffix(1))]!
        let b = getMonNum(str: String(lunar.suffix(4).prefix(1)))
        let c = getDateNum()
        let d = data.getBranchDic()[String(getTime().suffix(1))]!
        
        return (a + b + c + d + 3) % 9
    }
    
    /// 计算日期
    /// - Returns: int
    func getDateNum() -> Int {
        let day = String(self.lunar.suffix(2))
        let first = String(day.prefix(1))
        let last = String(day.suffix(1))
        var num = 0
        if first == "初" {
            num += data.getDay()[last]!
        } else if first == "十" {
            num += 10 + data.getDay()[last]!
        } else if first == "廿" {
            num += 20
            if last != "十" {
                num += data.getDay()[last]!
            }
        } else if first == "三" {
            num += 30
            if last != "十" {
                num += data.getDay()[last]!
            }
        }
        
        return num
    }
    
    /// 排地盘
    /// - Returns: 地盘顺序
    func clothEarthSite() -> [String] {
        var dic = [Int: String]()
        var arr = [String]()
        var stem_start = 0 //从戊开始
        var yinStep = 0
        var yangStep = 0
        if getYY() == "阴" {
            yinStep += getStep()
            for _ in 0..<9 {
//                print("g:\(data.getStemWithout1()[stem_start % 9])")
//                print("s:\(data.getSite()[yinStep]!)")
                dic.updateValue(data.getStemWithout1()[stem_start % 9], forKey: data.getSite()[yinStep]!)
                yinStep = yinStep > 1 ? (yinStep - 1): 9
                stem_start += 1
            }
        } else {
            yangStep += getStep()
            for _ in 0..<9 {
                dic.updateValue(data.getStemWithout1()[stem_start % 9], forKey: data.getSite()[yangStep]!)
                yangStep = yangStep < 9 ? (yangStep + 1): 1
                stem_start += 1
            }
        }
        for i in 0..<9 {
            arr.append(dic[i]!)
        }
//        arr[2] += arr[4]
//        arr[4] = ""
        
        return arr
    }
    
    /// 找旬首
    /// - Returns: 甲子戊，甲戌己，甲申庚，甲午辛，甲辰壬，甲寅癸
    func getBeginning() -> String {
        let first = data.getBranchDic()[String(getHourColumns().suffix(1))]!
        let num = data.getStemDic()[String(getHourColumns().prefix(1))]!
        let t = first - num >= 0 ? first - num: first - num + 12
        
        return data.getBeginning()[data.getBranch()[t]]!
    }
    
    /// 值符
    /// - Returns: 九星
    func getDutyStar() -> String {
        return "天\(data.getStar()[getDutyNum()])星"
    }
    
    /// 值使
    /// - Returns: 八门
    func getDutyDoor() -> String {
        return "\(data.getDoor()[getDutyNum()])门"
    }
    
    /// 根据旬首找位置
    /// - Returns: int
    func getDutyNum() -> Int {
        let key = String(getBeginning().suffix(1))
        let arr = clothEarthSite()
        var num = 0
        for i in 0..<arr.count {
            if key == arr[i] {
                num = i
            }
        }
        return num
    }
    
    func isInit(_ a: String, _ b: String) -> Bool {
        if a == b {
            return true
        }
        for i in a {
            if String(i) == b {
                return true
            }
        }
        return false
    }
    
    /// 排天盘天干
    /// - Returns: 九宫
    func clothSkySite() -> [String] {
        var hourColumns = 0
        let hour = String(getHourColumns().prefix(1)) != "甲" ? String(getHourColumns().prefix(1)): String(getBeginning().suffix(1))
        let earth = getRealEarth()
        var sky = getRealEarth()
        for i in 0..<9 {
            if isInit(earth[i], hour) {
                hourColumns = i
                break
            }
        }
       
        let gN: Int = {
            for i in 0..<data.getN().count {
                if hourColumns == data.getN()[i] {
                    return i
                }
                
            }
            return -1
        }()
        let earthB: Int = {
            for i in 0..<data.getN().count {
                if getDutyNum() == data.getN()[i] {
                    return i
                }
            }
            return -1
        }()
        for i in 0..<9 {
            sky[data.getN()[(gN + i) % 8]] = earth[data.getN()[(earthB + i) % 8]]
        }
        return sky
    }
    
    func getRealEarth() -> [String] {
        var arr = clothEarthSite()
        arr[2] += arr[4]
        arr[4] = ""
        return arr
    }
    
    /// 排九星
    /// - Returns: 九宫
    func clothSkySiteStar() -> [String] {
        var hourColumns = 0
        let hour = String(getHourColumns().prefix(1)) != "甲" ? String(getHourColumns().prefix(1)): String(getBeginning().suffix(1))
        let earth = getRealEarth()
        var sky = data.getStar()
        let star = data.getStar()
        for i in 0..<9 {
            if isInit(earth[i], hour)  {
                hourColumns = i
                break
            }
        }
        let gN: Int = {
            for i in 0..<data.getN().count {
                if hourColumns == data.getN()[i] {
                    return i
                }
                
            }
            return -1
        }()
        let earthB: Int = {
            for i in 0..<earth.count {
                if getDutyNum() == data.getN()[i] {
                    return i
                }
            }
            return -1
        }()
        for i in 0..<9 {
            sky[data.getN()[(gN + i) % 8]] = star[data.getN()[(earthB + i) % 8]]
        }
        return sky
    }
    
    /// 排八神
    /// - Returns: 八神为：值符、腾蛇、太阴、六合、白虎、玄武、九地、九天。这里八神顺序一个接一个的顺序是固定不变的。八神排列阳遁顺时针运转，阴遁逆时针运转。
    func clothGodSite() -> [String] {
        var hourColumns = 0
        let hour = String(getHourColumns().prefix(1)) != "甲" ? String(getHourColumns().prefix(1)): String(getBeginning().suffix(1))
        let earth = clothEarthSite()
        for i in 0..<9 {
            if earth[i] == hour {
                hourColumns = i
                break
            }
        }
        var arr = [String]()
        for _ in 0..<9 {
            arr.append("")
        }
        let gN: Int = {
            for i in 0..<data.getN().count {
                if hourColumns == data.getN()[i] {
                    return i
                }
                
            }
            return -1
        }()
        if getYY() == "阳" {
            for i in 0..<8 {
                arr[data.getN()[(gN + i) % 8]] = data.getGod()[i]
            }
        } else {
            for i in 0..<8 {
                arr[data.getN()[(gN - i + 8) % 8]] = data.getGod()[i]
            }
        }
        arr[4] = ""
        return arr
    }
    
    /// 定八门
    /// - Returns: 9宫
    func clothDoorSite() -> [String] {
        var arr = [String]()
        let first = String(getBeginning().suffix(1))
        var hourColumns = 0
        let earth = clothEarthSite()
        for i in 0..<9 {
            if earth[i] == String(getHourColumns().prefix(1)) {
                hourColumns = i
                break
            }
        }
        let gN: Int = {
            for i in 0..<data.getN().count {
                if hourColumns == data.getN()[i] {
                    return i
                }
            }
            return -1
        }()
//      初始化九宫
        for _ in 0..<9 {
            arr.append("")
        }
//      获取旬首在地盘位置
        let n: Int = {
            var t = 0
            for i in clothEarthSite() {
                if i != first {
                    t += 1
                } else {
                    return t
                }
            }
            return -1
        }()
//      寻找时干所落位置
        var site: Int = {
            for i in 1...data.getSite().count {
                if data.getSite()[i] == n {
                    return i
                }
            }
            return -1
        }()
//      时干对应天干序数
        var stemNum: Int = {
            let first = String(getBeginning().prefix(1))
            for i in 0..<data.getStem().count {
                if data.getStem()[i] == first {
                    return i
                }
            }
            return -1
        }()
//      时支对应地支序数
        var branchNum: Int = {
            let first = String(getBeginning().prefix(2).suffix(1))
            for i in 0..<data.getBranch().count {
                if data.getBranch()[i] == first {
                    return i
                }
            }
            return -1
        }()
//      找到时柱对应的宫数
        while getHourColumns() != data.getStem()[stemNum] + data.getBranch()[branchNum] {
            
            stemNum = (stemNum + 1) % 10
            branchNum = (branchNum + 1) % 12
            if getYY() == "阳" {
                
                site = site % 9 + 1
            } else {
                
                site = (site + 8) % 9
            }
            
        }
        if site == 0 {
            site += 1
        }
//      宫数对应的位置
        let t = data.getSite()[site]
//      值使对应的八门序数
        let doorNum: Int = {
            let first = String(getDutyDoor().prefix(1))
            for i in 0..<data.getDorr().count {
                if first == data.getDorr()[i] {
                    return i
                }
            }
            return -1
        }()
//      值使对应的位置
        let m: Int = {
            for i in 0..<data.getN().count {
                if data.getN()[i] == t! {
                    return i
                }
            }
            return -1
        }()
//      放置
        for i in 0..<9 {
            arr[data.getN()[(m + i) % 8]] = data.getDorr()[(doorNum + i) % 8]
        }
        arr[4] = ""
        return arr
    }
    
    /// 排遁干
    /// 时干加在值使门上，然后按照天盘的顺序或者地盘的三奇六仪顺序排列一圈
    /// - Returns: 九宫位置
    func clothHideStem() -> [String] {
        var arr = [String]()
//      初始化九宫
        for _ in 0..<9 {
            arr.append("")
        }
        let first = String(getHourColumns().prefix(1)) != "甲" ? String(getHourColumns().prefix(1)): String(getBeginning().suffix(1))
//      值使门位置
        let dutyDoorNum: Int = {
            for i in 0..<clothDoorSite().count {
                if clothDoorSite()[i] == String(getDutyDoor().prefix(1)) {
                    return i
                }
            }
            return -1
        }()
//      门序数
        let biginNum: Int = {
            if getYY() == "阳" {
                for i in 0..<data.getN().count {
                    if dutyDoorNum == data.getN()[i] {
                        return i
                    }
                }
            } else {
                for i in 0..<data.getT().count {
                    if dutyDoorNum == data.getT()[i] {
                        return i
                    }
                }
            }
            
            return -1
        }()
//      天盘顺序
        let skySite: [String] = {
            var arr = [String]()
            if getYY() == "阳" {
                for i in 0..<8 {
                    arr.append(clothSkySite()[data.getN()[i]])
                }
            } else {
                for i in 0..<8 {
                    arr.append(clothSkySite()[data.getT()[i]])
                }
            }
            return arr
        }()
        
        let firstSite: Int = {
            for i in 0..<skySite.count {
                if isInit(skySite[i], first) {
                    return i
                }
            }
            return -1
        }()
//      放置
        for i in 0..<9 {
            if getYY() == "阳" {
                arr[data.getN()[(biginNum + i) % 8]] = skySite[(firstSite + i) % 8]
            } else {
                arr[data.getT()[(biginNum + i) % 8]] = skySite[(firstSite + i) % 8]
            }
        }
        return arr
    }
    
    /// 空亡
    /// - Returns: 空亡位置
    func getNothing() -> [Int] {
        var arr = [Int]()
        switch String(getBeginning().prefix(2)) {
        case "甲子":
            arr.append(findDizhi("戌"))
            arr.append(findDizhi("亥"))
        case "甲寅":
            arr.append(findDizhi("子"))
            arr.append(findDizhi("丑"))
        case "甲辰":
            arr.append(findDizhi("寅"))
            arr.append(findDizhi("卯"))
        case "甲午":
            arr.append(findDizhi("辰"))
            arr.append(findDizhi("巳"))
        case "甲申":
            arr.append(findDizhi("未"))
            arr.append(findDizhi("午"))
        case "甲戌":
            arr.append(findDizhi("申"))
            arr.append(findDizhi("酉"))
        default:
            break
        }
        return arr
    }
    
    /// 查找宫位
    /// - Parameter diagrams: 卦名
    /// - Returns: 宫位
    func findDiagramsSite(_ diagrams: String) -> Int {
        for i in 0..<data.getDiagrams().count {
            if diagrams == data.getDiagrams()[i] {
                return i
            }
        }
        return -1
    }
    
    /// 查找宫外地支位置
    /// - Parameter dizhi: 地支
    /// - Returns: 宫外位置
    func findDizhi(_ dizhi: String) -> Int {
        for i in 0..<data.getDizhi().count {
            if dizhi == data.getDizhi()[i] {
                return i
            }
        }
        return -1
    }
    
    /// 马星
    /// - Returns: 宫位
    func getHorse() -> Int {
        switch String(getHourColumns().suffix(1)) {
        case "亥","卯","未":
            return findDizhi("巳")
        case "申","子","辰":
            return findDizhi("寅")
        case "寅","午","戌":
            return findDizhi("申")
        case "巳","酉","丑":
            return findDizhi("亥")
        default:
            return -1
        }
    }
    
    /// 病符
    /// - Returns: 九宫外位置
    func getIllSite() -> Int {
        let yearBranch = data.getBranchDic()[String(getYearColumns().suffix(1))]!
        let ill = (yearBranch + 11) % 12
        let illBranch = data.getBranch()[ill]
        
        return findDizhi(illBranch)
    }
    
    /// 孝服
    /// - Returns: 九宫外位置
    func getMourning() -> Int {
        let yearBranch = data.getBranchDic()[String(getYearColumns().suffix(1))]!
        let mourning = (yearBranch + 10) % 12
        let mourningBranch = data.getBranch()[mourning]
        
        return findDizhi(mourningBranch)
    }
    
    /// 口舌官非
    /// - Returns: 九宫外位置
    func getTongue() -> Int {
        let hourBranch = data.getBranchDic()[String(getHourColumns().suffix(1))]!
        let tongue = (hourBranch + 2) % 12
        let tongueBranch = data.getBranch()[tongue]
        
        return findDizhi(tongueBranch)
    }
    
    /// 停灵地
    /// - Returns: 九宫外位置
    func getTranquility() -> Int {
        let yearBranch = data.getBranchDic()[String(getYearColumns().suffix(1))]!
        let t = (yearBranch + 2) % 12
        let tBranch = data.getBranch()[t]
        
        return findDizhi(tBranch)
    }
    
    /// 入墓
    /// - Returns: 按天盘算，丁在艮，丙在乾，乙在坤
    func enterTomb() -> Int {
        let sky = clothSkySite()
        if isInit(sky[6], "丁") { return 6 }
        else if isInit(sky[8], "丙") { return 8 }
        else if isInit(sky[2], "乙") { return 2 }
        return -1
    }
    
    /// 击刑
    /// - Returns: 己二戊三，壬癸四，庚八辛九
    func shot() -> Int {
        let sky = clothSkySite()
        if isInit(sky[data.getSite()[4]!], "壬") || isInit(sky[data.getSite()[4]!], "癸") { return data.getSite()[4]!}
        else if isInit(sky[data.getSite()[3]!], "戊") { return data.getSite()[3]! }
        else if isInit(sky[data.getSite()[2]!], "己") { return data.getSite()[2]! }
        else if isInit(sky[data.getSite()[8]!], "庚") { return data.getSite()[8]! }
        else if isInit(sky[data.getSite()[9]!], "辛") { return data.getSite()[9]! }
        return -1
    }
    
    /// 十二遁形
    /// - Returns: 宫外地支位置
    func getShape() -> [String] {
        var result = data.getDizhi()
        var dizhi = data.getDizhi()
        var first = String(getHourColumns().suffix(1))
        
//        var 
        return result
    }
}
