//
//  AppleSignInViewController.swift
//  SwiftOperationCheck
//
//  Created by cancc on 7/2/20.
//  Copyright © 2020 CANCC. All rights reserved.
//

import UIKit
import NCMB
import ProgressHUD
import AuthenticationServices

class AppleSignInViewController: UIViewController {
    var appleParam: NCMBAppleParameters?
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var loginProviderStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Login With Apple"
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        setupProviderLoginView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performExistingAccountSetupFlows()
    }
    
    @IBAction func linkWithAppleCredentials(_ sender: Any) {
        if let user = NCMBUser.currentUser {
            if let params = self.appleParam {
                user.linkWithAppleToken(appleParameters: params, callback: { result in
                    switch result {
                    case .success:
                        //認証情報の紐付けが完了したあとの処理
                        print("会員連携完了しました。")
                    case let .failure(error):
                        //認証情報の紐付けに失敗した場合の処理
                        print("エラー: \(error)")
                    }
                })
            }
        } else {
            print("ログイン中ユーザがいません。")
        }
    }
    
    @IBAction func unlinkWithAppleCredentials(_ sender: Any) {
        if let user = NCMBUser.currentUser {
            user.unlink(type: "apple") { (result) in
                switch result {
                case .success:
                    // 認証情報の紐付け削除が完了したあとの処理
                    print("会員連携削除が完了しました。")
                case let .failure(error):
                    // 認証情報の紐付け削除が失敗した場合の処理
                    print("エラー: \(error)")
                }
            }
        } else {
            print("ログイン中ユーザがいません。")
        }
    }
    
    /// - Tag: add_appleid_button
    func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.loginProviderStackView.addArrangedSubview(authorizationButton)
    }
    
    // - Tag: perform_appleid_password_request
    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    /// - Tag: perform_appleid_request
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

extension AppleSignInViewController: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
            self.saveUserInKeychain(userIdentifier)
            
            // 認証情報による認証の場合、mobile backendに会員登録・認証を行う準備します
            let authorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: String.Encoding.utf8) ?? "Data could not be printed"
            //NCMBAppleParametersで発行された認証情報を指定します
            let appleParam = NCMBAppleParameters(id: appleIDCredential.user, accessToken: authorizationCode)
            self.appleParam = appleParam
            let user = NCMBUser()
            // mobile backendに会員登録・認証を行います
            user.signUpWithAppleToken(appleParameters: appleParam, callback: { result in
                switch result {
                case .success:
                    print("会員認証完了しました。")
                case let .failure(error):
                    print("エラー: \(error)")
                }})
            
            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
            
        case let passwordCredential as ASPasswordCredential:
            
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.example.apple-samplecode.juice", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    private func showResultViewController(userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "loginAppleSuccess", sender: self)
        }
    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// - Tag: did_complete_error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

extension AppleSignInViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
