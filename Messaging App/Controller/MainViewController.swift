//
//  ViewController.swift
//  Messaging App
//
//  Created by AhmetSerkan on 8.09.2019.
//  Copyright © 2019 Ahmet Serkan. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    var containerView = UIView(frame: CGRect())
    var usernameField = UITextField(frame: CGRect())
    var continueButton = UIButton(frame: CGRect())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        let username = Store.retrieveData()
        
        if username != "" {
            let vc = MessagingViewController()
            vc.title = username
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setupView() {
        navigationController?.isNavigationBarHidden = true
        
        setupConstraints()
        
        usernameField.placeholder = "Username"
        usernameField.borderStyle = .roundedRect
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.textColor = .white
        continueButton.backgroundColor = .blue
        continueButton.layer.cornerRadius = 5
        continueButton.layer.borderWidth = 1
        continueButton.layer.borderColor = UIColor.blue.cgColor
        continueButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    func setupConstraints() {
        view.addSubview(containerView)
        containerView.addSubview(usernameField)
        containerView.addSubview(continueButton)
        
        containerView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.centerY.equalTo(self.view.snp.centerY)
            make.height.equalTo(80)
        }
        
        usernameField.snp.makeConstraints { (make) in
            make.width.equalTo(self.containerView.snp.width).multipliedBy(0.8)
            make.top.equalTo(self.containerView.snp.top)
            make.centerX.equalTo(self.containerView.snp.centerX)
        }
        
        continueButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.usernameField.snp.width)
            make.bottom.equalTo(self.containerView.snp.bottom)
            make.centerX.equalTo(self.containerView.snp.centerX)
        }
    }
    
    @objc func buttonAction() {
        
        let text = usernameField.text ?? ""
        
        //MARK: CHECK IF ENTERED TEXT IS LONGER THAN TWO CHARACTERS
        
        if text.count > 2 {
            //MARK: STORE ENTERED USERNAME
            Store.updateData(username: text)
            
            //MARK: INSTANTIATE MESSAGING SCREEN WITH USERNAME PROPERTY
            let vc = MessagingViewController()
            vc.title = text
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            //MARK: IF THE ENTERED TEXT IS NOT LONGER THAN TWO CHARACTERS, SHOW ALERT
            let alert = UIAlertController(title: "Username is too short!", message: "Username must be longer than two characters.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

