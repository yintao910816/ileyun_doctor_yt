//
//  HCConsult.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/13.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCConsultListModel: HJModel {
    var list: [HCConsultModel] = []
}

class HCConsultModel: HJModel {
    var content: String = ""
    var create_time: String = ""
    var currentStatus: Int = 0
    var doctorId: Int = 0
    var doctorIds: Int = 0
    var doctorName: String = ""
    var headImg: String = ""
    var identityNo: String = ""
    var lastestTime: String = ""
    var patientId: String = ""
    var patientName: String = ""
    var unReplyCount: Int = 0

}
