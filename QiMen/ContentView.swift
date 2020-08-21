//
//  ContentView.swift
//  QiMen
//
//  Created by 王申宇 on 28/06/2020.
//  Copyright © 2020 王申宇. All rights reserved.
//

import SwiftUI

struct ContentView: View {
//    let qim = QMStartManager(year: 2006, month: 5, day: 23, hour: 19, minute: 25)
//    let term = SolarTerm()
//    let data = QMData()
    var body: some View {
        NavigationView {
            SetView()
            .navigationBarTitle("设置日期时间")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
