//
//  HCPatientConsultRecordController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/15.
//  Copyright © 2020 sw. All rights reserved.
//  咨询记录

import UIKit

class HCPatientConsultRecordController: HCSlideItemController {

    private var datasource: [HCConsultDetailItemModel] = []
    private var tableView: UITableView!
    
    public var operationCallBack:((HCPatientConsultRecordFooterOperation, HCConsultDetailItemModel)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        tableView = UITableView.init(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.register(HCConsultDetailTimeCell.self, forCellReuseIdentifier: HCConsultDetailTimeCell_identifier)
        tableView.register(HCConsultDetalCell.self, forCellReuseIdentifier: HCConsultDetalCell_identifier)
        tableView.register(HCPatientConsultRecordHeader.self, forHeaderFooterViewReuseIdentifier: HCPatientConsultRecordHeader_identifier)
        tableView.register(HCPatientConsultRecordFooter.self, forHeaderFooterViewReuseIdentifier: HCPatientConsultRecordFooter_identifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    override func reloadData(data: Any?) {
        if let model = data as? [HCConsultDetailItemModel] {
            datasource = model
            tableView.reloadData()
        }
    }

      override func bind<T>(viewModel: RefreshVM<T>, canRefresh: Bool, canLoadMore: Bool, isAddNoMoreContent: Bool) {
    
      }

}

extension HCPatientConsultRecordController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].consultList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = datasource[indexPath.section].consultList[indexPath.row]
        return model.getCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = datasource[indexPath.section].consultList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseConsultCell
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HCPatientConsultRecordHeader_identifier) as! HCPatientConsultRecordHeader
        header.model = datasource[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return datasource[section].footerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: HCPatientConsultRecordFooter_identifier) as! HCPatientConsultRecordFooter
        footer.model = datasource[section]
        footer.operationCallBack = { [weak self] in
            self?.operationCallBack?($0, $1)
        }
        return footer
    }
}
