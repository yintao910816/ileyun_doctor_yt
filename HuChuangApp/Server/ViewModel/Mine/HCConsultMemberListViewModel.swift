//
//  HCConsultMemberListViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/14.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift
import RxDataSources

class HCConsultMemberListViewModel: BaseViewModel {
    
    private var originalDatas: [HCPatientListModel] = []
    public let listData = Variable([SectionModel<HCPatientListSectionModel,HCPatientListItemModel>]())
    public let reloadSectionSignal = PublishSubject<Int>()
    
    override init() {
        super.init()
        
        reloadSectionSignal.subscribe(onNext: { [unowned self] in
            var data = self.listData.value
            data[$0].model.isExpand = !data[$0].model.isExpand
            if data[$0].model.isExpand {
                data[$0].items = self.originalDatas[$0].memberList
            }else {
                data[$0].items = []
            }
            self.listData.value = data
        })
            .disposed(by: disposeBag)
        
        reloadSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] in
                self?.requestListData()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestListData() {
        HCProvider.request(.groupTagMemberList)
            .map(models: HCPatientListModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.originalDatas.append(contentsOf: data)
                var sectionData: [SectionModel<HCPatientListSectionModel,HCPatientListItemModel>] = []
                for item in data {
                    sectionData.append(SectionModel.init(model: HCPatientListSectionModel(title: item.tagName), items: []))
                }
                self?.listData.value = sectionData
                self?.hud.noticeHidden()
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
        }
        .disposed(by: disposeBag)
    }
    
    public func sectionModel(for section: Int) ->HCPatientListSectionModel {
        return listData.value[section].model
    }
}

struct HCPatientListSectionModel {
    var title: String = ""
    var isExpand: Bool = false
    
    var headerIcon: UIImage? {
        get {
            return isExpand ? UIImage(named: "patient_triangle_down") : UIImage(named: "patient_triangle_right")
        }
    }
}
