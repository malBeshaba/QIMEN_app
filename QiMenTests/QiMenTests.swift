//
//  QiMenTests.swift
//  QiMenTests
//
//  Created by 王申宇 on 01/07/2020.
//  Copyright © 2020 王申宇. All rights reserved.
//

import XCTest
@testable import QiMen

class UserSetting {
    var date = Date()
    var time = Date()
}

class QiMenTests: XCTestCase {
    let qm1 = QMStartManager(year: 2006, month: 5, day: 23, hour: 19, minute: 25)
    let qm2 = QMStartManager(year: 2020, month: 8, day: 10, hour: 18, minute: 15)
    let qm3 = QMStartManager(year: 2020, month: 8, day: 18, hour: 19, minute: 45)
    let calendar = Calendar.current
    let setting = UserSetting()
//    let qm4 = QMStartManager(year: calendar.component(.year, from: setting.date), month: calendar.component(.month, from: setting.date), day: calendar.component(.month, from: setting.date), hour: calendar.component(.hour, from: setting.time), minute: calendar.component(.minute, from: setting.time))
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        getT()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func getT() {
//        print(qm1.clothDoorSite())
//        print(qm1.getTime())
//        print(qm2.clothEarthSite())
//        print(qm2.getTime())
//        print(qm3.clothEarthSite())
//        print(qm3.getDutyDoor())
        let qm4 = QMStartManager(year: calendar.component(.year, from: setting.date), month: calendar.component(.month, from: setting.date), day: calendar.component(.day, from: setting.date), hour: calendar.component(.hour, from: setting.time), minute: calendar.component(.minute, from: setting.time))
//        print("calendor:\(calendar.component(.day, from: Date()))")
        print("DutyNum:\(qm4.getDutyNum())")
        print(qm4.clothSkySite())
        
        print(qm4.clothEarthSite())
        print(qm4.getNothing())
//        print("y:\(calendar.component(.year, from: setting.date))")
//        print("m:\(calendar.component(.month, from: setting.date))")
//        print("d:\(calendar.component(.day, from: setting.date))")
//        print("h:\(calendar.component(.hour, from: setting.date))")
    }

}
