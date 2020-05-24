//
//  HCConsultDetail.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/23.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCConsultDetailModel: HJModel {
    var records: [HCConsultDetailItemModel] = []
}

class HCConsultDetailItemModel: HJModel {
    var id: String = ""
    var memberId: String = ""
    var memberName: String = ""
    var userId: String = ""
    var userName: String = ""
    var content: String = ""
    var filePaths: String = ""
    var fileList: [HCConsultDetailFileModel] = []
    var newConsultUserId: String = ""
    var replyStatus: String = ""
    var reviewNumber: String = ""
    var paymentStatus: String = ""
    var createDate: String = ""
    var headPath: String = ""
    var code: String = ""
    var price: String = ""
    var consultReplies: String = ""
    var consultList: [HCConsultDetailConsultListModel] = []
    var type: Int = 0
    var unit: String = ""
    var withDrawReason: String = ""
    var question: String = ""
    var tagName: String = ""
    var bak: String = ""
    var black: String = ""
    var age: String = ""
    var consultAgain: String = ""
    var startDate: String = ""
    var endDate: String = ""
    var unitName: String = ""
    var read: String = ""
    
    private var timeFrame: CGRect = .zero
    private var avatarFrame: CGRect = .zero
    private var contentBgFrame: CGRect = .zero
    private var contentTextFrame: CGRect = .zero
    private var boxPhotoFrame: CGRect = .zero

    private var sectionHeaderSize: CGSize = .zero
    
    public var getTimeFrame: CGRect {
        get {
            if timeFrame == .zero {
                timeFrame = .init(x: 15, y: 10, width: PPScreenW - 30, height: 13)
            }
            return timeFrame
        }
    }
    
    public var getAvatarFrame: CGRect {
        get {
            if avatarFrame == .zero {
                avatarFrame = .init(x: 15, y: getTimeFrame.maxY + 15, width: 41, height: 41)
            }
            return avatarFrame
        }
    }

    public var getContentBgFrame: CGRect {
        get {
            if contentBgFrame == .zero {
                contentBgFrame = .init(x: getAvatarFrame.maxX + 10, y: getAvatarFrame.minY,
                                       width: getContentTextFrame.width + 20,
                                       height: getContentTextFrame.height + 26)
            }
            return contentBgFrame
        }
    }
    
    public var getContentTextFrame: CGRect {
        get {
            if contentTextFrame == .zero {
                let contentTextSize = content.ty_textSize(font: .font(fontSize: 13, fontName: .PingFRegular),
                                                          width: PPScreenW - getAvatarFrame.maxX - 20 - 56,
                                                          height: CGFloat(MAXFLOAT))
                contentTextFrame = .init(x: 10, y: 13, width: contentTextSize.width, height: contentTextSize.height)
            }
            return contentTextFrame
        }
    }

    public var getBoxPhotoFrame: CGRect {
        get {
            if boxPhotoFrame == .zero {
                let boxSize = HCBoxPhotoView.contentSize(with: fileList.count)
                boxPhotoFrame = .init(x: getContentBgFrame.minX, y: getContentBgFrame.maxY + 10,
                                      width: boxSize.width,
                                      height: boxSize.height)
            }
            return boxPhotoFrame
        }
    }
    
    public var getSectionHeaderSize: CGSize {
        get {
            if sectionHeaderSize == .zero {
                if fileList.count > 0 {
                    sectionHeaderSize = .init(width: PPScreenW, height: getBoxPhotoFrame.maxY)
                }else {
                    let maxH = max(getAvatarFrame.maxY + 10, getContentBgFrame.maxY + 10)
                    sectionHeaderSize = .init(width: PPScreenW, height: maxH)
                }
            }
            return sectionHeaderSize
        }
    }
}

class HCConsultDetailFileModel: HJModel {
    var filePath: String = ""
    
//    var photoItemSize: CGSize = .init(width: 0, height: 0)
}

