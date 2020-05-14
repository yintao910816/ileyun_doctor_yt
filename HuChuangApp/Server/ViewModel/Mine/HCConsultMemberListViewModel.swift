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
    
    private var originalDatas: [[HCPatientListModel]] = []
    public let listData = Variable([SectionModel<HCPatientListSectionModel,HCPatientListModel>]())
    public let reloadSectionSignal = PublishSubject<Int>()
    
    override init() {
        super.init()
        
        reloadSectionSignal.subscribe(onNext: { [unowned self] in
            var data = self.listData.value
            data[$0].model.isExpand = !data[$0].model.isExpand
            if data[$0].model.isExpand {
                data[$0].items = self.originalDatas[$0]
            }else {
                data[$0].items = []
            }
            self.listData.value = data
        })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.requestListData()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestListData() {
        originalDatas.append([HCPatientListModel(), HCPatientListModel()])
        originalDatas.append([HCPatientListModel(), HCPatientListModel()])
        originalDatas.append([HCPatientListModel(), HCPatientListModel()])

        listData.value = [SectionModel.init(model: HCPatientListSectionModel(title: "不孕不育"),
                                            items: []),
                          SectionModel.init(model: HCPatientListSectionModel(title: "试管婴儿"),
                                            items: []),
                          SectionModel.init(model: HCPatientListSectionModel(title: "默认分组"),
                                            items: [])]
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
