//
//  HCPickerData.swift
//  HuChuangApp
//
//  Created by yintao on 2020/6/21.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

protocol HCPickerData {
    var title: String { get }
}

extension HCPickerData {
    
}


struct HCPickerSectionData {
    var sectionData: [[HCPickerData]] = []
}
