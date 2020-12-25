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

class FilestoreViewController: UIViewController {
    var pickerPreData: [AnyHashable] = []
    var arrTbvData: [Any] = []
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "File Store"
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
    }
    
    @IBAction func uploadFile(_ sender: Any) {
        ProgressHUD.show("Please wait...")
        let data : Data = "NIF Cloud mobile backend".data(using: .utf8)!
        // ファイルオブジェクトの作成
        let file : NCMBFile = NCMBFile(fileName: "ncmb.txt")
        // アップロード
        file.saveInBackground(data: data, callback: { result in
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
    
    @IBAction func getFile(_ sender: Any) {
        ProgressHUD.show("Please wait...")
        // ファイル名の指定
        let file : NCMBFile = NCMBFile(fileName: "ncmb.txt")

        // ファイルの取得
        file.fetchInBackground(callback: { result in
            ProgressHUD.dismiss()
            switch result {
                case let .success(data):
                    print("取得に成功しました: \(String(describing: data))")
                    DispatchQueue.main.async {
                        Utils.showAlert(self, title: "Alert", message: "取得に成功しました: \(String(describing: data))")
                    }
                case let .failure(error):
                    print("取得に失敗しました: \(error)")
                    DispatchQueue.main.async {
                        Utils.showAlert(self, title: "Alert", message: "取得に失敗しました: \(error)")
                    }
                    return;
            }
        })

    }
    
    @IBAction func deleteFile(_ sender: Any) {
        ProgressHUD.show("Please wait...")
        // ファイルオブジェクトの作成
        let file : NCMBFile = NCMBFile(fileName: "ncmb.txt")

        // ファイルの削除
        file.deleteInBackground(callback: { result in
            ProgressHUD.dismiss()
            switch result {
                case .success:
                    print("削除に成功しました")
                    DispatchQueue.main.async {
                        Utils.showAlert(self, title: "Alert", message: "削除に成功しました")
                    }
                case let .failure(error):
                    print("削除に失敗しました: \(error)")
                    DispatchQueue.main.async {
                        Utils.showAlert(self, title: "Alert", message: "削除に失敗しました: \(error)")
                    }
                    return;
            }
        })

    }
}
