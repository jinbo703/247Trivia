//
//  SignupController+handlers.swift
//  247Trivia
//
//  Created by John Nik on 6/23/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

extension SignupController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    func goingBackSigninController() {
        
        let alert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
        
        let OkAction = UIAlertAction(title: "Ok!", style: .default) { (action) in
            ProgressHudHelper.showLoadingHud(withText: "Please wait...")
            
            
            if !(self.checkInvalid()) {
                ProgressHudHelper.hideLoadingHud()
                return
            }
            
            if self.profileControllerStatus == .Signup {
                if self.nameExist == true {
                    ProgressHudHelper.hideLoadingHud()
                    self.showAlert(warnigString: "Oops! Email Exist")
                    return
                }
                
                if self.emailExist == true {
                    ProgressHudHelper.hideLoadingHud()
                    self.showAlert(warnigString: "Oops! Email Exist")
                    return
                }
            }
            
            let checkConnection = RKCommon.checkInternetConnection()
            
            if !checkConnection {
                ProgressHudHelper.hideLoadingHud()
                
                showAlertMessage(vc: self, titleStr: "Connection Error", messageStr: "No Active Connection Found")
                return
            }
            
            self.handleSignup()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(OkAction)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func handleSignup() {
        
        let base64Image = UIImagePNGRepresentation(userImageView.image!)?.base64EncodedString(options: .lineLength64Characters)
        
        var action = "SIGNUP"
        var url = SIGNUP_URL
        var userId = "0"
        if profileControllerStatus == .Update || profileControllerStatus == .Photo {
            action = "UPDATE_PROFILE"
            url = UPDATE_URL
            userId = defaults.string(forKey: "userId")!
            
        }
        
        let paramDic = ["action": action, "userId": userId, "username": nameTextField.text!, "email": emailTextField.text!, "password": passwordTextField.text == "" ? "" : passwordTextField.text!, "profile_image": base64Image!] as [String : Any]
        
        API?.executeHTTPRequest(Post, url: url, parameters: paramDic , completionHandler: { (responseDic) in
            
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
            ProgressHudHelper.hideLoadingHud()
            
            if profileControllerStatus == .Signup {
                self.showErrorAlert("Success!", message: "Please check your email", action: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }, completion: nil)
            } else {
                
                let emailStatus = responseDic["email_status"] as! String
                
                userName = nameTextField.text!
                
                if emailStatus == "CHANGED" {
                    self.showErrorAlert("Success!", message: "Please check your email", action: { (action) in
                        self.handleMore()
                    }, completion: nil)
                } else {
                    self.showErrorAlert(message: "Success!")
                }
                
                
            }
            
            
            
            
            
//            let alert = UIAlertController(title: "Success!", message: "Please check your email", preferredStyle: .alert)
//            
//            let OkAction = UIAlertAction(title: "Ok!", style: .default) { (action) in
//                self.navigationController?.popViewController(animated: true)
//            }
//            alert.addAction(OkAction)
//            self.present(alert, animated: true, completion: nil)
            
            
        } else {
            ProgressHudHelper.hideLoadingHud()
            showAlertMessage(vc: self, titleStr: "Something went wrong!", messageStr: "Try again later")
        }

        
        
    }
    
    func handleMore() {
        //        do {
        //            try Auth.auth().signOut()
        //        } catch let logoutError {
        //            print(logoutError)
        //        }
        
        let loginController = SigninController()
        loginController.signupController = self
        let naviController = UINavigationController(rootViewController: loginController)
        present(naviController, animated: true, completion: nil)
        
    }

    
    private func registerUserIntoDatabaseWithUid(uid: String, values: [String: AnyObject]) {
        
        ProgressHudHelper.hideLoadingHud()
        self.navigationController?.popViewController(animated: true)
        
    }

    
    func handleSelectProfileImageView() {
        
        let alertController = UIAlertController(title: "Select photo?", message: "", preferredStyle: .actionSheet)
        
        let photoGalleryAction = UIAlertAction(title: "Select a photo", style: .default) { (action) in
            
            let picker = UIImagePickerController()
            
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            picker.sourceType = .savedPhotosAlbum
            
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                
                picker.modalPresentationStyle = .popover
                picker.popoverPresentationController?.delegate = self
                //                picker.popoverPresentationController?.sourceView = self.view
                self.profileControllerStatus = .Photo
                self.navigationController?.present(picker, animated: true, completion: nil)
                
            } else {
                self.profileControllerStatus = .Photo
                self.navigationController?.present(picker, animated: true, completion: nil)
            }
            
            
        }
        
        let cameraAction = UIAlertAction(title: "Take a picture", style: .default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .camera
                picker.cameraCaptureMode = .photo
                picker.modalPresentationStyle = .fullScreen
                
                
                if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                    
                    picker.modalPresentationStyle = .popover
                    picker.popoverPresentationController?.delegate = self
                    //                    picker.popoverPresentationController?.sourceView = self.view
                    self.profileControllerStatus = .Photo
                    self.navigationController?.present(picker, animated: true, completion: nil)
                    
                } else {
                    self.profileControllerStatus = .Photo
                    self.navigationController?.present(picker, animated: true, completion: nil)
                }
                
                
                
            } else {
                self.noCamera()
            }
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(photoGalleryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            
            alertController.modalPresentationStyle = .popover
            alertController.popoverPresentationController?.delegate = self
            //            alertController.popoverPresentationController?.sourceView = view
            present(alertController, animated: true, completion: nil)
            
            
        } else {
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        
        popoverPresentationController.sourceView = userImageView
        popoverPresentationController.sourceRect = userImageView.bounds
        popoverPresentationController.permittedArrowDirections = .up
    }
    
    
    func noCamera() {
        
        showAlertMessage(vc: self, titleStr: "No Camera", messageStr: "Sorry, this device has no camera")
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImmageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            selectedImmageFromPicker = editedImage
            
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImmageFromPicker = originalImage
            
        }
        
        if let selectedImage = selectedImmageFromPicker {
            userImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
}

