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
import ProgressHUD
import UITextView_Placeholder
import NCMB

class DataStoreViewController: UIViewController {
    var currentObbjecId:String = ""
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Datastore"
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @IBAction func btnQuickStartClick(_ sender: Any) {
        ProgressHUD.show("Please wait...")
        // クラスのNCMBObjectを作成
        let object : NCMBObject = NCMBObject(className: "TestClass")
        // オブジェクトに値を設定
        object["message"] = "Hello, NCMB!"
        // データストアへの登録
        object.saveInBackground(callback: { result in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                switch result {
                case .success:
                    // 保存に成功した場合の処理
                    print("保存に成功しました")
                    Utils.showAlert(self, title: "Alert", message: "保存に成功しました")
                case let .failure(error):
                    // 保存に失敗した場合の処理
                    print("保存に失敗しました: \(error)")
                    Utils.showAlert(self, title: "Alert", message: "保存に失敗しました: \(error)")
                }
            }
        })
    }
    
    @IBAction func btnSaveClick(_ sender: Any) {
        ProgressHUD.show("Please wait...")
        // testクラスのNCMBObjectを作成
        let object : NCMBObject = NCMBObject(className: "test")
        
        // オブジェクトに値を設定
        object["fieldA"] = "Hello, NCMB!"
        object["fieldB"] = "日本語の内容"
        object["fieldC"] = 42
        object["fieldD"] = ["abcd", "efgh", "ijkl"]
        
        // データストアへの登録を実施
        object.saveInBackground(callback: { result in
            ProgressHUD.dismiss()
            switch result {
            case .success:
                // 保存に成功した場合の処理
                print("保存に成功しました")
                DispatchQueue.main.async {
                    Utils.showAlert(self, title: "Alert", message: "保存に成功しました")
                }
                self.currentObbjecId = object.objectId!
            case let .failure(error):
                // 保存に失敗した場合の処理
                print("保存に失敗しました: \(error)")
                DispatchQueue.main.async {
                    Utils.showAlert(self, title: "Alert", message: "保存に失敗しました: \(error)")
                }
            }
        })
    }
    
    @IBAction func btnGetClick(_ sender: Any) {
        if (self.currentObbjecId != "") {
            ProgressHUD.show("Please wait...")
            let object : NCMBObject = NCMBObject(className: "test")
            
            // objectIdプロパティを設定
            object.objectId = currentObbjecId
            
            object.fetchInBackground(callback: { result in
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                    switch result {
                    case .success:
                        // 取得に成功した場合の処理
                        print("取得に成功しました")
                        Utils.showAlert(self, title: "Alert", message: "取得に成功しました")
                        if let fieldB : String = object["fieldB"] {
                            print("fieldB value: \(fieldB)")
                        }
                    case let .failure(error):
                        // 取得に失敗した場合の処理
                        print("取得に失敗しました: \(error)")
                        Utils.showAlert(self, title: "Alert", message: "取得に失敗しました: \(error)")
                    }
                }
            })
        } else {
            print("There are no currentObjectId");
        }
    }
    
    @IBAction func btnUpdateClick(_ sender: Any) {
        if (currentObbjecId != "") {
            ProgressHUD.show("Please wait...")
            let object : NCMBObject = NCMBObject(className: "test")
            
            // objectIdプロパティを設定
            object.objectId = currentObbjecId
            object["fieldC"] = NCMBIncrementOperator(amount: 1)
            object.saveInBackground(callback: { result in
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
        } else {
            print("There are no currentObjectId");
        }
    }
    
    @IBAction func btnDeleteClick(_ sender: Any) {
        if (currentObbjecId != "") {
            ProgressHUD.show("Please wait...")
            let object : NCMBObject = NCMBObject(className: "test")
            object.objectId = currentObbjecId
            object.deleteInBackground(callback: { result in
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                    switch result {
                    case .success:
                        self.currentObbjecId = ""
                        print("削除に成功しました")
                        Utils.showAlert(self, title: "Alert", message: "削除に成功しました")
                    case let .failure(error):
                        print("削除に失敗しました: \(error)")
                        Utils.showAlert(self, title: "Alert", message: "削除に失敗しました: \(error)")
                    }
                }
            })
        } else {
            print("There are no currentObjectId");
        }
    }
    
    @IBAction func btnRankingClick(_ sender: Any) {
        ProgressHUD.show("Please wait...")
        var query = NCMBQuery.getQuery(className: "HighScore")
        
        //Scoreの降順でデータを取得するように設定
        query.order = ["Score"]
        
        //検索件数を5件に設定
        query.limit = 5;
        
        //データストアでの検索を行う
        query.findInBackground(callback: { result in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                switch result {
                case let .success(array):
                    print("取得に成功しました 件数: \(array.count)")
                    Utils.showAlert(self, title: "Alert", message: "取得に成功しました 件数: \(array.count)")
                case let .failure(error):
                    print("取得に失敗しました: \(error)")
                    Utils.showAlert(self, title: "Alert", message: "取得に失敗しました: \(error)")
                }
            }
        })
    }
    
    @IBAction func btnAclClick(_ sender: Any) {
        ProgressHUD.show("Please wait...")
        let sharedNote : NCMBObject = NCMBObject(className: "Note")
        sharedNote["content"] = "This note is shared!"
        
        //NCMBACLのインスタンスを作成
        var acl : NCMBACL = NCMBACL.empty
        
        //引数で渡された会員userへの読み込みと書き込み権限を設定する
        acl.put(key: "user1", readable: true, writable: true)
        
        //ACLをオブジェクトに設定する
        sharedNote.acl = acl
        
        sharedNote.saveInBackground(callback: { result in
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
}

