//
//  SetView.swift
//  QiMen
//
//  Created by 王申宇 on 07/08/2020.
//  Copyright © 2020 王申宇. All rights reserved.
//

import SwiftUI

struct SetView: View {
    
    @EnvironmentObject var setting: UserSetting
    
    var body: some View {
        Form {
            Section {
                Text("请输入日期")
                    .font(.headline)
                DatePicker("Please enter a time", selection: $setting.date, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
            }
            Section {
                Text("请输入时间")
                DatePicker("Please enter a time", selection: $setting.time, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
            }
            Section {
                NavigationLink(destination: ShowView()) {
                    HStack {
                        Spacer()
                        Text("起局")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                            .cornerRadius(10)
                            .shadow(radius: 4)
                        Spacer()
                    }
                }
            }
            
        }
    }
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        SetView()
    }
}
