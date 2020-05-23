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
            sectionDatas.append(SectionModel.init(model: item, items: item.consultList))
        }
        updateRefresh(refresh, sectionDatas, data.pages)
    }
}
