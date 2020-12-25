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
            ProgressHUD.dismiss()
            switch result {
                case .success:
                    // ログインに成功した場合の処理
                    print("匿名ユーザーでのログインに成功しました")
                    DispatchQueue.main.async {
                        Utils.showAlert(self, title: "Alert", message: "匿名ユーザーでのログインに成功しました")
                    }

                case let .failure(error):
                    // ログインに失敗した場合の処理
                    print("匿名ユーザーでのログインに失敗しました: \(error)")
                    DispatchQueue.main.async {
                        Utils.showAlert(self, title: "Alert", message: "匿名ユーザーでのログインに失敗しました: \(error)")
                    }
            }
        })

    }
    
    @IBAction func requestAuthenticationMail(_ sender: Any) {
        ProgressHUD.show("Loading...")
        NCMBUser.requestAuthenticationMailInBackground(mailAddress: "vfa.cancc+5@gmail.com", callback: { result in
            ProgressHUD.dismiss()
            switch result {
                case .success:
                    // 会員登録用メールの要求に成功した場合の処理
                    print("会員登録用メールの要求に成功しました")
                    DispatchQueue.main.async {
                        Utils.showAlert(self, title: "Alert", message: "会員登録用メールの要求に成功しました")
                    }
                case let .failure(error):
                    // 会員登録用のメール要求に失敗した場合の処理
                    print("会員登録用メールの要求に失敗しました: \(error)")
                    DispatchQueue.main.async {
                        Utils.showAlert(self, title: "Alert", message: "会員登録用メールの要求に失敗しました: \(error)")
                    }
            }
        })

    }
    
    @IBAction func loginWithMailAddr(_ sender: Any) {
        ProgressHUD.show("Loading...")
        NCMBUser.logInInBackground(mailAddress: "vfa.cancc@gmail.com", password: "12345", callback: { result in
            ProgressHUD.dismiss()
            switch result {
                case .success:
                    // ログインに成功した場合の処理
                    print("ログインに成功しました")
                    // ログイン状況の確認
                    if let user = NCMBUser.currentUser {
                        print("ログイン中のユーザー: \(user.userName!)")
                        DispatchQueue.main.async {
                            Utils.showAlert(self, title: "Alert", message: "ログイン中のユーザー: \(user.userName!)")
                        }
                    } else {
                        print("ログインしていません")
                        DispatchQueue.main.async {
                            Utils.showAlert(self, title: "Alert", message: "ログインしていません")
                        }
                    }

                case let .failure(error):
                    // ログインに失敗した場合の処理
                    print("ログインに失敗しました: \(error)")
                    DispatchQueue.main.async {
                        Utils.showAlert(self, title: "Alert", message: "ログインに失敗しました: \(error)")
                    }
            }
        })
           
    }
    
    @IBAction func addMemberToRole(_ sender: Any) {
        ProgressHUD.show("Loading...")
        //ユーザーを作成
        let user: NCMBUser = NCMBUser.init();
        user.userName = randomUser(length: 8)
        user.password = "password"
        user.signUp()
        goldUser = user

        //登録済みユーザーを新規ロールに追加
        let role : NCMBRole = NCMBRole.init(roleName: "goldPlan");
        role.addUserInBackground(user: user, callback: { result in
           ProgressHUD.dismiss()
           switch result {
           case .success:
                print("保存に成功しました")
                DispatchQueue.main.async {
                    Utils.showAlert(self, title: "Alert", message: "保存に成功しました")
                }
           case let .failure(error):
                 print("保存に失敗しました: \(error)")
                 DispatchQueue.main.async {
                     Utils.showAlert(self, title: "Alert", message: "保存に失敗しました: \(error)")
                 }
                 return;
           }
        })

    }
    
    @IBAction func removeMemberFromFole(_ sender: Any) {
        ProgressHUD.show("Loading...")
        var userQuery : NCMBQuery<NCMBUser> = NCMBUser.query
        userQuery.where(field: "userName", equalTo: goldUser.userName ?? "goldUser")
        userQuery.findInBackground(callback: { result in
           ProgressHUD.dismiss()
           switch result {
           case let .success(users):
                if let user = users.first {
                     var roleQuery : NCMBQuery<NCMBRole> = NCMBRole.query
                     roleQuery.where(field: "roleName", equalTo: "goldPlan")
                     roleQuery.findInBackground(callback: { result in
                        switch result {
                        case let .success(roles):
                            if let role = roles.first {
                               role.removeUserInBackground(user: user, callback: { result in
                                     switch result {
                                     case let .success(data):
                                        // 実行成功時の処理
                                        print("実行成功時の処理")
                                        DispatchQueue.main.async {
                                            Utils.showAlert(self, title: "Alert", message: "実行成功時の処理")
                                        }
                                     case let .failure(error):
                                        // 実行失敗時の処理v
                                        print("取得に失敗しました: \(error)")
                                        DispatchQueue.main.async {
                                            Utils.showAlert(self, title: "Alert", message: "取得に失敗しました: \(error)")
                                        }
                                        return;
                                     }
                               })
                                for obj in users {
                                   obj.delete();
                                }

                            } else {
                                DispatchQueue.main.async {
                                    Utils.showAlert(self, title: "Alert", message: "There no role with name goldPlan")
                                }
                            }
                        case let .failure(error):
                            print("取得に失敗しました: \(error)")
                            DispatchQueue.main.async {
                                Utils.showAlert(self, title: "Alert", message: "取得に失敗しました: \(error)")
                            }
                        }
                     })
                } else {
                    DispatchQueue.main.async {
                        Utils.showAlert(self, title: "Alert", message: "There no user to remove")
                    }
                }


           case let .failure(error):
                print("取得に失敗しました: \(error)")
                DispatchQueue.main.async {
                    Utils.showAlert(self, title: "Alert", message: "取得に失敗しました: \(error)")
                }
           }
        })
    }
    
    @IBAction func addChildRole(_ sender: Any) {
        ProgressHUD.show("Loading...")
        let adminRoleName = "Admin" + randomUser(length: 2)
        let administrators: NCMBRole = NCMBRole.init(roleName: adminRoleName)
        administrators.save()
        let moderators: NCMBRole = NCMBRole.init(roleName: "Moderators" + randomUser(length: 2))
        moderators.addRoleInBackground(role: administrators, callback: { result in
           ProgressHUD.dismiss()
           switch result {
           case .success:
                 print("保存に成功しました")
                DispatchQueue.main.async {
                    Utils.showAlert(self, title: "Alert", message: "保存に成功しました")
                }
           case let .failure(error):
                 print("保存に失敗しました: \(error)")
                 DispatchQueue.main.async {
                     Utils.showAlert(self, title: "Alert", message: "保存に失敗しました: \(error)")
                 }
                 return;
           }
        })
    }

    func randomUser(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}
