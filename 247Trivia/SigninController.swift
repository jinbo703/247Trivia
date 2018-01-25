//
//  SigninController.swift
//  247Trivia
//
//  Created by John Nik on 6/28/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class SigninController: UIViewController, UITextFieldDelegate {
    
    var homeController: HomeTapBarController?
    var signupController : SignupController?
    
    let containerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroun.jpg")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.7
        return imageView
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
    
    let welcomeLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Welcome to 24/7 Trivia!"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: DEVICE_WIDTH * 0.06)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Forgot Password?", for: .normal)
        button.tintColor  = UIColor.black
        button.titleLabel?.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.05)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return button
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
    
    func handleForgotPassword() {
        
        let alert = UIAlertController(title: "Forgot password?", message: "Type your email", preferredStyle: .alert)
        
        let OkAction = UIAlertAction(title: "Ok!", style: .default) { (action) in
            
            ProgressHudHelper.showLoadingHud(withText: "Please wait...")
            
            let textField = alert.textFields![0]
            textField.placeholder = "1"
            
            if textField.text == "" {
                ProgressHudHelper.hideLoadingHud()
                
                self.showAlert(warnigString: "Oops! Write youremail")
            } else {
                
                self.handleForgotPasswordWithEmail(email: textField.text!)
                
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addTextField { (textField: UITextField) in
            
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Email"
            textField.clearButtonMode = .whileEditing
            
        }
        
        alert.addAction(OkAction)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func handleForgotPasswordWithEmail(email: String) {
        
        let paramDic = ["email": email] as [String : Any]
        
        API?.executeHTTPRequest(Post, url: FORGOT_PASSWORD_URL, parameters: paramDic as! [String: String], completionHandler: { (responseDic) in
            
            self.parseForgotPasswordResponseWith(responseDic: responseDic!)
            
        }, errorHandler: { (error) in
            print("ForgotPasswordError--", error!)
            ProgressHudHelper.hideLoadingHud()
            showAlertMessage(vc: self, titleStr: "Something went wrong!", messageStr: "Try again later")
        })
        
        
    }
    
    private func parseForgotPasswordResponseWith(responseDic: [AnyHashable: Any]) {
        
        print(responseDic)
        
        let result = responseDic["status"] as! String
        
        
        if result == "SUCCESS" {
            
            ProgressHudHelper.hideLoadingHud()
            showAlertMessage(vc: self, titleStr: "Success!", messageStr: "Please check your email")
            
        } else {
            ProgressHudHelper.hideLoadingHud()
            
            showAlertMessage(vc: self, titleStr: "Invalid Email!", messageStr: "Please type your correct info")
        }
        
    }

    
    func showAlert(warnigString: String) {
        
        view.addSubview(invalidCommandLabel)
        
        invalidCommandLabel.text = warnigString
        
        invalidCommandLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        invalidCommandLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        fadeViewInThenOut(view: invalidCommandLabel, delay: 3)
        
    }
    
        
    let signinButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Log in", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.053)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSignin), for: .touchUpInside)
        return button
        
    }()
    
    func handleSignin() {
        
        ProgressHudHelper.showLoadingHud(withText: "Please wait...")
        
        if !(checkInvalid()) {
            ProgressHudHelper.hideLoadingHud()
            return
        }
        
        let checkConnection = RKCommon.checkInternetConnection()
        
        if !checkConnection {
            ProgressHudHelper.hideLoadingHud()
            
            showAlertMessage(vc: self, titleStr: "Connection Error", messageStr: "No Active Connection Found")
            return
        }
        
        handleSigninWithServer()
    }
    
    func handleSigninWithServer() {
        
        //        let passwordEncode = passwordTextField.text?.data(using: .utf8)
        
        let paramDic = ["action": "SIGNIN", "email": emailTextField.text!, "password": passwordTextField.text!] as [String : Any]
        
        API?.executeHTTPRequest(Post, url: SIGNIN_URL, parameters: paramDic as! [String: String], completionHandler: { (responseDic) in
            
            self.parseResponseWith(responseDic: responseDic!)
            
        }, errorHandler: { (error) in
            print("signupError--", error!)
            ProgressHudHelper.hideLoadingHud()
            showAlertMessage(vc: self, titleStr: "Something went wrong!", messageStr: "Try again later")
        })
        
        
    }
    
    private func parseResponseWith(responseDic: [AnyHashable: Any]) {
        
        print(responseDic)
        
        let result = responseDic["status"] as! String
        
        
        if result == "SUCCESS" {
            let userId = responseDic["user_id"] as! String
            
            defaults.set(userId, forKey: "userId")
            
            defaults.set(true, forKey: "IsLogin")
            defaults.synchronize()
            
            ProgressHudHelper.hideLoadingHud()
            self.homeController?.setupControllers()
            self.dismiss(animated: true, completion: nil)
            
        } else {
            ProgressHudHelper.hideLoadingHud()
            
            if result == "UNVERIFIED" {
                showAlertMessage(vc: self, titleStr: "Unverified User!", messageStr: "Please check your email")
            } else if result == "INVALID" {
                showAlertMessage(vc: self, titleStr: "Invalid username or password", messageStr: "Please type your correct info")
            } else {
                showAlertMessage(vc: self, titleStr: "Something went wrong!", messageStr: "Try again later")
            }
        }
        
    }

    
    let signinWithFbButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Sign in with Facebook", for: .normal)
        button.backgroundColor = UIColor(r: 66, g: 133, b: 250)
        button.tintColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    let signinWithGoogleButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Sign in with Google+", for: .normal)
        button.backgroundColor = UIColor(r: 255, g: 87, b: 34)
        button.tintColor = UIColor.black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    
    let signupContainerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let signupLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Don't have an account?"
        label.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.048)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let signupButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Sign up!", for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.053)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goingSignupController), for: .touchUpInside)
        return button
        
    }()
    
    func goingSignupController() {
        
        let signupController = SignupController()
        signupController.profileControllerStatus = .Signup
        navigationController?.pushViewController(signupController, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        
        
        
        view.addSubview(backgroundImageView)
        view.addSubview(containerView)
        view.addSubview(welcomeLabel)
        view.addSubview(signinButton)
        view.addSubview(signupContainerView)
        view.addSubview(forgotPasswordButton)
        
        setupBackgrounImageView()
        setupContainerView()
        setupOtherViews()
        setupButtons()
        setupSignupContainerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isNavigationBarHidden = true
        
    }
    
    private func setupBackground() {
        
        navigationController?.isNavigationBarHidden = true
        
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
        
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
    }
    
    func setupContainerView() {
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.73).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.2).isActive = true
        
        containerView.addSubview(emailTextField)
        containerView.addSubview(seperatorEmailView)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(seperaterPasswordView)
        
        emailTextField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1 / 2).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        
        seperatorEmailView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        seperatorEmailView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorEmailView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.003).isActive = true
        seperatorEmailView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1 / 2).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        
        seperaterPasswordView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        seperaterPasswordView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperaterPasswordView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.003).isActive = true
        seperaterPasswordView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
    }
    
    func setupOtherViews(){
        
        welcomeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        welcomeLabel.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -DEVICE_WIDTH * 0.2).isActive = true
    }
    
    
    func setupButtons() {
        
        signinButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        signinButton.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.3).isActive = true
        signinButton.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.08).isActive = true
        signinButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: DEVICE_WIDTH * 0.08).isActive = true
        
        forgotPasswordButton.topAnchor.constraint(equalTo: signinButton.bottomAnchor, constant: DEVICE_WIDTH * 0.002).isActive = true
        forgotPasswordButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        forgotPasswordButton.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.15).isActive = true
    }
    
    func setupSignupContainerView() {
        
        signupContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        signupContainerView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.77).isActive = true
        signupContainerView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.085).isActive = true
        
        signupContainerView.addSubview(signupLabel)
        signupContainerView.addSubview(signupButton)
        
        signupButton.rightAnchor.constraint(equalTo: signupContainerView.rightAnchor).isActive = true
        signupButton.centerYAnchor.constraint(equalTo: signupContainerView.centerYAnchor).isActive = true
        signupButton.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.18)
        signupButton.heightAnchor.constraint(equalTo: signupContainerView.heightAnchor).isActive = true
        
        signupLabel.centerYAnchor.constraint(equalTo: signupContainerView.centerYAnchor).isActive = true
        signupLabel.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.55).isActive = true
        signupLabel.heightAnchor.constraint(equalTo: signupContainerView.heightAnchor).isActive = true
        signupLabel.leftAnchor.constraint(equalTo: signupContainerView.leftAnchor).isActive = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }
    
    func checkInvalid() -> Bool {
        if (emailTextField.text?.isEmpty)! {
            showAlertMessage(vc: self, titleStr: "Write email!", messageStr: "ex: Anders703@oulook.com")
            return false
        }
        if (passwordTextField.text?.isEmpty)! {
            showAlertMessage(vc: self, titleStr: "Write Password!", messageStr: "t.ex: Anders@703")
            return false
        }
        
        return true
    }
}

