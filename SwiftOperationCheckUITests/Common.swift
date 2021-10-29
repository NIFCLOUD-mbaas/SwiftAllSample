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
import XCTest
@testable import NCMB


//********** APIキーの設定 **********
let applicationkey = "YOUR_NCMB_APPLICATION_KEY"
let clientkey      = "YOUR_NCMB_CLIENT_KEY"

// Login with username
public let USERNAME_KEY = "Hoge"
public let PASSWORD_KEY = "123456"

class Common: NSObject {
    static let shared = Common()
    
    func setUp() {
        NCMB.initialize(applicationKey: applicationkey, clientKey: clientkey)
    }
    
    func createUserIfNotExist(userName: String, password: String) {
        NCMBUser.logInInBackground(userName: userName, password: password, callback: { result in
            switch result {
            case .success:
                break
                
            case .failure(_):
                let user = NCMBUser()
                user.userName = userName
                user.password = password
                user.signUpInBackground(callback: { result in
                    switch result {
                    case .success:
                        break
                    case let .failure(error):
                        print("createUserIfNotExist:\((error as NSError).code)")
                    }
                })
            }
        })
    }
    
    func deleteUserIfExist(userName: String, password: String) {
        NCMBUser.logInInBackground(userName: userName, password: password, callback: { result in
            switch result {
            case .success:
                let user = NCMBUser()
                user.objectId = NCMBUser.currentUser?.objectId
                user.deleteInBackground(callback: { result in
                    switch result {
                    case .success:
                        break
                    case let .failure(error):
                        print("deleteUserIfExist:\((error as NSError).code)")
                    }
                })
            case .failure(_):
                break
            }
        })
    }
}

extension XCTestCase {
    func allowPushNotificationsIfNeeded() {
        addUIInterruptionMonitor(withDescription: "Remote Authorization") { alerts -> Bool in
            if alerts.buttons["Allow"].exists {
                alerts.buttons["Allow"].tap()
                return true
            }
            return false
        }
        XCUIApplication().tap()
    }
    
    func chekMsgExist(msg: String) {
        let predicate = NSPredicate(format: "label BEGINSWITH %@", msg)
        let lblMsg = XCUIApplication().alerts["Alert"].staticTexts.element(matching: predicate)
        if lblMsg.waitForExistence(timeout: 20) {
            XCTAssert(lblMsg.exists)
            XCUIApplication().alerts.firstMatch.buttons.element(boundBy: 0).tap()
        } else {
            XCTFail("Does not match message.")
        }
    }
    
    func waiterResultWithExpectation(_ element: XCUIElement) -> XCTWaiter.Result {
        let myPredicate = NSPredicate(format: "exists == true")
        let myExpectation = XCTNSPredicateExpectation(predicate: myPredicate, object: element)
        let result = XCTWaiter().wait(for: [myExpectation], timeout: 180)
        return result
    }
}
