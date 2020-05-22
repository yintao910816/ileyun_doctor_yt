//
//  HCConsultViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/13.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class HCConsultViewModel: RefreshVM<HCConsultModel>, VMNavigation {
    
    private var order: Int = 1
    
    public let cellDidSelected = PublishSubject<HCConsultModel>()

    init(orderDriver: Driver<Bool>) {
        super.init()

        orderDriver
            .drive(onNext: { [weak self] in
                self?.order = $0 ? 0 : 1
                self?.requestData(true)
            })
            .disposed(by: disposeBag)

        cellDidSelected
            .subscribe(onNext: {
                HCConsultViewModel.sbPush("HCMain","patientDetailController", parameters: ["id": $0.memberId])
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.consultList(sort: order, pageNum: pageModel.currentPage, pageSize: pageModel.pageSize))
            .map(model: HCConsultListModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.updateRefresh(refresh, data.records, data.pages)
            }) { _ in }
            .disposed(by: disposeBag)
    }
}
