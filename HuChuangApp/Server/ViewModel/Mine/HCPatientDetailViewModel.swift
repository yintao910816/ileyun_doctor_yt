//
//  HCPatientDetailViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/15.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class HCPatientDetailViewModel: BaseViewModel {
    
    public let healthArchivesData = Variable([SectionModel<HCPatientDetailSectionModel, Any>]())
    public let healthArchivesExpand = PublishSubject<(Bool, Int)>()
    public let consultRecordData = PublishSubject<[HCConsultDetailItemModel]>()
    public let manageData = Variable([HCListCellItem]())
    
    private var healthArchivesOriginalData: [[Any]] = []
    // 健康档案数据
    private var healthArchivesModel = HCHealthArchivesModel()
    // 周期档案数据
    private var circleOrignalData: [HCPatientCircleModel] = []
    
    private var memberId: String = ""
    
    init(memberId: String) {
        super.init()
        self.memberId = memberId
        
        healthArchivesExpand.subscribe(onNext: { [weak self] in
            guard let strongSelf = self else { return }
            var data = strongSelf.healthArchivesData.value
            if $0.0 {
                data[$0.1].model.isExpand = true
                data[$0.1].items = strongSelf.healthArchivesOriginalData[$0.1]
            }else {
                data[$0.1].model.isExpand = false
                if $0.1 == 0 {
                    data[0].items = Array(strongSelf.healthArchivesOriginalData[0][0..<5])
                }else {
                    if strongSelf.circleOrignalData.count > 0 {
                        data[1].items = Array(strongSelf.healthArchivesOriginalData[1][0..<1])
                    }else {
                        data[1].items = []
                    }
                }
            }
            strongSelf.healthArchivesData.value = data
        })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.requestConsultRecords()
                self?.requestHealthArchives()
                self?.requestPatientData()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestPatientData() {
        manageData.value = [HCListCellItem(title: "备注", detailTitle: "请输入", titleColor: .black,cellIdentifier: HCListDetailCell_identifier),
                            HCListCellItem(title: "年龄", detailTitle: "31岁", titleColor: .black, showArrow: false, cellIdentifier: HCListDetailCell_identifier),
                            HCListCellItem(title: "分组",
                                           detailTitle: "默认分组",
                                           titleColor: .black,
                                           cellIdentifier: HCListDetailCell_identifier,
                                           segue: "patientGroupSegue"),
                            HCListCellItem(title: "屏蔽该患者", titleColor: .black, cellIdentifier: HCListSwitchCell_identifier)]
    }

    // 咨询记录
    private func requestConsultRecords() {
        HCProvider.request(.getConsultDetail(memberId: memberId, id: ""))
            .map(model: HCConsultDetailModel.self)
            .map({ [weak self] data -> [HCConsultDetailItemModel] in
                guard let strongSelf = self else { return [HCConsultDetailItemModel]() }
                return strongSelf.dealConsultRecords(data: data)
            })
            .asObservable()
            .bind(to: consultRecordData)
            .disposed(by: disposeBag)
    }
    
    private func dealConsultRecords(data: HCConsultDetailModel) ->[HCConsultDetailItemModel]{
        var tempData: [HCConsultDetailItemModel] = []
        for item in data.records {
            var consultList: [HCConsultDetailConsultListModel] = []
            for consultItem in item.consultList {
                let m = HCConsultDetailConsultListModel()
                m.cellIdentifier = HCConsultDetailTimeCell_identifier
                m.timeString = consultItem.createDate.timeSeprate3()
                consultList.append(m)
                consultList.append(consultItem)
                // 咨询类型是0的咨询,内容加回复全显示，咨询类型为1的只显示咨询内容
                if let type = HCConsultType(rawValue: item.type), type != .picAndText {
                    break
                }
            }
            item.calculateFooterUI()
            item.consultList = consultList
            tempData.append(item);
        }
        return tempData
    }
    
    private func requestHealthArchives() {
        let archivesSignal = HCProvider.request(.getHealthArchives(memberId: memberId))
            .map(model: HCHealthArchivesModel.self)
            .asObservable()
        let coupleInfoSignal = HCProvider.request(.getPatientCoupleInfo(memberId: memberId))
            .map(models: HCPatientCircleModel.self)
            .asObservable()
            .catchErrorJustReturn([])
        
        Observable.combineLatest(archivesSignal, coupleInfoSignal)
            .subscribe(onNext: { [weak self] data in
                self?.healthArchivesModel = data.0
                self?.circleOrignalData = data.1
                self?.prepareHealthArchivesOriginalData()
                
                }, onError: { _ in })
            .disposed(by: disposeBag)
    }
    
}

