//
//  QMData.swift
//  QiMen
//
//  Created by 王申宇 on 29/06/2020.
//  Copyright © 2020 王申宇. All rights reserved.
//

import Foundation

class QMData {
    private let Heavenly_Stem = ["甲","乙","丙","丁","戊","己","庚","辛","壬","癸"]
    private let Earthly_branch = ["子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥"]
    private let lanar_month = ["正","二","三","四","五","六","七","八","九","十","冬","腊"]
    private let diagrams = ["巽","离","坤",
                            "震","","兑",
                            "艮","坎","乾"]
    private let site = [4: 0, 9: 1, 2: 2,
                        3: 3, 5: 4, 7: 5,
                        8: 6, 1: 7, 6: 8]
    private let n = [0, 1, 2, 5, 8, 7, 6, 3]
    private let t = [0, 3, 6, 7, 8, 5, 2, 1]
    private let star = ["辅","英","芮",
                        "冲","","柱",
                        "任","蓬","心"]
    private let door = ["杜","景","死",
                        "伤","","惊",
                        "生","休","开"]
    private let god = ["值符","腾蛇","太阴",
                       "六合","白虎",
                       "玄武","九地","九天"]
    private var stem_Dic: [String: Int]!
    private var branch_Dic: [String: Int]!
    private var lanar_Dic: [String: Int]!
    private let Stem_2 = ["戊","己","庚","辛","壬","癸","丁","丙","乙"]
    
    private let day = ["一": 1,"二": 2,"三": 3,"四": 4,"五": 5,"六": 6,"七": 7,"八": 8,"九": 9,"十": 10]
    
    private let beginning = ["子":"甲子戊","戌":"甲戌己","申":"甲申庚","午":"甲午辛","辰":"甲辰壬","寅":"甲寅癸"]
    
    private let shape = ["步斗","天门","阴兵","阳斗","丁甲","阴斗","人门","神位","地户","阴山","魂魄","遁形"]
    
    private let clockwise = [3, 0, 1,
                             6, 4, 2,
                             7, 8, 5]
    
    private let anti_clockwise = [1, 2, 5,
                                  0, 4, 8,
                                  3, 6, 7]
    
    private let dorr = ["休","生","伤","杜","景","死","惊","开"]
    
    private let dizhi = ["巳","午","未",
                         "辰","","申",
                         "卯","","酉",
                         "寅","","戌",
                         "丑","子","亥"]
    
    private let dzClock = [0, 1, 2, 5, 8, 11, 14, 13, 12, 9, 6, 3]
    
    private let dzAnti = [0, 3, 6, 9, 12, 13, 14, 11, 8, 5, 2, 1]
    
    init() {
        setDic()
        
    }
    
    public func getDZClock() -> [Int] {
        return dzClock
    }
    
    public func getDZAnti() -> [Int] {
        return dzAnti
    }
    
    public func getShape() -> [String] {
        return shape
    }
    
    public func getDizhi() -> [String] {
        return dizhi
    }
    
    public func getDiagrams() -> [String] {
        return diagrams
    }
    
    public func getDorr() -> [String] {
        return dorr
    }
    
    public func getClockwise(_ b: Bool) -> [Int] {
        return b ? clockwise: anti_clockwise
    }
    
    public func getGod() -> [String] {
        return god
    }
    
    public func getN() -> [Int] {
        return n
    }
    
    public func getT() -> [Int] {
        return t
    }
    
    private func setDic() {
        stem_Dic = [String: Int]()
        for i in 0..<Heavenly_Stem.count {
            stem_Dic.updateValue(i, forKey: Heavenly_Stem[i])
        }
        branch_Dic = [String: Int]()
        for i in 0..<Earthly_branch.count {
            branch_Dic.updateValue(i, forKey: Earthly_branch[i])
        }
        lanar_Dic = [String: Int]()
        for i in 0..<lanar_month.count {
            lanar_Dic.updateValue(i, forKey: lanar_month[i])
        }
    }
    
    public func getDoor() -> [String] {
        return door
    }
    
    public func getStar() -> [String] {
        return star
    }
    
    public func getStemWithout1() -> [String] {
        return Stem_2
    }
    
    public func getBeginning() -> [String: String] {
        return beginning
    }
    
    public func getSite() -> [Int: Int] {
        return site
    }
    
    public func getDay() -> [String: Int] {
        return day
    }
    
    public func getStem() -> [String] {
        return Heavenly_Stem
    }
    
    public func getBranch() -> [String] {
        return Earthly_branch
    }
    
    public func getLanar() -> [String] {
        return lanar_month
    }
    
    public func getStemDic() -> [String: Int] {
        return stem_Dic
    }
    
    public func getBranchDic() -> [String: Int] {
        return branch_Dic
    }
    
    public func getLanarDic() -> [String: Int] {
        return lanar_Dic
    }
}
