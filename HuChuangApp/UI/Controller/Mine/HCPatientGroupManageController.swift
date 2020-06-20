//
//  HCPatientGroupManageController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/19.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCPatientGroupManageController: BaseViewController {

    @IBOutlet weak var contentView: TYFiliterView!
    @IBOutlet weak var addTagOutlet: UIButton!
    @IBOutlet weak var tagTfOutlet: UITextField!
    
    private var memberId: String = ""
    private var viewModel: HCPatientGroupManageViewModel!
    
    override func setupUI() {
        contentView.cellDidSelected = { [unowned self] in self.viewModel.cellDidSelected.onNext(($0.title, $0.id)) }
        contentView.deleteCallBack = { [unowned self] in self.viewModel.deleteTagSubject.onNext($0.id) }
    }
    
    override func rxBind() {
        viewModel = HCPatientGroupManageViewModel.init(input: tagTfOutlet.rx.text.orEmpty.asDriver(),
                                                       addTapDriver: addTagOutlet.rx.tap.asDriver(),
                                                       memberId: memberId)
        
        viewModel.tagListSource.asDriver()
            .drive(onNext: { [weak self] in
                self?.contentView.datasource = $0
            })
            .disposed(by: disposeBag)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(parameters: [String : Any]?) {
        memberId = parameters!["id"] as! String
    }
}
