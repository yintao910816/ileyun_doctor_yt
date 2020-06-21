//
//  HCDoctorProfileController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/16.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift

class HCDoctorProfileController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: HCDoctorProfileViewModel!
    
    override func setupUI() {
        tableView.register(HCListDetailCell.self, forCellReuseIdentifier: HCListDetailCell_identifier)
        tableView.register(HCListTextViewCell.self, forCellReuseIdentifier: HCListTextViewCell_identifier)
        tableView.register(HCListDetailInputCell.self, forCellReuseIdentifier: HCListDetailInputCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCDoctorProfileViewModel()
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<Int, HCListCellItem>>.init(configureCell: { _,tb,indexPath,model ->UITableViewCell in
            let cell = (tb.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseListCell)
            cell.model = model
            cell.didEndEditWithModel = { [weak self] in self?.viewModel.postEditSubject.onNext($0) }
            return cell
        })
        
        viewModel.listData
            .asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
//        tableView.rx.modelSelected(HCListCellItem.self)
//            .filter{ [unowned self] in self.cellDidSelceted(model: $0) }
//            .bind(to: viewModel.cellDidSelected)
//            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
}

extension HCDoctorProfileController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellModel(for: indexPath).cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model = viewModel.listData.value[indexPath.section].items[indexPath.row]
        
        if model.title == "擅长疾病" || model.title == "个人简介" {
            viewModel.cellDidSelected.onNext(model)
            return
        }
        
        if model.segue.count > 0 {
            performSegue(withIdentifier: model.segue, sender: nil)
            return
        }
        
        if model.idKey == "technicalPostId" {
            // 职称修改
            let picker = HCPickerController.init()
            picker.titleDes = "职称"
            picker.pickerHeight = 216
            picker.sectionModel = [viewModel.zpListSource]
            addChildViewController(picker)
            
            picker.finishSelectedModel = { [unowned self] in
                if $0.0 == .ok, let selected = $0.1.first as? HCZPListModel {
                    model.change(id: selected.id)
                    model.detailTitle = selected.name
                    self.viewModel.postEditSubject.onNext(model)
                    
                    (self.tableView.cellForRow(at: indexPath) as? HCListDetailCell)?.model = model
                }
            }
        }else if model.idKey == "departmentId" {
            // 科室修改
            let picker = HCPickerController.init()
            picker.titleDes = "科室"
            picker.pickerHeight = 216
            picker.sectionModel = [viewModel.departmentSource]
            addChildViewController(picker)
            
            picker.finishSelectedModel = { [unowned self] in
                if $0.0 == .ok, let selected = $0.1.first as? HCDepartmentModel {
                    model.change(id: selected.id)
                    model.detailTitle = selected.name
                    self.viewModel.postEditSubject.onNext(model)
                    
                    (self.tableView.cellForRow(at: indexPath) as? HCListDetailCell)?.model = model
                }
            }
        }

    }
}
