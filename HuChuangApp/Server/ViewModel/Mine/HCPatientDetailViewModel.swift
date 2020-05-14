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
    
    public let manageData = Variable([HCListCellItem]())
    
    private var healthArchivesOriginalData: [[HCListCellItem]] = []
    public let healthArchivesData = Variable([SectionModel<HCPatientDetailSectionModel, HCListCellItem>]())

    override init() {
        super.init()
        
        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.requestListData()
                self?.prepareHealthArchivesOriginalData()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestListData() {
        manageData.value = [HCListCellItem(title: "备注", detailTitle: "请输入", titleColor: .black,cellIdentifier: HCListDetailCell_identifier),
                            HCListCellItem(title: "年龄", detailTitle: "31岁", titleColor: .black, showArrow: false, cellIdentifier: HCListDetailCell_identifier),
                            HCListCellItem(title: "分组", detailTitle: "默认分组", titleColor: .black, cellIdentifier: HCListDetailCell_identifier),
                            HCListCellItem(title: "屏蔽该患者", titleColor: .black, cellIdentifier: HCListSwitchCell_identifier)]
    }

}

extension HCPatientDetailViewModel {
    
    private func prepareHealthArchivesOriginalData() {
        let firstSectionTitles = ["女方健康信息", "基本信息", "姓名", "身高", "体重", "月经史", "月经量", "是否痛经", "经期天数", "月经周期", "婚育史", "婚姻情况", "初/再婚几年", "未避孕未孕(年)", "是否有过怀孕", "人工流产", "宫外孕", "男方健康信息", "基本信息", "姓名", "身高", "体重"]
        var firstSectionDatas: [HCListCellItem] = []
        for item in firstSectionTitles {
            var model = HCListCellItem()
            model.title = item
            model.cellIdentifier = HCListDetailCell_identifier
            model.showArrow = false
            model.detailTitle = "未填写"
            model.titleFont = item.contains("健康信息") ? UIFont.font(fontSize: 17, fontName: .PingFMedium) : UIFont.font(fontSize: 16, fontName: .PingFRegular)
            if item.contains("女方健康信息") {
                model.titleColor = HC_MAIN_COLOR
            }else if item.contains("男方健康信息") {
                model.titleColor = RGB(253, 119, 146)
            }else if item.contains("基本信息") || item.contains("月经史") || item.contains("婚育史") {
                model.titleColor = RGB(253, 153, 39)
            }else {
                model.titleColor = RGB(53, 53, 53)
            }
            firstSectionDatas.append(model)
        }
        
        healthArchivesOriginalData.append(firstSectionDatas)
        
        healthArchivesData.value = [SectionModel.init(model: HCPatientDetailSectionModel(title: "健康档案", isExpand: false), items: firstSectionDatas)]
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
