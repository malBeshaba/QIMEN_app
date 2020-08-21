//
//  ViewData.swift
//  QiMen
//
//  Created by 王申宇 on 07/08/2020.
//  Copyright © 2020 王申宇. All rights reserved.
//

import SwiftUI
import Foundation

class UserSetting: ObservableObject {
    @Published var date = Date()
    @Published var time = Date()
}