extension HCPatientDetailViewModel {
    
    private func prepareHealthArchivesOriginalData() {
        let firstSectionTitles = ["女方健康信息", "基本信息", "姓名", "身高", "体重", "月经史", "月经量", "是否痛经", "经期天数", "月经周期", "婚育史", "婚姻情况", "初/再婚几年", "未避孕未孕(年)", "是否有过怀孕", "人工流产", "宫外孕", "男方健康信息", "基本信息", "姓名", "身高", "体重"]
        let memberInfo = healthArchivesModel.memberInfo
        let menstruationHistory = healthArchivesModel.menstruationHistory
        let maritalHistory = healthArchivesModel.maritalHistory
        let firstSectionDetailTitles = ["","",memberInfo.nameW,memberInfo.heightW,memberInfo.weightW,"",menstruationHistory.catCatameniaAmount,menstruationHistory.catDysmenorrhea,menstruationHistory.catMensescycleDay,menstruationHistory.catMensescycleDay,"",maritalHistory.marReMarriage,maritalHistory.marReMarriageAge,maritalHistory.contraceptionNoPregnancyNo,maritalHistory.isPregnancy,maritalHistory.marDrugAbortion,maritalHistory.ectopicPregnancy,"","",memberInfo.nameM,memberInfo.heightM,memberInfo.weightM]
        var firstSectionDatas: [HCListCellItem] = []
        for idx in 0..<firstSectionTitles.count {
            let title = firstSectionTitles[idx]
            let detailTitle = firstSectionDetailTitles[idx]
            
            var model = HCListCellItem()
            model.cellHeight = 55
            model.title = title
            model.detailTitle = detailTitle
            model.cellIdentifier = HCListDetailCell_identifier
            model.showArrow = false
            model.titleFont = title.contains("健康信息") ? UIFont.font(fontSize: 17, fontName: .PingFMedium) : UIFont.font(fontSize: 16, fontName: .PingFRegular)
            if title.contains("女方健康信息") {
                model.titleColor = HC_MAIN_COLOR
                model.detailIcon = "record_icon_woman"
            }else if title.contains("男方健康信息") {
                model.titleColor = RGB(253, 119, 146)
                model.detailIcon = "record_icon_man"
            }else if title.contains("基本信息") || title.contains("月经史") || title.contains("婚育史") {
                model.titleColor = RGB(253, 153, 39)
            }else {
                model.titleColor = RGB(53, 53, 53)
            }
            firstSectionDatas.append(model)
        }
        healthArchivesOriginalData.append(firstSectionDatas)
        healthArchivesOriginalData.append(circleOrignalData)
        
        var secondData: [HCPatientCircleModel] = []
        if circleOrignalData.count > 0 {
            secondData.append(circleOrignalData.first!)
        }
        
        healthArchivesData.value = [SectionModel.init(model: HCPatientDetailSectionModel(title: "健康档案", isExpand: false),
                                                      items: Array(firstSectionDatas[0..<5])),
                                    SectionModel.init(model: HCPatientDetailSectionModel(title: "周期档案", isExpand: false),
                                                      items: secondData)]
    }
}

struct HCPatientDetailSectionModel {
    var title: String = ""
    var isExpand: Bool = false
    
    var expandIcon: UIImage? {
        get {
            return isExpand ? UIImage(named: "btn_gray_up_arrow") : UIImage(named: "btn_gray_down_arrow")
        }
    }
    
    var expandTitle: String {
        get {
            return isExpand ? "收起" : "展开"
        }
    }
}
