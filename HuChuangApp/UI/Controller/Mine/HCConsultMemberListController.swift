//
//  HCConsultMemberListController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/14.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit
import RxDataSources

class HCConsultMemberListController: BaseViewController {

    @IBOutlet weak var searchBar: TYSearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: HCConsultMemberListViewModel!
    
    override func setupUI() {
        searchBar.inputBackGroundColor = RGB(246, 246, 246)
        searchBar.searchPlaceholder = "搜索患者"
        
        tableView.rowHeight = 63
        
        tableView.register(UINib.init(nibName: "HCPatientListCell", bundle: nil),
                           forCellReuseIdentifier: HCPatientListCell_identifier)
        tableView.register(HCPatientListHeaderView.self, forHeaderFooterViewReuseIdentifier: HCPatientListHeaderView_identifier)
    }
    
    override func rxBind() {
        viewModel = HCConsultMemberListViewModel()
        
        let signal = RxTableViewSectionedReloadDataSource<SectionModel<HCPatientListSectionModel,HCPatientListModel>>.init(configureCell: { (_, tb, indexPath, model) ->UITableViewCell in
            let cell = tb.dequeueReusableCell(withIdentifier: HCPatientListCell_identifier)!
            return cell
        })
        
        viewModel.listData.asDriver()
            .drive(tableView.rx.items(dataSource: signal))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] in self.tableView.deselectRow(at: $0, animated: true) })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HCPatientListModel.self)
            .subscribe(onNext: { [weak self] in
                self?.performSegue(withIdentifier: "patientDetailSegue", sender: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "patientDetailSegue" {
            segue.destination.prepare(parameters: ["model":sender as! HCPatientListModel])
        }
    }
}

extension HCConsultMemberListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HCPatientListHeaderView_identifier) as! HCPatientListHeaderView
        header.model = viewModel.sectionModel(for: section)
        header.didSelectedCallBack = { [weak self] in
            self?.viewModel.reloadSectionSignal.onNext(section)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
