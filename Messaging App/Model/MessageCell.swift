//
//  MessageCell.swift
//  Messaging App
//
//  Created by AhmetSerkan on 8.09.2019.
//  Copyright © 2019 Ahmet Serkan. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

class MessageCell: UICollectionViewCell {
    
    let cellView = UIView()
    let profileImage = UIImageView()
    let messageView = UIView()
    let messageLabel = UILabel()
    
    
    func setupCell(imageUrl: String, messageText: String, selfMessage: Bool, screenWidth: Int) {
        let width = Double(screenWidth)
        addSubview(cellView)
        cellView.addSubview(profileImage)
        cellView.addSubview(messageView)
        messageView.addSubview(messageLabel)
        
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(with: URL(string: imageUrl))
        
        messageView.backgroundColor = .blue
        messageView.layer.cornerRadius = 5
        
        messageLabel.text = messageText
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.textColor = .white
        
        cellView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints { (make) in
            make.top.equalTo(self.cellView.snp.top)
            make.width.equalTo(25)
            make.height.equalTo(25)
            if selfMessage {
                make.right.equalTo(self.cellView.snp.right)
            } else {
                make.left.equalTo(self.cellView.snp.left)
            }
        }
        
//        messageView.translatesAutoresizingMaskIntoConstraints = false
//        messageView.topAnchor.constraint(equalTo: profileImage.topAnchor).isActive = true
//        NSLayoutConstraint(item: messageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.getCellSize(text: messageText, width: Int(width * 0.7)).height).isActive = true
//        NSLayoutConstraint(item: messageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: CGFloat(width * 0.7)).isActive = true
        
        messageView.snp.makeConstraints { (make) in
//
            make.top.equalTo(self.profileImage.snp.top)
            make.width.equalTo(Int(width * 0.7))
            make.height.equalTo(self.getCellSize(text: messageText, width: Int(width * 0.7)).height)
            if selfMessage {
                make.right.equalTo(self.profileImage.snp.left).offset(-10)
            } else {
                make.left.equalTo(self.profileImage.snp.right).offset(10)
            }
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.width.equalTo(self.messageView.snp.width).offset(-10)
            make.centerX.equalTo(self.messageView.snp.centerX)
            make.centerY.equalTo(self.messageView.snp.centerY)
        }
    }
    
    func getCellSize(text: String, width: Int) -> CGSize {
        
        let size = CGSize(width: width, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return CGSize(width: CGFloat(width), height: estimatedFrame.height + 10)
    }
}
