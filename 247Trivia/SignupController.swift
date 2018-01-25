//
//  SignupController.swift
//  247Trivia
//
//  Created by John Nik on 6/28/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class SignupController: UIViewController, UITextFieldDelegate {
    
    var nameExist = false
    var emailExist = false
    
    var userName = String()
    var email = String()
    
    var profileControllerStatus = ProfileControllerStatus.Signup
    
    let containerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroun.jpg")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.3
        return imageView
    }()
    
    lazy var userImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.imageWithString(name: "user_icon", radius: User_Image_Radius)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var nameTextField: UITextField = {
        
        let tf = UITextField()
        tf.textAlignment = .left
        tf.placeholder = "Username"
        tf.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.045)
        tf.translatesAutoresizingMaskIntoConstraints =  false
        tf.delegate = self
        return tf
        
    }()
    
    let seperatorNameView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var emailTextField: UITextField = {
        
        let tf = UITextField()
        tf.textAlignment = .left
        tf.placeholder = "Email"
        tf.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.045)
        tf.translatesAutoresizingMaskIntoConstraints =  false
        tf.delegate = self
        return tf
        
    }()
    
    let seperatorEmailView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var passwordTextField: UITextField = {
        
        let tf = UITextField()
        tf.textAlignment = .left
        tf.placeholder = "Password"
        tf.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.045)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.delegate = self
        return tf
        
    }()
    
    let seperaterPasswordView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var schoolTextField: UITextField = {
        
        let tf = UITextField()
        tf.textAlignment = .left
        tf.placeholder = "Skolans namn"
        tf.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.045)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        return tf
        
    }()
    
    let seperaterSchoolView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let invalidCommandLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: DEVICE_WIDTH * 0.05)
        label.backgroundColor = UIColor(r: 134, g: 251, b: 236, a: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
        
    }()

    
        let signupButton: UIButton = {
    
            let button = UIButton(type: UIButtonType.system)
            button.setTitle("Update", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.053)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(goingBackSigninController), for: .touchUpInside)
            return button
    
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupBackground()
        setupContainerView()
        setupUserImageView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isNavigationBarHidden = false
        if profileControllerStatus == .Update {
            
            fetchProfileDataFromUserDefaults()
            setupSignupButton()
            passwordTextField.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.038)
            self.tabBarController?.navigationItem.title = "My Profile"
        } else {
            setupNavigationBar()
        }
        
        
    }
    
    func fetchProfileDataFromUserDefaults() {
        
        ProgressHudHelper.showLoadingHud(withText: "Loading...")
        handleUpdate()
        
    }
    
    func handleUpdate() {
        
        let userId = defaults.string(forKey: "userId")
        
        let paramDic = ["action": "GETPROFILE", "userId": userId!] as [String : Any]
        
        API?.executeHTTPRequest(Post, url: GET_PROFILE_URL, parameters: paramDic as! [String: String], completionHandler: { (responseDic) in
            
            self.parseUpdateResponseWith(responseDic: responseDic!)
            
        }, errorHandler: { (error) in
            print("updateError--", error!)
            ProgressHudHelper.hideLoadingHud()
            showAlertMessage(vc: self, titleStr: "Something went wrong!", messageStr: "Try again later")
        })
    }
    
    private func parseUpdateResponseWith(responseDic: [AnyHashable: Any]) {
        
        print(responseDic)
        
        let result = responseDic["status"] as! String
        
        if result == "SUCCESS" {
            ProgressHudHelper.hideLoadingHud()
            
            userName = responseDic["userName"] as! String
            email = responseDic["email"] as! String
            let image = responseDic["image"] as! NSString
            
            nameTextField.text = userName
            emailTextField.text = email
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Leave blank to keep the same password",
                                                                   attributes: [NSForegroundColorAttributeName: UIColor.init(r: 0, g: 0, b: 0, a: 0.9)])
            userImageView.image = UIImage(data: image.base64Data())
            
        } else {
            ProgressHudHelper.hideLoadingHud()
            showAlertMessage(vc: self, titleStr: "Something went wrong!", messageStr: "Try again later")
        }
    }

    
    func handleCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupNavigationBar() {
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign up", style: .plain, target: self, action: #selector(goingBackSigninController))
        
        navigationItem.title = "Creat Account"
        navigationController?.isNavigationBarHidden = false
        
        
        
        
        
    }
    
    private func setupBackground() {
        view.backgroundColor = UIColor(r: 255, g: 89, b: 100, a: 1)
        
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "247_clock")
        backgroundImageView.alpha = 0.4
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(backgroundImageView)
        
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 25).isActive = true
        backgroundImageView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.85).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.85).isActive = true
    }
    
    func setupBackgrounImageView() {
        
        view.addSubview(backgroundImageView)
        
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
    }
    
    func setupUserImageView() {
        
        view.addSubview(userImageView)
        
        userImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: User_Image_Radius * 2).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: User_Image_Radius * 2).isActive = true
        userImageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -DEVICE_WIDTH * 0.08).isActive = true
        
    }
    
    
    func setupContainerView() {
        
        view.addSubview(containerView)
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.73).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.33).isActive = true
        
        containerView.addSubview(nameTextField)
        containerView.addSubview(seperatorNameView)
        containerView.addSubview(emailTextField)
        containerView.addSubview(seperatorEmailView)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(seperaterPasswordView)
        
        
        nameTextField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1 / 3).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        
        seperatorNameView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        seperatorNameView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorNameView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.003).isActive = true
        seperatorNameView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1 / 3).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        
        seperatorEmailView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        seperatorEmailView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorEmailView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.003).isActive = true
        seperatorEmailView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1 / 3).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        
        seperaterPasswordView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        seperaterPasswordView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperaterPasswordView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.003).isActive = true
        seperaterPasswordView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
    }
    
    func setupSignupButton() {

        view.addSubview(signupButton)

        signupButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        signupButton.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.4).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.07).isActive = true
        signupButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: DEVICE_WIDTH * 0.04).isActive = true
    }
    
    func showAlert(warnigString: String) {
        
        view.addSubview(invalidCommandLabel)
        
        invalidCommandLabel.text = warnigString
        
        invalidCommandLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        invalidCommandLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        fadeViewInThenOut(view: invalidCommandLabel, delay: 3)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            
            if profileControllerStatus == .Signup {
                if textField == nameTextField {
                    
                    self.checkExistUserNameAndEmailWith(string: nameTextField.text!, mode: "user_exist")
                    
                    self.perform(#selector(showAlertWithNameExist), with: self, afterDelay: TimeInterval(AlertDelay))
                    
                } else if textField == emailTextField {
                    
                    self.checkExistUserNameAndEmailWith(string: emailTextField.text!, mode: "email_exist")
                    
                    self.perform(#selector(showAlertWithEmailExist), with: self, afterDelay: TimeInterval(AlertDelay))
                }
            } else {
                
                if textField == nameTextField {
                    
                    if nameTextField.text != userName {
                        self.checkExistUserNameAndEmailWith(string: nameTextField.text!, mode: "user_exist")
                        
                        self.perform(#selector(showAlertWithNameExist), with: self, afterDelay: TimeInterval(AlertDelay))
                    }
                    
                } else if textField == emailTextField {
                    
                    if emailTextField.text != email {
                        self.checkExistUserNameAndEmailWith(string: emailTextField.text!, mode: "email_exist")
                        
                        self.perform(#selector(showAlertWithEmailExist), with: self, afterDelay: TimeInterval(AlertDelay))
                    }
                }
            }
        }
    }
    
    @objc private func showAlertWithNameExist() {
        if nameExist == true {
            self.showAlert(warnigString: "Oops! Username Exist")
        }
    }
    
    @objc private func showAlertWithEmailExist() {
        if emailExist == true {
            self.showAlert(warnigString: "Oops! Email Exist")
        }
    }
    
    private func checkExistUserNameAndEmailWith(string: String, mode: String) {
        var paramDic = [String: String]()
      
        if mode == "user_exist" {
            paramDic = ["action": "USER_EXIST", "username": string]
            API?.executeHTTPRequest(Post, url: NANE_EXIST_URL, parameters: paramDic, completionHandler: { (responseDic) in
                
                let result = responseDic?["status"] as! String
                
                if result == "TRUE" {
                    self.nameExist = true
                } else {
                    self.nameExist = false
                }
                
//                DispatchQueue.main.async {
//                    
//                    self.nameExist = self.parseResponseWith(responseDic: responseDic!)
//                    
//                }
                
                
            }, errorHandler: { (error) in
                print("userExistError--", error!)
            })
        } else {
            paramDic = ["action": "EMAIL_EXIST", "email": string]
            API?.executeHTTPRequest(Post, url: EMAIL_EXIST_URL, parameters: paramDic, completionHandler: { (responseDic) in
                
                let result = responseDic?["status"] as! String
                
                if result == "TRUE" {
                    self.emailExist = true
                } else {
                    self.emailExist = false
                }
                
//                DispatchQueue.main.async {
//                    
//                    self.emailExist = self.parseResponseWith(responseDic: responseDic!)
//                    
//                }

                
                
            }, errorHandler: { (error) in
                print("emailExistError--", error!)
            })
        }
    }
    
    private func parseResponseWith(responseDic: [AnyHashable: Any]) -> Bool{
        
        var isExist = true
        
        let result = responseDic["status"] as! String
        
        if result == "TRUE" {
            isExist = true
        } else {
            isExist = false
        }
        
        return isExist
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        schoolTextField.resignFirstResponder()
    }
    
    func checkInvalid() -> Bool {
        
        if (nameTextField.text?.isEmpty)! {
            showAlertMessage(vc: self, titleStr: "Write Username!", messageStr: "ex: Anders703")
            return false
        }
        if (emailTextField.text?.isEmpty)! {
            showAlertMessage(vc: self, titleStr: "Write Email!", messageStr: "ex: Anders703@oulook.com")
            return false
        }
        
        if profileControllerStatus == .Signup {
            if (passwordTextField.text?.isEmpty)! {
                showAlertMessage(vc: self, titleStr: "Write Password!", messageStr: "t.ex: Belle@703")
                return false
            }

        }
        
        
        return true
    }
    
    
}

