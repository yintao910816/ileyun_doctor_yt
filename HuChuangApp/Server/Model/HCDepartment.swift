//
//  HCDepartment.swift
//  HuChuangApp
//
//  Created by yintao on 2020/6/21.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

//MARK: -- 科室
class HCDepartmentModel: HJModel {
    var id: String = ""
    var parentId: String = ""
    var name: String = ""
    var brief: String = ""
    var code: String = ""
    var bak: String = ""
    var sort: String = ""
    var creates: String = ""
    var modifys: String = ""
    var unitId: String = ""
    var unitName: String = ""
    var hisNo: String = ""
    var createDate: String = ""
    var modifyDate: String = ""
    var del: String = ""
}

extension HCDepartmentModel: HCPickerData {
    var title: String { return name }
}

//MARK: -- 医生职称
class HCZPListModel: HJModel {
    var id: String = ""
    var code: String = ""
    var name: String = ""
    var parentId: String = ""
    var createDate: String = ""
    var modifyDate: String = ""
    var creates: String = ""
    var modifys: String = ""
    var bak: String = ""
    var values: String = ""
    var brief: String = ""
    var sort: String = ""
}
extension HCZPListModel: HCPickerData {
    var title: String { return name }
}
