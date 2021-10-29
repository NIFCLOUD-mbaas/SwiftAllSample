/*
 Copyright 2017-2018 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation
import NCMB
import ProgressHUD

class UserViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    private var goldUser: NCMBUser = NCMBUser.init()
    private var roleName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "User Management"
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @IBAction func createNewUser(_ sender: Any) {
        self.performSegue(withIdentifier: "login", sender: self)
    }
    
    @IBAction func anonymousLogin(_ sender: Any) {
        ProgressHUD.show("Loading...")
        
        // 匿名ユーザの自動生成を有効化
        NCMBUser.enableAutomaticUser()
        
        // 匿名ユーザーでのログイン
        NCMBUser.automaticCurrentUserInBackground(callback: { result in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                switch result {
                case .success:
                    // ログインに成功した場合の処理
                    print("匿名ユーザーでのログインに成功しました")
                    Utils.showAlert(self, title: "Alert", message: "匿名ユーザーでのログインに成功しました")
                case let .failure(error):
                    // ログインに失敗した場合の処理
                    print("匿名ユーザーでのログインに失敗しました: \(error)")
                    Utils.showAlert(self, title: "Alert", message: "匿名ユーザーでのログインに失敗しました: \(error)")
                }
            }
        })
    }
    
    @IBAction func requestAuthenticationMail(_ sender: Any) {
        ProgressHUD.show("Loading...")
        NCMBUser.requestAuthenticationMailInBackground(mailAddress: REQUEST_AUTHENTICATION_MAIL_KEY, callback: { result in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                switch result {
                case .success:
                    // 会員登録用メールの要求に成功した場合の処理
                    print("会員登録用メールの要求に成功しました")
                    Utils.showAlert(self, title: "Alert", message: "会員登録用メールの要求に成功しました")
                case let .failure(error):
                    // 会員登録用のメール要求に失敗した場合の処理
                    print("会員登録用メールの要求に失敗しました: \(error)")
                    Utils.showAlert(self, title: "Alert", message: "会員登録用メールの要求に失敗しました: \(error)")
                }
            }
        })
    }
    
    @IBAction func loginWithMailAddr(_ sender: Any) {
        ProgressHUD.show("Loading...")
        NCMBUser.logInInBackground(mailAddress: EMAIL_KEY, password: PASSWORD_KEY, callback: { result in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                switch result {
                case .success:
                    // ログインに成功した場合の処理
                    print("ログインに成功しました")
                    // ログイン状況の確認
                    if let user = NCMBUser.currentUser {
                        print("ログイン中のユーザー: \(user.userName!)")
                        Utils.showAlert(self, title: "Alert", message: "ログイン中のユーザー: \(user.userName!)")
                    } else {
                        print("ログインしていません")
                        Utils.showAlert(self, title: "Alert", message: "ログインしていません")
                    }
                case let .failure(error):
                    // ログインに失敗した場合の処理
                    print("ログインに失敗しました: \(error)")
                    Utils.showAlert(self, title: "Alert", message: "ログインに失敗しました: \(error)")
                }
            }
        })
    }
    
    @IBAction func addMemberToRole(_ sender: Any) {
        ProgressHUD.show("Loading...")
        //ユーザーを作成
        let user: NCMBUser = NCMBUser.init();
        user.userName = randomWithLength(8)
        user.password = PASSWORD_KEY
        _ = user.signUp()
        goldUser = user
        
        //登録済みユーザーを新規ロールに追加
        roleName = randomWithLength(8)
        let role : NCMBRole = NCMBRole.init(roleName: roleName);
        role.addUserInBackground(user: user, callback: { result in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                switch result {
                case .success:
                    print("保存に成功しました")
                    Utils.showAlert(self, title: "Alert", message: "保存に成功しました")
                case let .failure(error):
                    print("保存に失敗しました: \(error)")
                    Utils.showAlert(self, title: "Alert", message: "保存に失敗しました: \(error)")
                }
            }
        })
    }
    
    @IBAction func removeMemberFromFole(_ sender: Any) {
        if (goldUser.userName == nil) {
            DispatchQueue.main.async {
                Utils.showAlert(self, title: "Alert", message: "There no user to remove")
            }
            return
        }
        ProgressHUD.show("Loading...")
        var roleQuery : NCMBQuery<NCMBRole> = NCMBRole.query
        roleQuery.where(field: "roleName", equalTo: roleName)
        roleQuery.findInBackground(callback: { result in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                switch result {
                case let .success(roles):
                    if let role = roles.first {
                        role.removeUserInBackground(user: self.goldUser, callback: { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(_):
                                    // 実行成功時の処理
                                    print("実行成功時の処理")
                                    Utils.showAlert(self, title: "Alert", message: "実行成功時の処理")
                                case let .failure(error):
                                    // 実行失敗時の処理v
                                    print("取得に失敗しました: \(error)")
                                    Utils.showAlert(self, title: "Alert", message: "取得に失敗しました: \(error)")
                                }
                                
                                _ = self.goldUser.delete()
                                self.goldUser = NCMBUser.init()
                            }
                        })
                    } else {
                        Utils.showAlert(self, title: "Alert", message: "There no role with name \(self.roleName)")
                    }
                case let .failure(error):
                    print("取得に失敗しました: \(error)")
                    Utils.showAlert(self, title: "Alert", message: "取得に失敗しました: \(error)")
                }
            }
        })
    }
    
    @IBAction func addChildRole(_ sender: Any) {
        ProgressHUD.show("Loading...")
        let adminRoleName = "Admin" + randomWithLength(2)
        let administrators: NCMBRole = NCMBRole.init(roleName: adminRoleName)
        _ = administrators.save()
        let moderators: NCMBRole = NCMBRole.init(roleName: "Moderators" + randomWithLength(2))
        moderators.addRoleInBackground(role: administrators, callback: { result in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                switch result {
                case .success:
                    print("保存に成功しました")
                    Utils.showAlert(self, title: "Alert", message: "保存に成功しました")
                case let .failure(error):
                    print("保存に失敗しました: \(error)")
                    Utils.showAlert(self, title: "Alert", message: "保存に失敗しました: \(error)")
                }
            }
        })
    }
    
    func randomWithLength(_ length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}
