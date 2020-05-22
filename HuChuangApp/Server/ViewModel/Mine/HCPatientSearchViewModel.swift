//
//  HCPatientSearchViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/22.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift

class HCPatientSearchViewModel: BaseViewModel, VMNavigation {
    
    public var datasource = Variable([HCPatientListItemModel]())
    public let excuteSearchAction = PublishSubject<String>()
    public let modelSelectedAction = PublishSubject<HCPatientListItemModel>()
    
    override init() {
        super.init()
        
        modelSelectedAction
            .subscribe(onNext: {
                HCPatientSearchViewModel.sbPush("HCMain", "patientDetailController", parameters: ["id":$0.memberId])
            })
            .disposed(by: disposeBag)
        
        excuteSearchAction
            .subscribe(onNext: { [weak self] in
                self?.requestSearch(keywords: $0)
            })
            .disposed(by: disposeBag)
    }
    
    private func requestSearch(keywords: String) {
        hud.noticeLoading()
        HCProvider.request(.searchData(searchWords: keywords))
            .map(model: HCPatientSearchDataModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.hud.noticeHidden()
                self?.datasource.value = $0.memberLsit
            }) { [weak self] _ in
                self?.hud.noticeHidden()
        }
        .disposed(by: disposeBag)
    }
}
