//
//  ScriptViewController.swift
//  SwiftOperationCheck
//
//  Created by cancc on 7/2/20.
//  Copyright © 2020 CANCC. All rights reserved.
//

import Foundation
import NCMB
import ProgressHUD

class ScriptViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Script"
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
    }
    
    @IBAction func execScriptGET(_ sender: Any) {
        ProgressHUD.show("Loading...")
        let script = NCMBScript(name: "testScript_GET.js", method: .get)
        
        // スクリプトの実行
        script.executeInBackground(headers: [:], queries: [:], body: [:], callback: { result in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                switch result {
                case let .success(data):
                    // 実行成功時の処理
                    print("scriptSample 実行に成功しました: \(String(describing: data))")
                    Utils.showAlert(self, title: "Alert", message: "scriptSample 実行に成功しました: \(String(describing: data))")
                case let .failure(error):
                    // 実行失敗時の処理v
                    print("scriptSample 実行に失敗しました: \(error)")
                    Utils.showAlert(self, title: "Alert", message: "scriptSample 実行に失敗しました: \(error)")
                }
            }
        })
    }
    
    @IBAction func execScriptPOST(_ sender: Any) {
        ProgressHUD.show("Loading...")
        // 呼び出すスクリプトファイルとメソッドを指定
        let script = NCMBScript(name: "testScript_POST.js", method: .post)
        let headers : [String : String?] = ["username":"admin", "password":"123456"]
        let requestBody : [String : Any?] = ["field1":1, "field2":2]
        // スクリプトの実行
        script.executeInBackground(headers: headers, queries: [:], body: requestBody, callback: { result in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                switch result {
                case let .success(data):
                    // 実行成功時の処理
                    print("scriptPost 実行に成功しました: \(String(data: data ?? Data(), encoding: .utf8) ?? "" )")
                    Utils.showAlert(self, title: "Alert", message: "scriptPost 実行に成功しました: \(String(data: data ?? Data(), encoding: .utf8) ?? "" )")
                case let .failure(error):
                    // 実行失敗時の処理v
                    print("scriptPost 実行に失敗しました: \(error)")
                    Utils.showAlert(self, title: "Alert", message: "scriptPost 実行に失敗しました: \(error)")
                }
            }
        })
    }
    
    @IBAction func execScriptDEL(_ sender: Any) {
        ProgressHUD.show("Loading...")
        // スクリプトインスタンスの作成
        let script = NCMBScript(name: "testScript_DELETE.js", method: .delete)
        
        let headers : [String : String?] = ["username":"admin", "password":"123456"]
        let q : [String : String?] = ["id":"tRuaWXVPWXeRdwY9"]
        // スクリプトの実行
        script.executeInBackground(headers: headers, queries: q, body: [:], callback: { result in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                switch result {
                case let .success(data):
                    print("scriptDelete 実行に成功しました: \(String(data: data ?? Data(), encoding: .utf8) ?? "" )")
                    Utils.showAlert(self, title: "Alert", message: "scriptDelete 実行に成功しました: \(String(data: data ?? Data(), encoding: .utf8) ?? "" )")
                case let .failure(error):
                    print("scriptDelete 実行に失敗しました: \(error)")
                    Utils.showAlert(self, title: "Alert", message: "scriptDelete 実行に失敗しました: \(error)")
                }
            }
        })
    }
}
