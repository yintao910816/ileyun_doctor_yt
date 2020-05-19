
//
//  HCEditNickNameViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/2/14.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCEditNickNameViewController: BaseViewController {
    
    @IBOutlet weak var inputOutlet: UITextField!
    
    private var viewModel: HCEditNickNameViewModel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        inputOutlet.becomeFirstResponder()
    }
    
    override func setupUI() {
        hiddenNavBg = true
    }
    
    override func rxBind() {
        viewModel = HCEditNickNameViewModel()
        
        viewModel.nickName
            .bind(to: inputOutlet.rx.text)
            .disposed(by: disposeBag)
        
        addBarItem(title: "完成", titleColor: HC_MAIN_COLOR)
            .map{ [unowned self] in self.inputOutlet.text ?? "" }
            .asObservable()
            .bind(to: viewModel.finishEdit)
            .disposed(by: disposeBag)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
}
