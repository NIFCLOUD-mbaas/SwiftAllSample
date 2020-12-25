//
//  LogoutViewController.swift
//  SwiftOperationCheck
//
//  Created by cancc on 7/3/20.
//  Copyright © 2020 CANCC. All rights reserved.
//

import UIKit
import NCMB
import ProgressHUD

class LogoutViewController: UIViewController {
    @IBOutlet weak var btnLogout: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogout.layer.cornerRadius = 9
        
        if let user = NCMBUser.currentUser {
            print("ログイン中のユーザー: \(user.userName!)")
            DispatchQueue.main.async {
                Utils.showAlert(self, title: "Alert", message: "ログイン中のユーザー: \(user.userName!)")
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        ProgressHUD.show("Loading...")
        // ログアウト
        NCMBUser.logOutInBackground(callback: { result in
            ProgressHUD.dismiss()
            switch result {
                case .success:
                    // ログアウトに成功した場合の処理
                    print("ログアウトに成功しました")
                    DispatchQueue.main.async {
                        if let navController = self.navigationController {
                            navController.popViewController(animated: true)
                        }
                    }

                case let .failure(error):
                    // ログアウトに失敗した場合の処理
                    print("ログアウトに失敗しました: \(error)")
                    DispatchQueue.main.async {
                        Utils.showAlert(self, title: "Alert", message: "ログアウトに失敗しました: \(error)")
                    }
            }
        })
           
    }
}
