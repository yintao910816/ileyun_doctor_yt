//
//  HCOpenConsultStatus.swift
//  HuChuangApp
//
//  Created by yintao on 2020/6/21.
//  Copyright © 2020 sw. All rights reserved.
//  咨询设置

import Foundation

class HCOpenConsultStatusModel: HJModel {
    var smsNotice: Bool = false
    var ltzx: HCLtzxModel = HCLtzxModel()
    var dctw: HCDctwModel = HCDctwModel()
}

//MARK: -- 聊天设置
class HCLtzxModel: HJModel {
    var id: String = ""
    var unitId: String = ""
    var userName: String = ""
    var unitName: String = ""
    var userId: String = ""
    var price: String = ""
    var isOpen: String = ""
    var createDate: String = ""
    var modifyDate: String = ""
    var creates: String = ""
    var modifys: String = ""
    var bak: String = ""
    var timeType: String = ""
    var startTime: String = ""
    var endTime: String = ""
    var type: String = ""
    var unit: String = ""
    var recom: Bool = false
    var smsNotice: Bool = false
}

//MARK: -- 单次图文
class HCDctwModel: HJModel {
    var id: String = ""
    var unitId: String = ""
    var userName: String = ""
    var unitName: String = ""
    var userId: String = ""
    var price: String = ""
    var isOpen: Bool = false
    var createDate: String = ""
    var modifyDate: String = ""
    var creates: String = ""
    var modifys: String = ""
    var bak: String = ""
    var timeType: Int = 0
    var startTime: String = ""
    var endTime: String = ""
    var type: Int = 0
    var unit: String = ""
    var recom: Bool = false
    var smsNotice: Bool = false
}
