//
//  HCConsultDetailSectionHeader.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/23.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCConsultDetailSectionHeader_identifier = "HCConsultDetailSectionHeader_identifier"

class HCConsultDetailSectionHeader: UITableViewHeaderFooterView {

    private var timeLabel: UILabel!
    private var avatarButton: UIButton!
    private var textBgView: UIImageView!
    private var contentLabel: UILabel!
    private var boxPhotoView: HCBoxPhotoView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        timeLabel = UILabel()
        timeLabel.textAlignment = .center
        timeLabel.font = .font(fontSize: 13, fontName: .PingFRegular)
        timeLabel.textColor = RGB(169, 169, 169)
        
        avatarButton = UIButton.init(type: .custom)
        avatarButton.layer.cornerRadius = 5
        avatarButton.imageView?.contentMode = .scaleAspectFill
        avatarButton.imageView?.clipsToBounds = true
        avatarButton.isUserInteractionEnabled = false
        avatarButton.backgroundColor = RGB(240, 240, 240)
        
        textBgView = UIImageView()
        textBgView.backgroundColor = RGB(240, 240, 240)
        
        contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = .font(fontSize: 13, fontName: .PingFRegular)
        contentLabel.textColor = RGB(53, 53, 53)

        boxPhotoView = HCBoxPhotoView()
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(avatarButton)
        contentView.addSubview(textBgView)
        textBgView.addSubview(contentLabel)
        contentView.addSubview(boxPhotoView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var sectionModel: HCConsultDetailItemModel! {
        didSet {
            timeLabel.text = sectionModel.startDate
            avatarButton.setImage(sectionModel.headPath)
            contentLabel.text = sectionModel.content
            boxPhotoView.filles = sectionModel.fileList
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        timeLabel.frame = sectionModel.getTimeFrame
        avatarButton.frame = sectionModel.getAvatarFrame
        textBgView.frame = sectionModel.getContentBgFrame
        contentLabel.frame = sectionModel.getContentTextFrame
        boxPhotoView.frame = sectionModel.getBoxPhotoFrame
    }
}
