//
//  HCConsultViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/13.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxCocoa

class HCConsultViewModel: RefreshVM<HCConsultModel> {
    
    private var order: Int = 1
    
    init(orderDriver: Driver<Bool>) {
        super.init()
        
        orderDriver
            .drive(onNext: { [weak self] in
                self?.order = $0 ? 0 : 1
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
        
        HCProvider.request(.getMonthBillInfo(year: 2019, month: 12, pageNum: 1, pageSize: 10))
            .subscribe(onSuccess: { _ in
                
            }) { _ in
                
        }
        .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.consultList(sort: order, pageNum: pageModel.currentPage, pageSize: pageModel.pageSize))
            .map(model: HCConsultListModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.updateRefresh(refresh, data.list, data.pages)
            }) { _ in }
            .disposed(by: disposeBag)
    }
}
