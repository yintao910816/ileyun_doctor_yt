//
//  HCPatientHealthArchivesController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/15.
//  Copyright © 2020 sw. All rights reserved.
//  健康档案

import UIKit
import RxDataSources

class HCPatientHealthArchivesController: HCSlideItemController {

    private var tableView: UITableView!

    private var datasource: [SectionModel<HCPatientDetailSectionModel, HCListCellItem>] = []
    
    public var expandChangeCallBack: (((Bool, Int))->())?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        tableView = UITableView.init(frame: view.bounds)
        tableView.separatorStyle = .none
        tableView.rowHeight = 55
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.register(HCListDetailCell.self, forCellReuseIdentifier: HCListDetailCell_identifier)
        tableView.register(HCPatientHealthArchivesHeaderView.self, forHeaderFooterViewReuseIdentifier: HCPatientHealthArchivesHeaderView_identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    override func reloadData(data: Any?) {
        tableView.separatorStyle = .none

        if let models = data as? [SectionModel<HCPatientDetailSectionModel, HCListCellItem>] {
            datasource.removeAll()
            datasource.append(contentsOf: models)
            tableView.reloadData()
        }
    }
}

extension HCPatientHealthArchivesController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = datasource[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseListCell
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HCPatientHealthArchivesHeaderView_identifier) as! HCPatientHealthArchivesHeaderView
        header.model = datasource[section].model
        header.expandChangeCallBack = { [weak self] in self?.expandChangeCallBack?(($0, section)) }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
}

