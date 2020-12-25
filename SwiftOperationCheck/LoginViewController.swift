//
//  LoginViewController.swift
//  SwiftSegmentUserApp
//
//  Created by FJCT on 2016/10/31.
//  Copyright 2019 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
//

import UIKit
import NCMB

class LoginViewController: UIViewController {
    // User Name
    @IBOutlet weak var userNameTextField: UITextField!
    // Password
    @IBOutlet weak var passwordTextField: UITextField!
    // errorLabel
    @IBOutlet weak var errorLabel: UILabel!
    
    // 画面表示時に実行される
    override func viewDidLoad() {
        super.viewDidLoad()
        // Passwordをセキュリティ入力に設定する
        self.passwordTextField.isSecureTextEntry = true
        
    }
    
    // Loginボタン押下時の処理
    @IBAction func loginBtn(_ sender: UIButton) {
        // キーボードを閉じる
        closeKeyboad()
        
        // 入力確認
        if self.userNameTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty {
            self.errorLabel.text = "未入力の項目があります"
            // TextFieldを空に
            self.cleanTextField()
            
            return
            
        }
        
        NCMBUser.logInInBackground(userName: self.userNameTextField.text!, password: self.passwordTextField.text!, callback: { result in
            // TextFieldを空に
            DispatchQueue.main.async {
                self.cleanTextField()
            }
            
            switch result {
            case .success:
                // ログインに成功した場合の処理
                print("ログインに成功しました")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "loginSuccess", sender: self)
                }
                
            case let .failure(error):
                // 新規登録失敗時の処理
                DispatchQueue.main.async {
                    self.errorLabel.text = "ログインに失敗しました:\(error)"
                }
                print("ログインに失敗しました:\(error)")
            }
        })
        
    }
    
    // SignUp画面へ遷移
    @IBAction func toSignUp(_ sender: UIButton) {
        // TextFieldを空にする
        cleanTextField()
        // errorLabelを空に
        cleanErrorLabel()
        // キーボードを閉じる
        closeKeyboad()
        
        self.performSegue(withIdentifier: "loginToSignUp", sender: self)
        
    }
    
    // 背景タップするとキーボードを隠す
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        
    }
    
    // TextFieldを空にする
    func cleanTextField(){
        userNameTextField.text = ""
        passwordTextField.text = ""
        
    }
    
    // errorLabelを空にする
    func cleanErrorLabel(){
        errorLabel.text = ""
        
    }
    
    // キーボードを閉じる
    func closeKeyboad(){
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }

}
