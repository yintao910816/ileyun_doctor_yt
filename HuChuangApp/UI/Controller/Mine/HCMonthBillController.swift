
//
//  HCMonthBillController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/14.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMonthBillController: BaseViewController {

    @IBOutlet weak var filiterTimeOutlet: UIButton!
    @IBOutlet weak var incomeOutlet: UILabel!
    @IBOutlet weak var expenditureOutlet: UILabel!
    @IBOutlet weak var withdrawalOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!

    override func setupUI() {
        
    }
    
    override func rxBind() {
        
        filiterTimeOutlet.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                let datePicker = HCDatePickerViewController()
                datePicker.titleDes = "时间"
                self?.addChildViewController(datePicker)
                
                datePicker.finishSelected = { date in
                    print("------ \(date)")
                }
            })
            .disposed(by: disposeBag)
    }
}
