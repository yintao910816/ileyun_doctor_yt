//
//  HCPatientSearchController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/19.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCPatientSearchController: BaseViewController {

    @IBOutlet weak var searchBar: TYSearchBar!
    @IBOutlet weak var tabelView: UITableView!
    
    @IBOutlet weak var tbHeaderView: UILabel!
    
    override func setupUI() {
        searchBar.coverButtonEnable = false
        searchBar.rightItemTitle = "取消"
        searchBar.searchPlaceholder = "搜索患者"
        searchBar.inputBackGroundColor = RGB(246, 246, 246)
    }
    
    override func rxBind() {
        
    }
}
