//
//  ShowView.swift
//  QiMen
//
//  Created by 王申宇 on 07/08/2020.
//  Copyright © 2020 王申宇. All rights reserved.
//

import SwiftUI

struct ShowView: View {
    
    @EnvironmentObject var setting: UserSetting
    var calendar = Calendar.current
    
    /// 中间九宫
    var site = [6: 0, 7: 1, 8: 2,
                11: 3, 12: 4, 13: 5,
                16: 6, 17: 7, 18: 8]
    
    /// 地支分布
    var d = [0: 1, 1: 2, 2: 3,
             3: 5, 4: -1, 5: 9,
             6: 10, 7: -1, 8: 14,
             9: 15, 10: -1, 11: 19,
             12: 21, 13: 22, 14: 23]
    
    /// 九宫对应位置
    var s = [6, 7, 8, 11, 12, 13, 16, 17, 18]
    
    /// 奇门生成器
    var qm: QMGenerator {
//        return QMStartManager(year: 2020, month: 8, day: 10, hour: 18, minute: 15)
        
//        return QMStartManager(year: 2006, month: 5, day: 23, hour: 19, minute: 25)
        let y = calendar.component(.year, from: setting.date)
        let mon = calendar.component(.month, from: setting.date)
        let d = calendar.component(.day, from: setting.date)
        let h = calendar.component(.hour, from: setting.time)
        let min = calendar.component(.minute, from: setting.time)
        return QMGenerator(year: y, month: mon, day: d, hour: h, minute: min)
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Group {
                    Text("年 ")
                        .foregroundColor(.red)
                    Text(qm.getYearColumns())
                    Text("月 ")
                        .foregroundColor(.red)
                    Text(qm.getMonthColumns())
                }
                Text("日 ")
                    .foregroundColor(.red)
                Text(qm.getDayColumns())
                Text("时 ")
                    .foregroundColor(.red)
                Text(qm.getHourColumns())
            }
            HStack {
                Text("\(self.qm.getYY())")
                    .foregroundColor(.red)
                Text("\(self.qm.getStep())局")
            }
            HStack {
                Text("旬首 ")
                    .foregroundColor(.red)
                Text(self.qm.getBeginning())
            }
            HStack {
                Text("值符 ")
                    .foregroundColor(.red)
                Text(self.qm.getDutyStar())
            }
            HStack {
                Text("值使 ")
                    .foregroundColor(.red)
                Text(self.qm.getDutyDoor())
            }
            
            GridStack(minCellWidth: 66, spacing: 2, numItems: 25) { index, cellWeith in
                VStack {
                    HStack {
                        if self.qm.enterTomb() != -1 {
                            if self.s[self.qm.enterTomb()] == index {
                                Text("墓")
                                    .foregroundColor(.blue)
                            }
                        }
                        if self.qm.shot() != -1 {
                            if self.s[self.qm.shot()] == index {
                                Text("刑")
                                    .foregroundColor(.green)
                            }
                        }
                        if self.isNothing(index) {
                            Image("k")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                        }
                        Text(self.getAllIt(index))
                            .fontWeight(.ultraLight)
                        
                    }
                    HStack {
                    
                        if self.isInSite(index) {
                            Text("\(self.qm.clothGodSite()[self.site[index]!])")
                                .font(.callout)
                            Spacer()
                            Text("\(self.qm.clothHideStem()[self.site[index]!])")
                                .font(.callout)
                        }
                    }
                    HStack {
                        if self.isInSite(index) {
                            Text("\(self.qm.clothSkySite()[self.site[index]!])")
                                .font(.callout)
                            Spacer()
                            Text("\(self.qm.clothSkySiteStar()[self.site[index]!])")
                                .font(.callout)
                        }
                    }
                    HStack {
                        if self.isInSite(index) {
                            Text("\(self.qm.getRealEarth()[self.site[index]!])")
                                .font(.callout)
                            Spacer()
                            Text("\(self.qm.clothDoorSite()[self.site[index]!])")
                                .font(.callout)
                        }
                    }
                }
                .frame(width: cellWeith, height: cellWeith)
                .background(Color.white)
            }
            .frame(width: 400, height: 400)
            .background(Color.black.frame(width: 240, height: 240))
        }
    }
     
    
    /// 位置是否在中间九宫
    /// - Parameter i: index
    /// - Returns: Boolean
    func isInSite(_ i: Int) -> Bool {
        for t in s {
            if i == t {
                return true
            }
        }
        return false
    }
    
    /// 是否为空亡
    /// - Parameter i: index
    /// - Returns: Boolean
    func isNothing(_ i: Int) -> Bool {
        for t in self.qm.getNothing() {
            if d[t] == i {
                return true
            }
        }
        return false
    }
    
    /// 配置常量
    /// - Parameter i: index
    /// - Returns: Text
    func getAllIt(_ i: Int) -> String {
        var str = ""
        if self.d[self.qm.getIllSite()] == i {
            str += "P\r乙 "
        }
        
        if self.d[self.qm.getMourning()] == i {
            str += "h\r戊 "
        }
        
        if self.d[self.qm.getTongue()] == i {
            str += "n\r戊 "
        }
        if self.d[self.qm.getTranquility()] == i {
            
            str += "辛\r戊 "
        }
        if self.d[self.qm.getHorse()] == i {
            str += "马"
        }
        return str
    }
    
}

struct ShowView_Previews: PreviewProvider {
    static var previews: some View {
        ShowView().environmentObject(UserSetting())
    }
}
