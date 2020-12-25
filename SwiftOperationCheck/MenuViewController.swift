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

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private weak var table: UITableView!
    
    private var content: [Any] = []
    private var images: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.separatorStyle = .none
        content = ["Datastore", "Push Notification", "FileStore", "User Management", "Script", "Sign in with Apple"]
        images = ["datastore", "push", "file", "user", "script", "script"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cellMenu"
        var cell: UITableViewCell? = table.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell?.textLabel?.text = content[indexPath.row] as? String
        cell?.imageView?.image = UIImage(named: images[indexPath.row] as! String)
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "showDataStoreVC", sender: tableView)
        case 1:
            performSegue(withIdentifier: "showPushVC", sender: tableView)
        case 2:
            performSegue(withIdentifier: "showFileVC", sender: tableView)
        case 3:
            performSegue(withIdentifier: "showUserVC", sender: tableView)
        case 4:
            performSegue(withIdentifier: "showScriptVC", sender: tableView)
        case 5:
            performSegue(withIdentifier: "showLoginVC", sender: tableView)
        default:
            break
        }
    }

}
