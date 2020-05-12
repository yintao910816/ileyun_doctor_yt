//
//  MineHeader.swift
//  HuChuangApp
//
//  Created by yintao on 2019/2/13.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class MineHeaderView: UIView {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var userIconOutlet: UIButton!
    @IBOutlet weak var nickNameOutlet: UILabel!
    @IBOutlet weak var idOutlet: UILabel!
    @IBOutlet var contentView: UIView!
    
    public let userModel = PublishSubject<HCUserModel>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("MineHeaderView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
        setupUI()
        rxBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {

    }
        
    private func rxBind() {
        userModel.subscribe(onNext: { [weak self] user in
            self?.userIconOutlet.setImage(user.imgUrl)
            self?.nickNameOutlet.text = user.realName
            self?.idOutlet.text = user.id
        })
            .disposed(by: disposeBag)
    }
}
