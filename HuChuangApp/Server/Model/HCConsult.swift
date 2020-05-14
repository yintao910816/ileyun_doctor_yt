//
//  HCConsult.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/13.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCConsultListModel: HJModel {
    var records: [HCConsultModel] = []
}

class HCConsultModel: HJModel {
    var age: String = ""
    var content: String = ""
    var createDate: String = ""
    var headPath: String = ""
    var id: String = ""
    var lastestConsultDate: String = ""
    var memberId: String = ""
    var memberName: String = ""
    var name: String = ""
    var price: String = ""
    var realName: String = ""
    var sex: Int = 0
    var unreplyNum: Int = 0
    var userId: String = ""
    var userName: String = ""
}
