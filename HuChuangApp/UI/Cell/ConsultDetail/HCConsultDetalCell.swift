//
//  HCConsultDetalMineCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/24.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCConsultDetalCell_identifier = "HCConsultDetalCell_identifier"

class HCConsultDetalCell: UITableViewCell {

    private var nameLabel: UILabel!
    private var avatarButton: UIButton!
    private var contentBgView: UIImageView!
    private var contentTextLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        nameLabel = UILabel()
        nameLabel.font = .font(fontSize: 13, fontName: .PingFRegular)
        nameLabel.textColor = RGB(53, 53, 53)

        avatarButton = UIButton.init(type: .custom)
        avatarButton.layer.cornerRadius = 5
        avatarButton.imageView?.contentMode = .scaleAspectFill
        avatarButton.imageView?.clipsToBounds = true
        avatarButton.isUserInteractionEnabled = false
        avatarButton.backgroundColor = RGB(240, 240, 240)

        contentBgView = UIImageView()
        contentBgView.backgroundColor = RGB(240, 240, 240)

        contentTextLabel = UILabel()
        contentTextLabel.numberOfLines = 0
        contentTextLabel.font = .font(fontSize: 13, fontName: .PingFRegular)
        contentTextLabel.textColor = RGB(53, 53, 53)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(avatarButton)
        contentView.addSubview(contentBgView)
        contentBgView.addSubview(contentTextLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCConsultDetailConsultListModel! {
        didSet {
            nameLabel.text = model.displayName
            avatarButton.setImage(model.avatarURL)
            contentTextLabel.text = model.content
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarButton.frame = model.getAvatarFrame
        nameLabel.frame = model.getNameFrame
        contentBgView.frame = model.getContentBgFrame
        contentTextLabel.frame = model.getContentTextFrame
    }
}
