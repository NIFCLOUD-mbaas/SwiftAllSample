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

import XCTest

class DataStoreUITest: XCTestCase {
    
    var app: XCUIApplication!
    
    // MARK: - Setup for UI Test
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    func testDataStoreScreen() throws {
        app.launch()
        allowPushNotificationsIfNeeded()
        
        let btnQuickStart = app.buttons["btnQuickStart"]
        XCTAssert(btnQuickStart.exists)
        btnQuickStart.tap()
        self.chekMsgExist(msg: "保存に成功しました")
        
        let btnSave = app.buttons["btnSave"]
        XCTAssert(btnSave.exists)
        btnSave.tap()
        self.chekMsgExist(msg: "保存に成功しました")
        
        let btnGetObject = app.buttons["btnGetObject"]
        XCTAssert(btnGetObject.exists)
        btnGetObject.tap()
        self.chekMsgExist(msg: "取得に成功しました")
        
        let btnUpdateObject = app.buttons["btnUpdateObject"]
        XCTAssert(btnUpdateObject.exists)
        btnUpdateObject.tap()
        self.chekMsgExist(msg: "保存に成功しました")
        
        let btnDeleteObject = app.buttons["btnDeleteObject"]
        XCTAssert(btnDeleteObject.exists)
        btnDeleteObject.tap()
        self.chekMsgExist(msg: "削除に成功しました")
        
        let btnQueryRanking = app.buttons["btnQueryRanking"]
        XCTAssert(btnQueryRanking.exists)
        btnQueryRanking.tap()
        self.chekMsgExist(msg: "取得に成功しました 件数:")
        
        let btnACL = app.buttons["btnACL"]
        XCTAssert(btnACL.exists)
        btnACL.tap()
        self.chekMsgExist(msg: "保存に成功しました")
    }
}