class HCConsultDetailConsultListModel: HJModel {
    var id: String = ""
    var userType: String = ""
    var memberId: String = ""
    var memberName: String = ""
    var memberHeadPath: String = ""
    var userId: String = ""
    var userName: String = ""
    var userHeadPath: String = ""
    var content: String = ""
    var replyStatus: String = ""
    var read: String = ""
    var createDate: String = ""
    var fileList: [String] = []
    var bak: String = ""
    
    /// 新加参数
    var timeString: String = ""
    var cellIdentifier: String = HCConsultDetalCell_identifier
    
    private var avatarFrame: CGRect = .zero
    private var nameFrame: CGRect = .zero
    private var contentBgFrame: CGRect = .zero
    private var contentTextFrame: CGRect = .zero

    private var timeFrame: CGRect = .zero
    
    private var cellHeight: CGFloat = 0
    
    public lazy var isMine: Bool = {
        return self.userType == "user"
    }()
    
    public lazy var displayName: String = {
        return self.isMine ? self.userName : self.memberName
    }()
    
    public lazy var avatarURL: String = {
        return self.isMine ? self.userHeadPath : self.memberHeadPath
    }()
    
    public var getAvatarFrame: CGRect {
        get {
            if avatarFrame == .zero {
                if isMine {
                    avatarFrame = .init(x: PPScreenW - 15 - 41, y: 10, width: 41, height: 41)
                }else {
                    avatarFrame = .init(x: 15, y: 10, width: 41, height: 41)
                }
            }
            return avatarFrame
        }
    }
    
    public var getNameFrame: CGRect {
        get {
            if nameFrame == .zero && isMine {
                let nameSize = displayName.ty_textSize(font: .font(fontSize: 13, fontName: .PingFRegular),
                                                   width: CGFloat(MAXFLOAT),
                                                   height: 13)
                if isMine {
                    nameFrame = .init(x: PPScreenW - 66 - nameSize.width, y: 10, width: nameSize.width, height: nameSize.height)
                }else {
                    nameFrame = .zero
                }
            }
            return nameFrame
        }
    }

    public var getContentBgFrame: CGRect {
        get {
            if contentBgFrame == .zero {
                let bgSize = CGSize.init(width: getContentTextFrame.size.width + 20, height: getContentTextFrame.size.height + 26)
                if isMine {
                    contentBgFrame = .init(x: PPScreenW - bgSize.width - 66, y: getNameFrame.maxY + 10, width: bgSize.width, height: bgSize.height)
                }else {
                    contentBgFrame = .init(x: 66, y: getNameFrame.maxY + 10, width: bgSize.width, height: bgSize.height)
                }
            }
            return contentBgFrame
        }
    }

    public var getContentTextFrame: CGRect {
        get {
            if contentTextFrame == .zero {
                let contentTextSize = content.ty_textSize(font: .font(fontSize: 13, fontName: .PingFRegular),
                                                          width: PPScreenW - 75 - 76,
                                                          height: CGFloat(MAXFLOAT))
                contentTextFrame = .init(x: 10, y: 13, width: contentTextSize.width, height: contentTextSize.height)
            }
            return contentTextFrame
        }
    }
   
    public var getTimeFrame: CGRect {
        get {
            if timeFrame == .zero {
                let w = timeString.ty_textSize(font: .font(fontSize: 12, fontName: .PingFMedium), width: CGFloat(MAXFLOAT), height: 18).width + 30
                timeFrame = .init(x: (PPScreenW - w) / 2.0, y: 15, width: w, height: 18)
            }
            return timeFrame
        }
    }
    
    public var getCellHeight: CGFloat {
        get {
            if cellHeight == 0 {
                if cellIdentifier == HCConsultDetalCell_identifier {
                    cellHeight = getContentBgFrame.maxY + 10
                }else {
                    cellHeight = 47
                }
            }
            return cellHeight
        }
    }
}
