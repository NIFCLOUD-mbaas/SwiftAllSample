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

class FileStoreUITest: XCTestCase {

    var app: XCUIApplication!
    
    // MARK: - Setup for UI Test
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    func testFileStoreScreen() throws {
        app.launch()
        allowPushNotificationsIfNeeded()
        
        // Open FileStore screen from menu
        let leftBar: XCUIElement = app.navigationBars.buttons.element(boundBy: 0)
        if leftBar.waitForExistence(timeout: 20) {
            XCTAssert(leftBar.exists)
            leftBar.tap()
            app.tables.staticTexts["FileStore"].tap()
        } else {
            XCTFail("Menu button not exit.")
        }
        
        let btnUpload = app.buttons["btnUpload"]
        XCTAssert(btnUpload.exists)
        btnUpload.tap()
        self.chekMsgExist(msg: "保存に成功しました")
        
        let btnGet = app.buttons["btnGet"]
        XCTAssert(btnGet.exists)
        btnGet.tap()
        self.chekMsgExist(msg: "取得に成功しました:")
        
        let btnDelete = app.buttons["btnDelete"]
        XCTAssert(btnDelete.exists)
        btnDelete.tap()
        self.chekMsgExist(msg: "削除に成功しました")
    }
}
