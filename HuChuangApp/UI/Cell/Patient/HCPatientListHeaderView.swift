//
//  HCPatientListHeaderView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/14.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCPatientListHeaderView_identifier = "HCPatientListHeaderView_identifier"

class HCPatientListHeaderView: UITableViewHeaderFooterView {

    @IBOutlet var mainContentView: UIView!
    @IBOutlet weak var headerIconOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    
    public var didSelectedCallBack: (()->())?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        mainContentView = (Bundle.main.loadNibNamed("HCPatientListHeaderView", owner: self, options: nil)?.first as! UIView)
        contentView.addSubview(mainContentView)
        
        mainContentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        contentView.addGestureRecognizer(tapGes)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapAction() {
        didSelectedCallBack?()
    }
    
    public var model: HCPatientListSectionModel! {
        didSet {
            headerIconOutlet.image = model.headerIcon
            titleOutlet.text = model.title
        }
    }
}
