//
//  HCConsultDetailViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/23.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift

class HCConsultDetailViewModel: RefreshVM<SectionModel<HCConsultDetailItemModel, HCConsultDetailConsultListModel>> {
    
    private var memberId: String = ""
    private var id: String = ""

    public let timeObser = Variable("30:00")
    public let questionObser = Variable("1/1")

    init(memberId: String, id: String) {
        super.init()
        
        self.memberId = memberId
        self.id = id
    }
    
    override func requestData(_ refresh: Bool) {
        HCProvider.request(.getConsultDetail(memberId: memberId, id: id))
            .map(model: HCConsultDetailModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.dealRequestData(refresh:refresh, data: $0)
            }) { [weak self] _ in self?.revertCurrentPageAndRefreshStatus() }
            .disposed(by: disposeBag)
    }
    
    private func dealRequestData(refresh: Bool, data: HCConsultDetailModel) {
        var sectionDatas: [SectionModel<HCConsultDetailItemModel, HCConsultDetailConsultListModel>] = []
        for item in data.records {
            var consultsList: [HCConsultDetailConsultListModel] = []
            consultsList.append(contentsOf: item.consultList)

            if item.content == item.consultList.first?.content {
                consultsList.remove(at: 0)
            }

            if item.startDate.count > 0 {
                let starDateModel = HCConsultDetailConsultListModel()
                starDateModel.cellIdentifier = HCConsultDetailTimeCell_identifier
                starDateModel.timeString = "开始回复 \(item.startDate)"
                consultsList.insert(starDateModel, at: 0)
            }
            
            if item.endDate.count > 0 {
                let endDateModel = HCConsultDetailConsultListModel()
                endDateModel.cellIdentifier = HCConsultDetailTimeCell_identifier
                endDateModel.timeString = "结束回复 \(item.endDate)"
                consultsList.append(endDateModel)
            }
            
            sectionDatas.append(SectionModel.init(model: item, items: consultsList))
        }
        
        timeObser.value = "30:00"
        questionObser.value = data.records.last?.question ?? "1/1"
        
        updateRefresh(refresh, sectionDatas, data.pages)
    }
}
