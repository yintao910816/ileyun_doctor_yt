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
    private let consultRecordCtrl = HCPatientConsultRecordController()
    private let healthArchivesCtrl = HCPatientHealthArchivesController()
    private let manageCtrl = HCPatientManageController()

    private var memberId: String = ""
    private var navTitle: String?

    override func setupUI() {
        navigationItem.title = navTitle
        
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
        manageCtrl.didEndEditCallBack = { [unowned self] in self.viewModel.didEndEditMakrSubject.onNext($0) }
        manageCtrl.switchCallBack = { [unowned self] in self.viewModel.blackPatientSubject.onNext($0) }

        slideCtrl.menuItems = TYSlideItemModel.creatSimple(for: ["咨询记录", "健康档案", "患者管理"])
        slideCtrl.menuCtrls = [consultRecordCtrl,
                               healthArchivesCtrl,
                               manageCtrl]
    }
    
    override func rxBind() {
        viewModel = HCPatientDetailViewModel(memberId: memberId)
        
        viewModel.consultRecordData.asDriver()
            .drive(onNext: { [weak self] in
                self?.consultRecordCtrl.reloadData(data: $0)
            })
            .disposed(by: disposeBag)
        
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

        
//        consultRecordCtrl.operationCallBack = { [unowned self] in
//            switch $0.0 {
//            case .back:
//                break
//            case .supplementAsk:
//                break
//            case .reply:
//                break
//            case .supplementReply:
//                break
//            case .view:
//                break
//            }
//        }
        
        consultRecordCtrl.gotoChatConsultRoomCallBack = { [weak self] in
            self?.performSegue(withIdentifier: "consultDetailSegue", sender: $0)
        }
        
        consultRecordCtrl.sendImageCallBack = { [unowned self] in self.viewModel.sendImageSubject.onNext($0) }
        consultRecordCtrl.sendAudioCallBack = { [unowned self] in self.viewModel.sendAudioSubject.onNext($0) }
        consultRecordCtrl.sendTextCallBack = { [unowned self] in self.viewModel.sendTextSubject.onNext($0) }
        consultRecordCtrl.sendBackCallBack = { [unowned self] in self.viewModel.sendBackSubject.onNext($0) }
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(parameters: [String : Any]?) {
        memberId = parameters!["id"] as! String
        navTitle = parameters!["title"] as? String
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "consultDetailSegue", let model = sender as? HCConsultDetailItemModel {
            segue.destination.title = model.memberName
            segue.destination.prepare(parameters: ["memberId":model.memberId, "id": model.id])
        }else if segue.identifier == "patientGroupSegue" {
            segue.destination.prepare(parameters: ["id": memberId])
        }
    }
}
