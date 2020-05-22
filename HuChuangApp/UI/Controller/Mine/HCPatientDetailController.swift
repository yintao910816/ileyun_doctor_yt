//
//  HCPatientDetailController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/15.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCPatientDetailController: BaseViewController {

    private var viewModel: HCPatientDetailViewModel!
    
    private var slideCtrl: TYSlideMenuController!
    private let healthArchivesCtrl = HCPatientHealthArchivesController()
    private let manageCtrl = HCPatientManageController()

    private var memberId: String = ""

    override func setupUI() {
        slideCtrl = TYSlideMenuController()
        addChild(slideCtrl)
        view.addSubview(slideCtrl.view)
        
        slideCtrl.pageScroll = { [weak self] page in
            
        }

        healthArchivesCtrl.expandChangeCallBack = { [weak self] in
            self?.viewModel.healthArchivesExpand.onNext($0)
        }
        
        manageCtrl.cellDidSelected = { [unowned self] in
            guard $0.segue.count > 0 else { return }
            self.performSegue(withIdentifier: $0.segue, sender: nil)
        }
        
        slideCtrl.menuItems = TYSlideItemModel.creatSimple(for: ["咨询记录", "健康档案", "患者管理"])
        slideCtrl.menuCtrls = [HCPatientConsultRecordController(),
                               healthArchivesCtrl,
                               manageCtrl]
    }
    
    override func rxBind() {
        viewModel = HCPatientDetailViewModel(memberId: memberId)
        
        viewModel.manageData.asDriver()
            .drive(onNext: { [weak self] in
                self?.manageCtrl.reloadData(data: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.healthArchivesData.asDriver()
            .drive(onNext: { [weak self] in
                self?.healthArchivesCtrl.reloadData(data: $0)
            })
            .disposed(by: disposeBag)

        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(parameters: [String : Any]?) {
        memberId = parameters!["id"] as! String
    }
}
