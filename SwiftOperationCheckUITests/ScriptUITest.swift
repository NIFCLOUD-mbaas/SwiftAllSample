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

class ScriptUITest: XCTestCase {
    
    var app: XCUIApplication!
    
    // MARK: - Setup for UI Test
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    func testScriptScreen() throws {
        app.launch()
        allowPushNotificationsIfNeeded()
        
        // Open Script screen from menu
        let leftBar: XCUIElement = app.navigationBars.buttons.element(boundBy: 0)
        if leftBar.waitForExistence(timeout: 20) {
            XCTAssert(leftBar.exists)
            leftBar.tap()
            app.tables.staticTexts["Script"].tap()
        } else {
            XCTFail("Menu button not exit.")
        }
        
        let btnScriptGet = app.buttons["btnScriptGet"]
        XCTAssert(btnScriptGet.exists)
        btnScriptGet.tap()
        self.chekMsgExist(msg: "scriptSample 実行に成功しました:")
        
        let btnScriptPost = app.buttons["btnScriptPost"]
        XCTAssert(btnScriptPost.exists)
        btnScriptPost.tap()
        self.chekMsgExist(msg: "scriptPost 実行に成功しました:")
        
        let btnScriptDelete = app.buttons["btnScriptDelete"]
        XCTAssert(btnScriptDelete.exists)
        btnScriptDelete.tap()
        self.chekMsgExist(msg: "scriptDelete 実行に成功しました:")
    }
}
