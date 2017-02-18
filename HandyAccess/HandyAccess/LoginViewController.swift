//
//  ViewController.swift
//  HandyAccess
//
//  Created by Karen Fuentes on 2/17/17.
//  Copyright © 2017 NYCHandyAccess. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth


class ViewController: UIViewController {
    
    let databaseReference = FIRDatabase.database().reference().child("Users")
    var databaseObserver:FIRDatabaseHandle?
    var signInUser: FIRUser?
    var users = [Users]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setupViewHierarchy() {
        self.edgesForExtendedLayout = []
     
        self.view.addSubview(logoImageView)
        self.view.addSubview(emailTextField)
        self.view.addSubview(emailLineView)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(passwordLineView)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
        
        loginButton.addTarget(self, action: #selector(didTapLogin(sender:)) , for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registeredPressed(sender:)), for: .touchUpInside)
    }
    
    func configureConstraints() {
        
        logoImageView.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalToSuperview().offset(10)
        }
        
        emailTextField.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.width.equalToSuperview().multipliedBy(0.8)
            view.top.equalTo(logoImageView.snp.bottom).offset(40)
        }
        
        emailLineView.snp.makeConstraints { (view) in
            view.leading.trailing.equalTo(emailTextField)
            view.top.equalTo(emailTextField.snp.bottom)
            view.height.equalTo(1)
        }
        
        passwordTextField.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.width.equalToSuperview().multipliedBy(0.8)
            view.top.equalTo(emailTextField.snp.bottom).offset(30)
        }
        
        passwordLineView.snp.makeConstraints { (view) in
            view.leading.trailing.equalTo(passwordTextField)
            view.top.equalTo(passwordTextField.snp.bottom)
            view.height.equalTo(1)
        }
        
        registerButton.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-25)
            view.leading.equalToSuperview().offset(70)
            view.trailing.equalToSuperview().inset(70)
            view.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.bottom.equalTo(registerButton.snp.top).inset(-10)
            view.width.equalTo(registerButton)
            view.height.equalTo(registerButton)
        }
    }
    
    // MARK: - Actions
    
    func didTapLogin(sender: UIButton) {
        sender.backgroundColor = Colors.accentColor
        sender.setTitleColor(Colors.primaryColor, for: .normal)
        
        if let email = emailTextField.text,
            let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                
                
                if user != nil {
                    let newViewController = LogInUserViewController()
                    if let tabVC =  self.navigationController {
                        tabVC.show(newViewController, sender: nil)
                    }
                } else {
                    self.resetButtonColors()
                }
            })
        }
    }
    
    func registeredPressed(sender: UIButton) {
        sender.backgroundColor = Colors.accentColor
        sender.setTitleColor(Colors.primaryColor, for: .normal)
        
        
        if let email = emailTextField.text,
            let password = passwordTextField.text {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                if error != nil {
                    print (error)
                    return
                }
                guard let uid = user?.uid else {return}
                let values = ["email": email]
                
                self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                
            })
        }
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: Any]) {
        
        let userReference = self.databaseReference.child(uid)
        userReference.updateChildValues(values)
        
//        let newViewController = MAPViewController
//        if let tabVC =  self.navigationController {
//            tabVC.show(newViewController, sender: nil)
//        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetButtonColors()
    }
    
    
    func resetButtonColors() {
        loginButton.backgroundColor = Colors.primaryColor
        loginButton.setTitleColor(Colors.text_iconsColor, for: .normal)
        
        registerButton.backgroundColor = Colors.primaryColor
        registerButton.setTitleColor(Colors.text_iconsColor, for: .normal)
    }




    lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "logo")
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 5
        return view
    }()
    
    lazy var emailTextField: UITextField = {
        let view = UITextField()
        view.text = "Email"
        view.textAlignment = .left
        view.textColor = Colors.accentColor
        view.clipsToBounds = false
        return view
    }()
    
    internal lazy var emailLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = Colors.text_iconsColor
        return view
    }()
    
    lazy var passwordTextField: UITextField = {
        let view = UITextField()
        view.text = "Password"
        view.textColor = Colors.accentColor
        view.textAlignment = .left
        return view
    }()
    
    internal lazy var passwordLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = Colors.text_iconsColor
        
        return view
    }()
    
    lazy var loginButton: UIButton = {
        let button: UIButton = UIButton(type: .roundedRect)
        button.setTitle("LOGIN", for: .normal)
        button.setTitleColor(Colors.text_iconsColor, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightSemibold)
        button.layer.borderWidth = 2.0
        button.layer.borderColor = Colors.text_iconsColor.cgColor
        button.contentEdgeInsets = UIEdgeInsetsMake(15.0, 0.0, 15.0, 0.0)
        button.alpha = 0.6
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button: UIButton = UIButton(type: .roundedRect)
        button.setTitle("REGISTER", for: .normal)
        button.setTitleColor(Colors.text_iconsColor, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightSemibold)
        button.layer.borderWidth = 2.0
        button.layer.borderColor = Colors.text_iconsColor.cgColor
        button.contentEdgeInsets = UIEdgeInsetsMake(15.0, 0.0, 15.0, 0.0)
        button.alpha = 0.6
        return button
    }()
}
