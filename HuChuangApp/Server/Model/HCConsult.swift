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

/// 健康档案
class HCHealthArchivesModel: HJModel {
    var memberInfo: HCMemberInfoModel = HCMemberInfoModel()
    var fileRecord: [HCFileRecordModel] = []
    var maritalHistory: HCMaritalHistoryModel = HCMaritalHistoryModel()
    var menstruationHistory: HCMenstruationHistoryModel = HCMenstruationHistoryModel()
}

class HCMemberInfoModel: HJModel {
    var id: String = ""
    var nameW: String = ""
    var heightW: String = ""
    var weightW: String = ""
    var nameM: String = ""
    var heightM: String = ""
    var weightM: String = ""
    var memberId: String = ""
    var createDate: String = ""
    var modifyDate: String = ""
    var creates: String = ""
    var modifys: String = ""
    var bak: String = ""
}

class HCFileRecordModel: HJModel {
    var fileRecord: [HCFileRecordItemModel] = []
}

class HCFileRecordItemModel: HJModel {
    var date: String = ""
    var fileRecordList: [HCFileRecordListModel] = []
}

class HCFileRecordListModel: HJModel {
    var id: String = ""
    var memberId: String = ""
    var filePath: String = ""
    var localFilePath: String = ""
    var fileName: String = ""
    var zpiontId: String = ""
    var zpiontName: String = ""
    var createDate: String = ""
    var modifyDate: String = ""
    var creates: String = ""
    var modifys: String = ""
    var createName: String = ""
    var modifyName: String = ""
    var uploadDate: String = ""
    var recordId: String = ""
    var zipFilePath: String = ""
    var subFilePath: String = ""
    var sort: String = ""
    var bak: String = ""
}

class HCMaritalHistoryModel: HJModel {
    var id: String = ""
    var marReMarriage: String = ""
    var marReMarriageAge: String = ""
    var contraceptionNoPregnancyNo: String = ""
    var isPregnancy: String = ""
    var marDrugAbortion: String = ""
    var ectopicPregnancy: String = ""
    var createDate: String = ""
    var modifyDate: String = ""
    var creates: String = ""
    var modifys: String = ""
    var bak: String = ""
    var memberId: String = ""
}

class HCMenstruationHistoryModel: HJModel {
    var id: String = ""
    var catMenarche: String = ""
    var catMensescycle: String = ""
    var catMensescycleDay: String = ""
    var catLastCatamenia: String = ""
    var catCatameniaAmount: String = ""
    var catDysmenorrhea: String = ""
    var memberId: String = ""
    var createDate: String = ""
    var modifyDate: String = ""
    var creates: String = ""
    var modifys: String = ""
    var bak: String = ""
}
