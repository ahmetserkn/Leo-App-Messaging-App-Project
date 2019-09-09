//
//  MessagingViewController.swift
//  Messaging App
//
//  Created by AhmetSerkan on 8.09.2019.
//  Copyright © 2019 Ahmet Serkan. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

class MessagingViewController: UIViewController {
    
    let url = "https://jsonblob.com/api/jsonBlob/4f421a10-5c4d-11e9-8840-0b16defc864d"
    var messages = [Message]()
    
    var containerView = UIView(frame: CGRect())
    var messageField = UITextField(frame: CGRect())
    var sendButton = UIButton(frame: CGRect())

    var messagesView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let view = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        view.register(MessageCell.self, forCellWithReuseIdentifier: "messageCell")
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        messagesView.dataSource = self
        messagesView.delegate = self
        
        //MARK: RETRIEVE API DATA
        getData { (response) in
            self.messages = response
            self.setupMessages()
        }
        
        setupView()
    }
    
    func setupView() {
        containerView.backgroundColor = .cyan
        
        messageField.placeholder = "Your message"
        messageField.borderStyle = .roundedRect
        messageField.backgroundColor = .white
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.textColor = .white
        sendButton.backgroundColor = .blue
        sendButton.layer.cornerRadius = 5
        sendButton.layer.borderWidth = 1
        sendButton.layer.borderColor = UIColor.blue.cgColor
        sendButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        view.addSubview(messagesView)
        view.addSubview(containerView)
        containerView.addSubview(messageField)
        containerView.addSubview(sendButton)
        
        containerView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(60)
        }
        
        messageField.snp.makeConstraints { (make) in
            make.left.equalTo(self.containerView.snp.left).inset(20)
            make.centerY.equalTo(self.containerView.snp.centerY)
            make.width.equalTo(self.containerView.snp.width).multipliedBy(0.7)
        }
        
        sendButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.messageField.snp.right).offset(20)
            make.right.equalTo(self.containerView.snp.right).inset(20)
            make.centerY.equalTo(self.containerView.snp.centerY)
        }
        
        messagesView.snp.makeConstraints { (make) in
            make.width.equalTo(self.containerView.snp.width)
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.containerView.snp.top)
        }
    }
    
    //MARK: ANIMATED AUTO-SCROLL COLLECTIONVIEW TO KEEP LAST MESSAGES ON SCREEN
    func setupMessages() {
        let item = messages.count - 1
        messagesView.reloadData()
        messagesView.scrollToItem(at: IndexPath(item: item, section: 0), at: .bottom, animated: true)
    }
    
    //MARK: GET METHOD FOR API AND PARSE JSON DATA
    func getData(completion: @escaping ([Message])->Void) {
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                guard let data = response.data else {return}
                do {
                    let parsedData = try JSONDecoder().decode([Message].self, from: data)
                    completion(parsedData)
                } catch {}
            }
        }
    }
    
    @objc func buttonAction() {
    
        //MARK: CHECK IF TEXT FIELD IS EMPTY OR NOT
        guard let text = messageField.text else {return}
        if text == "" {return}
        
        var newMessage = Message()
        newMessage.id = messages.count
        newMessage.text = text
        newMessage.isSelf = true
        messages.append(newMessage)
        messageField.text = nil
        setupMessages()
        self.view.layoutIfNeeded()
        self.view.layoutSubviews()
        self.view.updateConstraints()
    }
    
    //MARK: GET ESTİMATED CELL SIZE ACCORDİNG TO THE GIVEN TEXT
    func getCellSize(text: String, width: Int) -> CGSize {
        
        let size = CGSize(width: width, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return CGSize(width: CGFloat(width), height: estimatedFrame.height)
    }
    
}

extension MessagingViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath) as! MessageCell
        
        //MARK: CHECK IF THE MESSAGE BELONGS TO SELF
        if let isSelf = messages[indexPath.row].isSelf {
            cell.setupCell(
                imageUrl: "https://www.library.caltech.edu/sites/default/files/styles/headshot/public/default_images/user.png?itok=1HlTtL2d",
                messageText: messages[indexPath.row].text ?? "",
                selfMessage: isSelf,
                screenWidth: Int(self.view.bounds.width)
            )
        } else {
            cell.setupCell(
                imageUrl: messages[indexPath.row].user?.avatarUrl ?? "",
                messageText: messages[indexPath.row].text ?? "",
                selfMessage: false,
                screenWidth: Int(self.view.bounds.width)
            )
        }
        
        return cell
    }
}

extension MessagingViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.bounds.width - 20
        let height = self.getCellSize(text: messages[indexPath.row].text ?? "", width: Int(width)).height + 25
        return CGSize(width: width, height: height)
    }
}
